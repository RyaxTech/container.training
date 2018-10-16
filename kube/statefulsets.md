
# StatefulSets

- A StatefulSet allows to have a group of pods that have a stable name and state.

- What is the difference with ReplicaSet (deployment) ?

  - A ReplicaSet is like managing a cattle of cows : we do not care about the names of cows, we just want to know how many we have. If a cow is ill we replace her.

  - A StatefulSet is like managing a group of domestic animals : we give them names and we cannot replace them easily. If we have to replace one we need to find one with the same name and the same appearance.


---
## Replicate Stateful pods


![replicasets](images/replicasets.png)

Because of the ReplicaSet template system, we can only give one and only name for the PersistentVolumeClaim.

For a ReplicaSet, all replicas use the same PersistentVolumeClaim !

---

## The StatefulSets allow us to have unique names 


![replicasets](images/replicasets_statefulsets.png)

What happens if a node dies ?

---

class: pic

![replicasets](images/statefulset_nodefail.png)

---

## Statefulset, change of the replicas number

![replicasets](images/statefulset_scaledown.png)

The pod with the higher ID is destroyed first!

What happens with the attached PVC?

---

class: pic


![replicasets](images/statefulsetPVC_scaledown.png)


---
## Statefulset exercises

- The schemas have been taken from the book of Marko Luksa "Kubernetes in Action"

.exercise[

- *mehdb* is database (*meh* in anglais).
It replicates automatically the data between each instance.

  ```bash
wget https://gist.githubusercontent.com/glesserd/a0db0439e69426d92c632fb5c9bcba1c/raw/56b05fcdf9d4d1bbdf5f5cdca3fc104d7dca7d24/app.yaml
  ```

- Let's check the YAML...

]

Attention ! This application does not work... Indeed the data are not replicated. But it is not important for our tests with Kubernetes.


---
## Deployment
.exercise[
- Deploy it

  ```bash
kubectl get statefulset
kubectl get sts
  ```

- We scale the bdd

  ```bash
kubectl scale sts mehdb --replicas=4
  ```

- How did everything go ?
  ```bash
kubectl get sts
kubectl get pvc
  ```

]

---
## Resistance to crashes

.exercise[
- Let's kill a pod!

  ```bash
kubectl delete pod mehdb-1
  ```

- Which pod is going to be re-created ?

  ```bash
kubectl get pod
  ```

]

---
## Scale down

.exercise[
- Let's scale down:
  ```bash
kubectl scale sts mehdb --replicas=2
  ```


- Did everything go well ?
  ```bash
kubectl get sts
kubectl get pvc
  ```

- The PVC are still there as expected !

]

---
## Reset

.exercise[
- Reset:

  ```bash
kubectl delete -f app.yaml
  ```

* Do not forget to delete the PVC !!!*

]


