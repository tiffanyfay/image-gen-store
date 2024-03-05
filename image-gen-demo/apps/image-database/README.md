# Image Database

Table of Contents
- [Image Database](#image-database)
  - [Prerequisites](#prerequisites)
  - [Building image-database app](#building-image-database-app)
    - [Cloud Native Buildpacks](#cloud-native-buildpacks)
    - [JIB](#jib)
  - [Push App to registry](#push-app-to-registry)
    - [Export PostgreSQL environment variables](#export-postgresql-environment-variables)
      - [With DigitalOcean Databases](#with-digitalocean-databases)
    - [\[Optional\] Testing](#optional-testing)
    - [Push image to your container registry](#push-image-to-your-container-registry)
  - [Resources](#resources)


## Prerequisites
CLIs
- jq
- doctl
- docker
- envsubst

## Building image-database app
First, ensure you're logged into the Container Registry you expect to be in:

### Cloud Native Buildpacks
Build and push image:
```console
# Replace image with your image name
./mvnw spring-boot:build-image \
    -Dspring-boot.build-image.imageName=<image-database:v1>
```

### JIB
```console
./mvnw compile com.google.cloud.tools:jib-maven-plugin:3.3.2:dockerBuild \
    -Dimage=<image-database:v1>
```

## Push App to registry
This is only needed if the image isn't automatically pushed up.

```shell
export IMAGE_DATABASE_IMAGE=<image-database:v1>
```
```console
docker push $IMAGE_DATABASE_IMAGE
```

### Export PostgreSQL environment variables
```shell
export POSTGRES_HOST=<host>
export POSTGRES_PORT=25060
export POSTGRES_DATABASE=defaultdb
export POSTGRES_USERNAME=doadmin
export POSTGRES_PASSWORD=<password>
```

#### With DigitalOcean Databases
```shell
export DO_DATABASE_ID=<id-goes-here> 
echo $DO_DATABASE_ID

export POSTGRES_HOST=$(doctl database get $DO_DATABASE_ID -o json | jq '.[0].connection.host') 
echo $POSTGRES_HOST
export POSTGRES_PORT=25060
export POSTGRES_DATABASE=defaultdb
export POSTGRES_USERNAME=doadmin
export POSTGRES_PASSWORD=$(doctl database get $DO_DATABASE_ID -o json | jq '.[0].connection.password')
```

### [Optional] Testing
Test your containerized app works:
```console
docker run -p 8080:8080 -e POSTGRES_HOST=$POSTGRES_HOST -e POSTGRES_PORT=25060 -e POSTGRES_DATABASE=defaultdb -e POSTGRES_USERNAME=doadmin -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD $IMAGE_DATABASE_IMAGE
```

### Push image to your container registry
```console
docker push $IMAGE_DATABASE_IMAGE
``` 

Verify variables are filled in:
```console
envsubst < k8s/deployment-image-database.yaml
```

*TODO: use secrets for password*

Create deployment and service:
```console
envsubst < k8s/deployment-image-database.yaml | kubectl apply -f -
kubectl apply -f k8s/service-image-database.yaml
```

Look for loadbalancer service external IP:
```console
kubectl -n gen get service image-database -w
```

For testing purposes, if you don't feel like waiting on the LoadBalancer (it's about 5 minutes on DigitalOcean), you can port-forward:
```console
kubectl -n gen port-forward deployment/image-database 8080:8080
```

## Resources
Spring Data
- https://spring.io/guides/gs/accessing-data-jpa
- https://spring.io/guides/gs/accessing-data-mysql/
- https://hackernoon.com/using-postgres-effectively-in-spring-boot-applications

DigitalOcean Managed PostgreSQL Database
- https://docs.digitalocean.com/products/databases/postgresql/