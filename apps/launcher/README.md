# Launcher

**Table of Contents**
- [Launcher](#launcher)
  - [Trying to run kubectl commands inside of a pod:](#trying-to-run-kubectl-commands-inside-of-a-pod)
  - [RBAC](#rbac)
  - [Build and push image](#build-and-push-image)
  - [Run the app](#run-the-app)
  - [Resources](#resources)
    - [RBAC](#rbac-1)


## Trying to run kubectl commands inside of a pod:
```console
kubectl -n gen run -it tester --rm --image=cgr.dev/chainguard/kubectl -- get jobs
```

## RBAC
First we need RBAC permissions to be able to create jobs so we will create a role and rolebinding. A role defines what a user/group etc can do with certain resources. And a rolebinding binds this role to a service account. 

TODO: create a service account too vs using the default

```console
kubectl apply -f k8s/role-create-jobs.yaml
kubectl apply -f k8s/rolebinding-create-jobs.yaml
```

We need to be able to access the service for the database to get the external IP as well.
```console
kubectl apply -f k8s/role-get-services.yaml
kubectl apply -f k8s/rolebinding-get-services.yaml
```

TODO: solve warning `warning: couldn't attach to pod/tester, falling back to streaming logs: unable to upgrade connection: container tester not found in pod tester_gen`

Verify you now have permissions to see jobs in the `gen` namespace:
```console
kubectl -n gen run -it tester --rm --image=cgr.dev/chainguard/kubectl -- get jobs
```

## Build and push image
```console
# Change image to your image name depending on your registry
export IMAGE_GEN_STORE_LAUNCHER_IMAGE=<image-gen-store-launcher:v1>
```

```console
docker build -t $IMAGE_GEN_STORE_LAUNCHER_IMAGE .
docker push $IMAGE_GEN_STORE_LAUNCHER_IMAGE
```

## Run the app
Verify `$IMAGE_GEN_STORE_IMAGE` is set:
```console
echo $IMAGE_GEN_STORE_IMAGE
```

```console
kubectl -n gen run image-gen-store-launcher \
    --image=$IMAGE_GEN_STORE_LAUNCHER_IMAGE \
    --restart=OnFailure \
    --env IMAGE_GEN_STORE_IMAGE=$IMAGE_GEN_STORE_IMAGE \
    -- "a group of baby raccoons" "snow in the mountains with unicorns and rainbows"
```

Look at your jobs:
```console
kubectl -n gen get jobs
```

Check your annotations happened:
```console
kubectl -n get jobs --output=jsonpath='{range .items[*]}{.metadata.name}: {.metadata.annotations}{"\n"}{end}'
```

## Resources
### RBAC
[Talk I gave](https://www.youtube.com/watch?v=mD-Dng2QbQ0&ab_channel=DevoxxFR)
[Slides for the talk](https://speakerdeck.com/tiffanyfay/beyond-cluster-admin-getting-started-with-kubernetes-users-and-permissions)
