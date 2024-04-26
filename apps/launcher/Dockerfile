FROM nixery.dev/shell/kubectl/envsubst

WORKDIR /app
COPY launcher.sh /app/
COPY k8s/job-image-gen-store.yaml /app/k8s/

RUN chmod +x launcher.sh

ENTRYPOINT ["/app/launcher.sh"]
