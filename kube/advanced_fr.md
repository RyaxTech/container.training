# Isolation and network policies

- Namespaces *do not* provide isolation

- A pod in the `green` namespace can communicate with a pod in the `blue` namespace

- A pod in the `default` namespace can communicate with a pod in the `kube-system` namespace

- `kube-dns` uses a different subdomain for each namespace

- Example: from any pod in the cluster, you can connect to the Kubernetes API with:

  `https://kubernetes.default.svc.cluster.local:443/`

---

## Isolating pods

- Actual isolation is implemented with *network policies*

- Network policies are resources (like deployments, services, namespaces...)

- Network policies specify which flows are allowed:

  - between pods

  - from pods to the outside world

  - and vice-versa

---

## Network policies overview

- We can create as many network policies as we want

- Each network policy has:

  - a *pod selector*: "which pods are targeted by the policy?"

  - lists of ingress and/or egress rules: "which peers and ports are allowed or blocked?"

- If a pod is not targeted by any policy, traffic is allowed by default

- If a pod is targeted by at least one policy, traffic must be allowed explicitly

---

## More about network policies

- This remains a high level overview of network policies

- For more details, check:

  - the [Kubernetes documentation about network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

  - this [talk about network policies at KubeCon 2017 US](https://www.youtube.com/watch?v=3gGpMmYeEO8) by [@ahmetb](https://twitter.com/ahmetb)

---

## Exercises on network policies

.exercise[
- To execute some exercises on network policies we will follow some examples from here: 
  https://github.com/ahmetb/kubernetes-network-policy-recipes
]
---

# Deploy Jupiter on Kubernetes

.exercise[
- We will follow the procedure provided here: 
  https://zonca.github.io/2017/12/scalable-jupyterhub-kubernetes-jetstream.html
]

---
--- 

# Advanced scheduling with Kubernetes

.exercise[
- We will follow the procedure provided here: 
   https://github.com/RyaxTech/kube-tutorial#4-activate-an-advanced-scheduling-policy-and-test-its-usage
]
---
---
# Autoscaling with Kubernetes

.exercise[
- We will follow the procedure provided here: 
  https://github.com/RyaxTech/kube-tutorial#6-enable-and-use-pod-autoscaling
]
---
---
# Big Data analytics on Kubernetes

.exercise[
- We will follow the procedure provided here:
https://github.com/RyaxTech/kube-tutorial#3-execute-big-data-job-with-spark-on-the-kubernetes-cluster
]

