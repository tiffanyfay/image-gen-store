# FROM curlimages/curl:8.6.0
FROM nixery.dev/shell/curl/jq/kubectl

WORKDIR /app
COPY image-gen-store.sh /app/

RUN chmod +x image-gen-store.sh

ENTRYPOINT ["/app/image-gen-store.sh"]

