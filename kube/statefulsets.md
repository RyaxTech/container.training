
# Statefulsets

---



---
## Replicating Stateful pods

---
class: pic

![replicasets](images/replicasets.png)

---

## Providing a stable network identity

---
class: pic

![replicasets](images/replicasets_statefulsets.png)

---

## Statefulset with nodefail

---
class: pic

![replicasets](images/statefulset_nodefail.png)

---

## Statefulset with scaledown

---
class: pic

![replicasets](images/statefulset_scaledown.png)

---
## Statefulset with PVC and scaledown

---
class: pic

![replicasets](images/statefulsetPVC_scaledown.png)

---
## Statefulset exercises

.exercise[
- We will perform the exercise from the following link:
  https://blog.openshift.com/kubernetes-statefulset-in-action/

- with the following differences:
  * we won't use Openshift but our simple kubernetes cluster
  * instead of "ebs" storage class we will make use of our rook storage provisioner, so the manifests need to be adapted appropriately to fit our rook storage class
 
]
---

# CI/CD with Spinnaker

.exercise[
- We will perform the exercise from the following link:
  https://thenewstack.io/getting-started-spinnaker-kubernetes/

 * However, since we already have our own cluster and Helm installed, we will start the tutorial from the "Installing Spinnaker" section

]


