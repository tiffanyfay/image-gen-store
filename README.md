# Image Gen Demo

At a very high level, this demo uses generative AI with OpenAI to take in prompts, generates images with Dall-E and places them into a database. It consists of three parts, which are explained later.

**Table of Contents**
- [Image Gen Demo](#image-gen-demo)
  - [Prerequisites](#prerequisites)
    - [Infrastructure](#infrastructure)
      - [Set up DigitalOcean Infrastructure](#set-up-digitalocean-infrastructure)
  - [Architecture](#architecture)
  - [Applications](#applications)
    - [Launcher](#launcher)
    - [Image Generator and Database store](#image-generator-and-database-store)
    - [Database](#database)
  - [Things to do](#things-to-do)
  - [TODO](#todo)
    - [Nice to have by demo](#nice-to-have-by-demo)
    - [Future work](#future-work)


## Prerequisites
Have the following CLIs:
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [docker](https://docs.docker.com/engine/install/)
- [jq](https://jqlang.github.io/jq/download/)
- [envsubst](https://pypi.org/project/envsubst/) (if you don't have it by default)
- [k9s](https://k9scli.io/topics/install/)

**TODO*: add kubens to not need `-n gen`*

Other:
- An OpenAI API key and API access
  
**TODO*: add docs link*

### Infrastructure
We will need a:
- Kubernetes cluster
- Container registry
- PostgreSQL database

#### Set up DigitalOcean Infrastructure
If you use the Hivenetes k8s boostrapper you can have it create all of these resources for you:
![](static/digital-ocean-infra.png)

1. Clone https://github.com/hivenetes/k8s-bootstrapper
2. Follow the [Terraform instructions](https://github.com/hivenetes/k8s-bootstrapper/blob/main/infrastructure/terraform/README.md)

  > ***Note**: Enable the database in `bootstrapper.tfvars` before running `terraform plan`. You can also enable the container registry if you want to use it instead of Docker Hub.*

## Architecture
![](static/architecturev2.png)

## Applications

### Launcher
This application takes in prompts for OpenAI and launches jobs for each prompt.

### Image Generator and Database store
This app uses bash to talk to the OpenAI API to create a Dall-E image. It then stores these prompts and image URLs into a database.

### Database
This is a Java application that uses Spring Data and Spring Web to create a database table and REST endpoint to make GET and POST requests. It's specifically for a PostgreSQL database.

## Things to do
0. Create gen namespace 
   ```console
   kubectl apply -f k8s/namespace.yaml
   ```
1. [Create and run database app](apps/image-database/README.md)
2. [Create and run image generator and store app](apps/image-gen-store/README.md)
3. [Create and run launcher app](apps/launcher/README.md)
4. [Observability](observability/README.md)

## TODO
### Nice to have by demo
- [ ] Display prompts and URLs as images on webpage

### Future work
- [ ] Use DigitalOcean spaces to store secrets
- [ ] Use secrets for database application.properties
- [ ] Create service account vs using default one
- [ ] Have a webpage to put prompts into vs running a pod
- [ ] Add image creation dates so the database can drop anything that has a timestamp before a current subset -- e.g. OpenAI Dall-E only stores images for an hour, so after this, the URLs don't work.
- [ ] Add tests
