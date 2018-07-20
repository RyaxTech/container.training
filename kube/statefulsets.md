
# StatefulSets

- Un StatefulSet permet d'avoir un ensemble de pod qui ont un nom et un état stable.

- Quelle différence avec un ReplicaSet (deployment) ?

  - un ReplicaSet c'est comme gérer un troupeau de vache : on se fiche du nom des vaches, on veut juste savoir combien il y en a. Si une vache est malade, on la remplace.

  - un StatefulSet c'est comme gérer un groupe d'animaux de compagnie : on leur donne des noms et on ne peut pas les remplacer facilement. Si jamais on veut en remplacer un il va falloir en trouver un avec le même nom et le même apparence.


---
## Repliquer des pods Stateful


![replicasets](images/replicasets.png)

A cause du système de template des ReplicaSet, on ne peut donner qu'un seul et unique nom pour le PersistentVolumeClaim.

Dans un ReplicaSet, tous les replicas utilisent le même PersistentVolumeClaim !

---

## Les StatefulSets nous permettent d'avoir des noms uniques


![replicasets](images/replicasets_statefulsets.png)

Que se passe-t-il si un noeud meurt ?

---

class: pic

![replicasets](images/statefulset_nodefail.png)

---

## Statefulset, changement du nombre de replicas

![replicasets](images/statefulset_scaledown.png)

Le pod avec l'ID le plus grand est détruit en premier !

Mais qu'en est il des PVC attachés ?

---

class: pic


![replicasets](images/statefulsetPVC_scaledown.png)


---
## Statefulset exercises

- Les schemas ont été repris du livre de Marko Luksa "Kubernetes in Action"

.exercise[
- We will perform the exercise from the following link:
  https://blog.openshift.com/kubernetes-statefulset-in-action/

- with the following differences:
  * we won't use Openshift but our simple kubernetes cluster
  * instead of "ebs" storage class we will make use of our rook storage provisioner, so the manifests need to be adapted appropriately to fit our rook storage class

]


