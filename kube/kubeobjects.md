# Kubernetes objects
--

- **Pods**
  - Represent a deployment unit composed by one or more tightly coupled containers sharing resources.
  - Containers within a Pod can communicate with each other through localhost.
  - All pods reside in a single flat, shared, network-address space, no NAT gateways exist between them. Pods access each other on their unique IP address. 
--

- **Controllers**
  - Create and manage multiple pods handling replication, rollout, self-healing.

---

## Pods and Nodes

![Un des meilleurs diagrammes d'architecture Kubernetes disponibles](images/pods.png)


---

## Pods and Network


![Un des meilleurs diagrammes d'architecture Kubernetes disponibles](images/pods2.png)

---

## Pods and Containers 

- Ideally we should have one process per container. 

- If containers do not need to remain on the same node we would better put them on different pods.

![Un des meilleurs diagrammes d'architecture Kubernetes disponibles](images/pods3.png)


---


## Kubernetes objects
--

- **Service**
  - Represent a single, constant point of entry to a group of pods providing the same service. Each service has an IP address and port that never change while the service exists.
--

- **Volumes**
  - Are directories accessible to the containers of a pod. Bound to pod lifecycle. 

--

- **Namespaces**
  - Provide an abstraction that enable the usage of multiple virtual clusters backed by the same physical cluster.
--

- **Nodes**
  - They can be VMs or physical machines, they provide the necessary services to run pods and are managed by the master components.

---

class: pic

![Un des meilleurs diagrammes d'architecture Kubernetes disponibles](images/k8s-arch4-thanks-luxas.png)

---

class: pic

![Un des meilleurs diagrammes d'architecture Kubernetes disponibles](images/kube_archi_simple.png)

---

## Kubernetes architecture

--

- **Components communication and execution**
  - All components pass from API Server to communicate between them
  - Only kubelet runs as regular system component and can run the other components as pods
  - Components on worker nodes need to run on same node but components of master can be split across multiple nodes

--

- **Etcd**
  - Distributed, consistent key value store.
  - Only the API-Server talks with etcd directly. All other components talk to etcd indirectly through API-Server based on “Optimistic concurrency control”
  - Uses Raft consensus algorithm to decide on the actual state based on quorum (majority).

---

## Kubernetes architecture

--

- **API-Server**
  - It provides a CRUD (Create, Read, Update, Delete) interface for querying and modifying the cluster state over a RESTful API. 
  - Performs authentication, authorization and admission control through different plugins before accessing state in etcd
  - Watch mechanism to inform clients for modifications on objects.

--

- **Controller manager**
  - It combines a multitude of controllers performing various reconciliation tasks.
  - Each controller watches the API server for changes to resources (Deployments, Services, and so on) and perform operations for each change
  - It reconciles the actual state with the desired state (specified in the resource’s spec section)
---


## Kubernetes architecture

--

- **Scheduler**
  - It updates pods definition and through the API-server watch mechanism the kubelet is notified to execute a pod.
  - The default scheduling algorithm determines acceptable nodes and selects the best one for the pod based on various configurable parameters.
  - Multiple schedulers can run simultaneously in the cluster and a pod can use whichever is more adapted.

---
class: pic

![Exemple de Kubectl](images/kubectl_ex.png)

---

## Simple pod execution


.exercise[

- Execute the following pod that will calculate pi

```bash
kubectl create -f https://raw.githubusercontent.com/RyaxTech/kube-tutorial/master/podpi.yml
```
- Follow the lifecycle of the pod.
- Read the yml file that we submitted.
- Download and change the yml file.
- Make changes on the command line parameter to add more precision and resubmit.
- Find on which node it is executed and find its results when it is completed.
- Follow the resources consumption on the node that is executed.

]


---

## Submitting pods

- `kubectl create` is what we call Imperative Management. On this approach you tell the Kubernetes API what you want to create, replace or delete, not how you want your K8s cluster world to look like.

- `kubectl apply` is part of the Declarative Management approach, where changes that you may have applied to a live object (i.e. through scale) are maintained even if you apply other changes to the object.

- You can read more about imperative and declarative management in the Kubernetes Object Management documentation.


---

## Kubernetes Controllers

- A **Deployment** is a high-level construct
  - allows scaling, rolling updates, rollbacks
  - delegates pods management to *replica sets*

- A **ReplicaSet** is a low-level construct
  - makes sure that a given number of identical pods are running
  - allows scaling
  - rarely used directly

- A **DaemonSet** is responsible to run a pod on every node, on all cluster nodes
  - a ReplicaSet makes sure that a desired number of pod replicas exist in the cluster
  - If a node goes down, the DaemonSet doesn’t cause the pod to be created elsewhere. But when a new node is added to the cluster, the DaemonSet immediately deploys a new pod instance to it.

---

