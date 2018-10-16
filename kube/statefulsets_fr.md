
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

- *mehdb* est une base de donnée pas super (*meh* en anglais).
Elle réplique automatiquement les données entre chaque instance.

  ```bash
wget https://gist.githubusercontent.com/glesserd/a0db0439e69426d92c632fb5c9bcba1c/raw/56b05fcdf9d4d1bbdf5f5cdca3fc104d7dca7d24/app.yaml
  ```

- Regardons le yaml ensemble...

]

Attention ! Cette application ne fonctionne pas... En effet les données ne sont pas répliqué. Mais cela n'est pas important pour nos tests avec Kubernetes.


---
## Déploiement
.exercise[
- Déployez le

  ```bash
kubectl get statefulset
kubectl get sts
  ```

- On scale la bdd

  ```bash
kubectl scale sts mehdb --replicas=4
  ```

- Tout s'est bien passé ?
  ```bash
kubectl get sts
kubectl get pvc
  ```

]

---
## Resistance aux crashs

.exercise[
- Tuons un pod !

  ```bash
kubectl delete pod mehdb-1
  ```

- Quel pod va être recréé ?

  ```bash
kubectl get pod
  ```

]

---
## Scale down

.exercise[
- Maintenant scale down:
  ```bash
kubectl scale sts mehdb --replicas=2
  ```


- Tout s'est bien passé ?
  ```bash
kubectl get sts
kubectl get pvc
  ```

- Les pvc sont toujours la comme attendu !

]

---
## Le reset

.exercise[
- Reset:

  ```bash
kubectl delete -f app.yaml
  ```

* Il ne faut pas oublier de supprimer les pvc !!!*

]


