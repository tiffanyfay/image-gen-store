#!/bin/sh

for prompt in "$@"; do
    
    echo "Creating job for prompt: $prompt"
    export PROMPT=$prompt
    # Create job name with a random random string
    export RANDOM_STRING=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9' | head -c 5)
    
    
    # Create job
    envsubst < k8s/job-image-gen-store.yaml | kubectl apply -f -
done