# Premier contact avec `kubectl`

- `kubectl` est (presque) le seul outil dont nous aurons besoin pour parler à Kubernetes

- C'est un outil CLI riche autour de l'API Kubernetes

  (Tout ce que vous pouvez faire avec `kubectl`, vous pouvez le faire directement avec l'API)

- Sur nos machines, il y a un fichier `~/.kube/config` avec:

  - l'adresse de l'API Kubernetes

  - le chemin vers nos certificats TLS utilisés pour l'authentification

- Vous pouvez également utiliser l'indicateur `--kubeconfig` pour passer un fichier de configuration

- Ou directement `--server`,` --user`, etc.

- «kubectl» peut être prononcé «Cube C T L», «Cube cuttle» ...

---

## `kubectl get`

- Regardons nos ressources `Node` avec` kubectl get`!

.exercise[

- Regardez la composition de notre cluster:
  ```bash
  kubectl get node
  ```

- Ces commandes sont équivalentes:
  ```bash
  kubectl get no
  kubectl get node
  kubectl get nodes
  ```

]

---

## Obtention d'une sortie lisible par machine

- `kubectl get` peut sortir JSON, YAML, ou être directement formaté

.exercise[

- Donnez-nous plus d'informations sur les nœuds:
  ```bash
  kubectl get nodes -o wide
  ```

- Ayons du YAML:
  ```bash
  kubectl get no -o yaml
  ```
  Vous voyez ce `kind: List` à la fin? C'est le type de notre résultat!

]

---

## Utilisation de `kubectl` et `jq`

- C'est super facile de construire des rapports personnalisés

.exercise[

- Afficher la capacité de tous nos nœuds en tant que flux d'objets JSON:
  ```bash
    kubectl get nodes -o json |
            jq ".items [] | {nom: .metadata.name} + .status.capacity"
  ```

]

---

## Qu'est-ce qui est disponible?

- `kubectl` a de très bonnes installations d'introspection

- Nous pouvons lister tous les types de ressources disponibles en exécutant `kubectl get`

- Nous pouvons voir les détails d'une ressource avec:
  ```bash
  kubectl describe type/name
  kubectl describe type name
  ```

- Nous pouvons voir la définition d'un type de ressource avec:
  ```bash
  kubectl explain type
  ```

Chaque fois, `type` peut être un nom de type singulier, pluriel ou abrégé.

---

## Services

- Un *service* est un point de terminaison stable pour se connecter à "quelque chose"

  (Dans la proposition initiale, ils étaient appelés "portals")

.exercise[

- Listez les services sur notre cluster avec l'une de ces commandes:
  ```bash
  kubectl get services
  kubectl get svc
  ```

]

--

Il y a déjà un service sur notre cluster: l'API Kubernetes elle-même.

---

## Services ClusterIP

- Un service `ClusterIP` est interne, disponible uniquement à partir du cluster

- Ceci est utile pour l'introspection à l'intérieur des conteneurs

.exercise[

- Essayez de vous connecter à l'API:
  ```bash
  curl -k https://`10.96.0.1`
  ```
  
  - `-k` est utilisé pour ignorer la vérification du certificat

  - Assurez-vous de remplacer 10.96.0.1 avec le CLUSTER-IP montré par `kubectl get svc`

]

--

L'erreur que nous voyons est attendue: l'API Kubernetes nécessite une authentification.

---

## Liste des conteneurs en cours d'exécution

- Les conteneurs sont manipulés via *pods*

- Un pod est un groupe de conteneurs:

 - fonctionnant ensemble (sur le même noeud)

 - partage des ressources (RAM, CPU, mais aussi réseau, volumes)

.exercise[

- Liste des pods sur notre cluster:
  ```bash
  kubectl get pods
  ```

]

--

*Ce ne sont pas les pods que vous cherchez.* Mais où sont-ils?!?

---

## Namespaces

- Les namespaces nous permettent de séparer les ressources

.exercise[

- Liste les espaces de noms sur notre cluster avec l'une de ces commandes:
  ```bash
  kubectl get namespaces
  kubectl get namespace
  kubectl get ns
  ```

]

--

*Vous savez quoi ... Ce truc de "kube-system" semble suspect. *

---

## Accès aux namespaces

- Par défaut, `kubectl` utilise le namespace `default`

- Nous pouvons passer à un namespace différent avec l'option `-n`

.exercise[

- Lister les pods dans l'espace de noms `kube-system`:
  ```bash
  kubectl -n kube-system get pods
  ```

]

--

* Ding ding ding ding! *

L'espace de noms `kube-system` est utilisé pour le "Control Plane".

---

## Quels sont tous ces pod du Control Plane?

- `etcd` est notre serveur etcd

- `kube-apiserver` est le serveur API

- `kube-controller-manager` et` kube-scheduler` sont d'autres composants principaux

- `kube-dns` est un composant supplémentaire (pas obligatoire mais super utile, donc c'est là)

- `kube-proxy` est le composant (par noeud) gérant les mappages de ports et tel

- `weave` est le composant (par noeud) gérant le overlay du réseau

- la colonne `READY` indique le nombre de conteneurs dans chaque pod

- les pods dont le nom se termine par `-node1` sont les composants master
  <br/>
  (Ils ont été spécifiquement "épinglé" au nœud master)

---

## Qu'en est-il de `kube-public`?

.exercise[

- Lister les pods dans le namespace `kube-public`:
  ```bash
  kubectl -n kube-public get pods
  ```

]

--

- Peut-être n'a-t-il pas de pods, mais quels sont les secrets du `kube-public`?

--

.exercise[

- Liste les secrets dans le namespace `kube-public`:
  ```bash
  kubectl -n kube-public get secrets
  ```

]
--

- `kube-public` est créé par kubeadm & [utilisé pour le bootstrap de sécurité](https://kubernetes.io/blog/2017/01/stronger-foundation-for-creating-and-managing-kubernetes-clusters)

