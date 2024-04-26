#!/bin/bash

# Check if /etc/secret-volume/open-api-key exists
if [ ! -f "/etc/secret-volume/open-api-key" ]; then
  echo "/etc/secret-volume/open-api-key does not exist"
  exit 1
fi

OPENAI_API_KEY="$(cat /etc/secret-volume/open-api-key)"
PROMPT=$1

# Check if prompt is empty
if [ -z "$PROMPT" ]; then
  echo "Prompt is empty. Please provide a prompt."
  exit 1
fi

# Make request to OpenAI to generate image based on prompt
RESPONSE=$(curl -s https://api.openai.com/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
      "model": "dall-e-3",
      "prompt": "'"$PROMPT"'",
      "n": 1,
      "size": "1024x1024"
  }')

echo $RESPONSE
URL=$(echo $RESPONSE | jq -r '.data[0].url')
echo "Adding to database:"
echo "Prompt: $PROMPT"
echo "URL: $URL"

if [ -z "$URL" ]; then
  echo "Could not generate image from prompt"
  exit 1
fi

# Get the IP of the image-database service
IP=$(kubectl get services -n gen image-database \
  --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Database external IP: $IP"

# If the IP is empty, fall back to localhost
if [ -z "$IP" ]; then
  echo "Could not find IP for image-database service, falling back to localhost:8080"
  IP="localhost"
  # Check if localhost:8080 is reachable
  if ! curl -s -o /dev/null -w "%{http_code}" localhost:8080; then
    echo "localhost:8080 is not reachable"
    exit 1
  fi
fi

# Add prompt and URL to database
curl -s -v -X POST $IP:8080/images \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "'"$PROMPT"'", 
    "url": "'"$URL"'"
  }'

