# Observability

## Metrics
Install `metrics-server`. You can do this with the Hivenetes k8s-bootstrapper by following [these instructions](https://github.com/hivenetes/k8s-bootstrapper/tree/main/bootstrap).

Install [`krew`](https://krew.sigs.k8s.io/docs/user-guide/setup/install/), a Kubernetes plugin manager

```console
kubectl krew install view-allocations
```

Now we can see a bunch of cool metrics of CPU/memory utilization within our cluster:
```console
kubectl view-allocations
```

## Robusta
Follow the instructions on the Hivenetes k8s-bootstrapper [docs](https://github.com/hivenetes/k8s-bootstrapper/tree/main/observability).

## Cilium
Terminal 1
```
cilium hubble port-forward
```

Terminal 2
```
hubble observe
cilium hubble ui
```