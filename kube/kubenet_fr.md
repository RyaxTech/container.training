# Modèle de réseau de Kubernetes

- TL,DR:

  *Notre cluster (nœuds et pods) est un grand réseau IP plat.*

--

- En détail:

 - tous les nœuds doivent pouvoir se rejoindre, sans NAT

 - Tous les pods doivent pouvoir se rejoindre, sans NAT

 - Les pods et les nœuds doivent pouvoir se rejoindre, sans NAT

 - chaque pod est au courant de son adresse IP (pas de NAT)

- Kubernetes n'impose aucune implémentation particulière

---

## Modèle de réseau de Kubernetes: le bon

- Tout peut atteindre tout

- Pas de traduction d'adresse

- Pas de traduction de port

- Pas de nouveau protocole

- Les pods ne peuvent pas se déplacer d'un noeud à l'autre et conserver leur adresse IP

- Les adresses IP ne doivent pas être "portables" d'un nœud à l'autre

  (Nous pouvons utiliser par exemple un sous-réseau par nœud et utiliser une topologie routée simple)

- La spécification est assez simple pour permettre de nombreuses implémentations différentes

---

## Modèle de réseau Kubernetes: le moins bon

- Tout peut atteindre tout

  - Si vous voulez de la sécurité, vous devez ajouter des règles de réseau

  - l'implémentation réseau dont vous avez besoin doit les prendre en charge

- Il y a littéralement des dizaines d'implémentations là-bas

  (15 sont répertoriés dans la documentation de Kubernetes)

- Les pods ont une connectivité de niveau 3 (IP), mais les *services* sont de niveau 4

  (Services mappent vers un seul port UDP ou TCP, aucune plage de ports ou paquets IP arbitraires)

- `kube-proxy` est sur le chemin de données lors de la connexion à un pod ou un conteneur,
  <br/> et ce n'est pas particulièrement rapide (repose sur un proxy utilisateur ou sur iptables)

---

## Modèle de réseau Kubernetes: en pratique

- Les nœuds que nous utilisons ont été configurés pour utiliser [Weave](https://github.com/weaveworks/weave)

- Nous n'approuvons pas Weave d'une manière particulière, ça marche juste pour nous

- Ne vous inquiétez pas de l'avertissement concernant les performances de `kube-proxy`

- À moins que vous:

  - saturer régulièrement les interfaces réseau 10G
  - compte les taux de paquets en millions par seconde
  - lancer des plateformes VOIP ou de jeu à fort trafic
  - faire des choses bizarres qui impliquent des millions de connexions simultanées
    <br/> (auquel cas vous connaissez déjà le réglage du noyau)

- Si nécessaire, il existe des alternatives à `kube-proxy`, par exemple [kube-router](https://www.kube-router.io)

---

## Le "Container Network Interface" (CNI)

- Le CNI a une [spécification](https://github.com/containernetworking/cni/blob/master/SPEC.md#network-configuration) bien définie pour les plugins réseau

- Lorsqu'un pod est créé, Kubernetes délègue la configuration réseau aux plugins CNI

- Typiquement, un plugin CNI va:

  - allouer une adresse IP (en appelant un plugin IPAM)

  - ajouter une interface réseau dans l'espace de noms réseau du pod

  - configurer l'interface ainsi que les routes requises, etc.

- Utiliser plusieurs plugins peut être fait avec des "méta-plugins" comme CNI-Genie ou Multus

- Tous les plugins CNI ne sont pas égaux

  (par exemple, ils n'implémentent pas tous les stratégies de réseau, qui sont nécessaires pour isoler les pods)
