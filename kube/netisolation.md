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

(The CNI plugin has to support the *NetworkPolicy*)
---

## Network policies overview

- We can create as many network policies as we want

- Each network policy has:

  - a *pod selector*: "which pods are targeted by the policy?"

  - lists of ingress and/or egress rules: "which peers and ports are allowed or blocked?"

- If a pod is not targeted by any policy, traffic is allowed by default

- If a pod is targeted by at least one policy, traffic must be allowed explicitly

---

## Example of network policies

.exercise[

- Let's deploy a nginx.
  ```bash
kubectl run nginx --image=nginx --replicas=2
kubectl expose deployment nginx --port=80
  ```

- Let's see if everything has gone well
  ```bash
kubectl get svc,pod | grep nginx
  ```

]

---

## Example of network policies

.exercise[

- Let's test a service from a pod
  ```bash
kubectl run -i --tty interactivetest --image=alpine --restart=Never --rm -- sh
  ```
(this will start an interactive session where the keyboard inputs and terminal outputs are redirected for a pod called *interactivetest* that contains a container *alpine*, which will never be restarted, it will be deleted when the command is finished and which will start the command *sh*)

- Let's verify the acces to nginx:
  ```bash
wget -qO- nginx
  ```

]

---

## Let's block all traffic

.exercise[

- Create a yaml file that contains:
```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
        name: access-nginx
spec:
        podSelector:
                matchLabels:
                        run: nginx
        ingress:
        - from:
            - podSelector:
                matchLabels:
                    iamnice: yeah
```
- and now deploy it.

]

---

## Is all traffic blocked?

.exercise[

- Let's try to connect to nginx:

  ```bash
wget -qO- nginx
```

- The traffic should be blocked!

]
---

## Block all traffic except *iamnice*

.exercise[

- Let's restart our test pod with the good labels (ctrl+d or exit to leave the previous one):

  ```bash
kubectl run -i --tty interactivetest --image=alpine --labels="iamnice=yeah" --restart=Never --rm -- sh
```

From this pod the acces should be allowed.
  ```bash
wget -qO- nginx
```

]

---

## Reset

Remove the service, the deployement and the network policy of this example.



---



## More about network policies

- We can also make *selectors* for the namespaces
    - very useful to block containers to acces the API of Kubernetes!

- We can block/authorize the communications towards/from particular ports

- Identically with IPs and blocks of IPs.

- For more details, check:

  - the [Kubernetes documentation about network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

  - this [talk about network policies at KubeCon 2017 US](https://www.youtube.com/watch?v=3gGpMmYeEO8) by [@ahmetb](https://twitter.com/ahmetb)

  - and some [exercices](https://github.com/ahmetb/kubernetes-network-policy-recipes)



