# Les objets de Kubernetes
--

- **Pods**
  - Représente une unité de déploiement composée d'un ou de plusieurs conteneurs étroitement liés partageant des ressources.
  - Les conteneurs d'un Pod peuvent communiquer entre eux via localhost.
  - Tous les modules résident dans un seul espace d'adressage réseau partagé et plat, aucune passerelle NAT n'existe entre eux. Les pods accèdent les uns aux autres sur leur adresse IP unique.

--

- **Controllers**
  - Créez et gérez plusieurs modules gérant la réplication, le déploiement et l'auto-réparation.


---

## Les objets de Kubernetes (suite)
--

- **Services**
  - Représente un seul point d'entrée constant à un groupe de pods fournissant le même service. Chaque service a une adresse IP et un port qui ne changent jamais tant que le service existe.
--

- **Volumes**
  - Les annuaires sont-ils accessibles aux conteneurs d'un pod. Lié au cycle de vie des pods.

--

- **Namespaces**
  - Fournissez une abstraction permettant l'utilisation de plusieurs clusters virtuels soutenus par le même cluster physique.
--

- **Nodes**
  - Ils peuvent être des machines virtuelles ou des machines physiques, ils fournissent les services nécessaires pour exécuter des modules et sont gérés par les composants principaux.

---

class: pic

![Un des meilleurs diagrammes d'architecture Kubernetes disponibles](images/k8s-arch4-thanks-luxas.png)

---

## L'architecture de Kubernetes

--

- **Communication et exécution de composants**
  - Tous les composants passent du serveur API pour communiquer entre eux
  - Seul kubelet s'exécute en tant que composant système normal et peut exécuter les autres composants en tant que pods
  - Les composants sur les nœuds de travail doivent s'exécuter sur le même nœud, mais les composants de maître peuvent être répartis sur plusieurs nœuds

--

- **Etcd**
  - Magasin de valeurs clés distribué et cohérent.
  - Seul le serveur API parle directement avec etcd. Tous les autres composants communiquent avec etcd indirectement via API-Server sur la base du "Contrôle de concurrence optimiste"
  - Utilise l'algorithme de consensus Raft pour décider de l'état actuel en fonction du quorum (majorité).

---

## L'architecture de Kubernetes (suite)

--

- **API-Server**
  - Il fournit une interface CRUD (Créer, Lire, Mettre à jour, Supprimer) pour interroger et modifier l'état du cluster sur une API RESTful.
  - Effectue l'authentification, l'autorisation et le contrôle d'admission via différents plugins avant d'accéder à l'état dans etcd
  - Surveiller le mécanisme pour informer les clients des modifications sur les objets.

--

- **Controller manager**
  - Il combine une multitude de contrôleurs effectuant diverses tâches de rapprochement.
  - Chaque contrôleur surveille le serveur API pour les modifications apportées aux ressources (Déploiements, Services, etc.) et effectue des opérations pour chaque modification
  - Il réconcilie l'état actuel avec l'état souhaité (spécifié dans la section des spécifications de la ressource)

---


## L'architecture de Kubernetes (suite)

--

- **Scheduler**
  - Il met à jour la définition des pods et, via le mécanisme de surveillance du serveur API, le kubelet est averti pour exécuter un pod.
  - L'algorithme de planification par défaut détermine les nœuds acceptables et sélectionne le meilleur pour le pod en fonction de divers paramètres configurables.
  - Plusieurs schedulers peuvent s'exécuter simultanément dans le cluster et un module peut utiliser celui qui est le plus adapté.

---
class: pic

![Exemple de Kubectl](images/kubectl_ex.png)

---

