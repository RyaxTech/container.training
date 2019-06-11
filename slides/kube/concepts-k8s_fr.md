# Introduction de Kubernetes

- Kubernetes est un système de gestion de conteneur

- Il exécute et gère les applications conteneurisées sur un cluster

--

- Qu'est-ce que cela signifie vraiment?

---

## Introduction de Kubernetes

--

- C'est un logiciel pour *déployer et gérer* des applications conteneurisées tout en offrant la *meilleure utilisation possible* de la plate-forme de calcul.

--

- Il fait *l'abstraction* de l'infrastructure sous-jacente en *simplifiant le développement* d'applications et la *gestion du matériel*.

---

## Benefices de Kubernetes

--

- Simplification du *déploiement* d'applications.

--

- Amélioration de *l'utilisation* du système matériel.

--

- *Passage à l'échelle* automatique de l'application.

--

- *Simplification du développement* d'applications

--

- *Tolérance aux pannes*, *haute disponibilité* et *auto-guérison*

---

## Choses de base que nous pouvons demander à Kubernetes

--

- Démarrer 5 conteneurs en utilisant l'image `atseashop/api:v1.3`

--

- Placer un 'load balancer' interne devant ces conteneurs

--

- Démarrer 10 conteneurs en utilisant l'image `atseashop/webfront:v1.3`

--

- Placez un 'load balancer' public devant ces conteneurs

--

- C'est Noël, beaucoup de trafic, augmenter notre cluster et ajouter des conteneurs

--

- Nouvelle version! Remplacer mes conteneurs avec la nouvelle image `atseashop/webfront:v1.4`

--

- Continuez à traiter les demandes pendant la mise à niveau; mettre à jour mes conteneurs un à la fois

---

## D'autres choses que Kubernetes peut faire pour nous

- Autoscaling de base

- Déploiement bleu / vert, déploiement canari

- Les services à long terme, mais aussi les travaux par batch (ponctuels)

- Overcommit notre cluster et *expulser* les jobs de basse priorité

- Exécuter des services avec des données * stateful * (bases de données, etc.)

- Contrôle d'accès à grain fin définissant * ce qui * peut être fait par * qui * sur * quelles * ressources

- Intégration de services tiers (* catalogue de services *)

- Automatiser des tâches complexes (* opérateurs *)

---

## Kubernetes architecture

---

class: pic

![haha seulement blague](images/k8s-arch1.png)

---

## Kubernetes architecture

- Ha ha ha ha

- OK, j'essayais de vous faire peur, c'est beaucoup plus simple que ça ❤️

---

class: pic

![Celui-là ressemble plus à la réalité](images/kube_archi_simple.png)

---

class: pic

![Celui-là ressemble plus à la réalité](images/k8s-arch2.png)

---

## Crédits

- Le premier schéma est un cluster Kubernetes avec stockage soutenu par iSCSI "multi-path"

  (Source: [Yongbok Kim](https://www.yongbok.net/blog/))

- Le second est repris par le livre de Marko Luksa "Kubernetes in Action"

- Le troisieme est une représentation simplifiée d'un cluster Kubernetes

  (Source: [Imesh Gunaratne](https://medium.com/containermind/a-reference-architecture-for-deploying-wso2-middleware-on-kubernetes-d4dee7601e8e))

---

## A savoir...

- Comment prononce-t-on kubernetes?
    - Mot venant du grecque κυβερνήτης, prononcé "kivernitis"
    - En anglais : "coubernetis"
    - En français : "cubernetesse" ou "cubernette"

- On peut abbréger Kubernetes en k8s

- Kubernetes viens avec de l'autocomplétion à intégrer dans votre bash :

`source <(kubectl completion bash)`

Ça complète les commandes mais aussi les noms des objets!

Commande déjà éfféctuée dans vos VMs.


---

## Architecture de Kubernetes: les noeuds

- Les nœuds exécutant nos conteneurs exécutent une collection de services:

  - **Container Runtime** (typiquement Docker pour le deploiment de conteneurs)

  - **Kubelet** (l'agent de noeud, gere les conteneurs, communique avec l'API)

  - **Kube-proxy** (un composant réseau qui fait du "load-balancing")

- Les nœuds étaient autrefois appelés "minions"

  (Vous pourriez voir ce mot dans les anciens articles ou dans la documentation)

---

## Architecture de Kubernetes: le "Control Plane"

- La logique de Kubernetes (ses "cerveaux") est une collection de services:

  - **API server**: notre point d'entrée pour tout!

  - **Scheduler**: affecte des nœuds aux composants
  
  - **Controller Manager**: fonctions de niveau de cluster
  
  - **Etcd**: un key/value store fiable, la "base de données" de Kubernetes

- Ensemble, ces services forment le "Control Plane" de notre cluster

- Le "Control Plane" est aussi appelé le "master"

---

## Exécution du "Control Plane" sur des noeuds spéciaux

- Il est courant de réserver un noeud dédié au plan de contrôle

  (Sauf pour les clusters de développement à noeud unique, comme lorsque vous utilisez minikube)

- Ce noeud s'appelle alors un "master"

  (Oui, c'est ambigu: le "master" est-il un nœud, ou tout le plan de contrôle?)

- Les applications normales sont limitées à l'exécution sur ce noeud

  (En utilisant un mécanisme appelé ["taints"](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/))

- Lorsque la haute disponibilité est requise, chaque service du plan de contrôle doit être résilient

- Le plan de contrôle est ensuite répliqué sur plusieurs nœuds

  (Ceci est parfois appelé une configuration "multi-master")

---

## Exécution du "Control Plane" en dehors des conteneurs

- Les services du "Control Plane" peuvent fonctionner dans ou hors des conteneurs

- Par exemple: puisque `etcd` est un service critique, certaines personnes
  déployer directement sur un cluster dédié (sans conteneurs)

  (Ceci est illustré sur le premier schéma "super compliqué")

- Dans certaines offres Kubernetes hébergées (par exemple, GKE), le plan de contrôle est invisible

  (Nous ne "voyons" qu'un point de terminaison API Kubernetes)

- Dans ce cas, il n'y a pas de "noeud master"

* Pour cette raison, il est plus juste de dire "Control Plane" plutôt que "master". *

---

## Doit-on lancer Docker du tout?

Non!

--

- Par défaut, Kubernetes utilise Docker Engine pour exécuter les conteneurs

- Nous pourrions aussi utiliser `rkt` ("Rocket") de CoreOS/Redhat

- Ou tirer parti d'autres runtimes connectables via l'interface *Container Runtime*

  (comme CRI-O, ou containerd)

---

## Doit-on lancer Docker du tout?

Oui!

--

- Dans cette formation, nous exécutons notre application sur un seul noeud en premier

- Nous aurons besoin de construire des images et de les expédier

- Nous pouvons faire ces choses sans Docker mais

- Docker est toujours le moteur de conteneur le plus stable aujourd'hui
  <br/>
  (mais d'autres options mûrissent très rapidement)

---

## Doit-on lancer Docker du tout?

- Sur nos environnements de développement, les pipelines CI ...:

  *Oui, presque certainement*

- Sur nos serveurs de production:

  *Oui (aujourd'hui)*

  *Probablement pas (dans le futur)*

.footnote[Plus d'informations sur CRI [sur le blog Kubernetes](https://kubernetes.io/blog/2016/12/container-runtime-interface-cri-in-kubernetes)]

---

## Ressources de Kubernetes

- L'API Kubernetes définit beaucoup d'objets appelés *ressources*

- Ces ressources sont organisées par type, ou `Kind` (dans l'API)

- Quelques types de ressources communs sont:

  - noeud (une machine - physique ou virtuelle - dans notre cluster)
  - pod (groupe de conteneurs fonctionnant ensemble sur un noeud)
  - service (point de terminaison réseau stable pour se connecter à un ou plusieurs conteneurs)
  - namespace (groupe de choses plus ou moins isolé)
  - secret (paquet de données sensibles à transmettre à un conteneur)
 
  Et beaucoup plus! (Nous pouvons voir la liste complète en exécutant `kubectl get`)

---

class: pic

![Nœud, pod, conteneur](images/k8s-arch3-thanks-weave.png)

---

class: pic

![Un des meilleurs diagrammes d'architecture Kubernetes disponibles](images/k8s-arch4-thanks-luxas.png)

---

## Crédits

- Le premier diagramme est une gracieuseté de Weave Works

  - un *pod* peut avoir plusieurs conteneurs travaillant ensemble

  - Les adresses IP sont associées à *pods*, pas avec des conteneurs individuels

- Le deuxième diagramme est une gracieuseté de Lucas Käldström, dans [cette présentation](https://speakerdeck.com/luxas/kubeadm-cluster-creation-internals-from-self-hosting-to-upgradability-and-ha)

  - c'est l'un des meilleurs diagrammes d'architecture Kubernetes disponibles!

