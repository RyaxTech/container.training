# Introduction aux volumes

- Les volumes de Kubernetes sont une composante d'un pod et sont donc définis dans la spécification de pods, tout comme les conteneurs.

- Ils ne sont pas un objet Kubernetes autonome et ne peuvent pas être créés ou supprimés par eux-mêmes.

- Un volume est disponible pour tous les conteneurs du pod, mais il doit être monté dans chaque conteneur qui doit y accéder.

- Dans chaque conteneur, vous pouvez monter le volume à n'importe quel emplacement de son système de fichiers.

---

## Les volumes par un exemple

- Conteneurs qui n'ont pas de stockage commune

- Conteneurs qui partageant 2 volumes montés dans des chemins de montage différents

---

class: pic

![haha seulement blague](images/volumes1.png)

---

class: pic

![haha seulement blague](images/volume2.png)

---


## Remarques

- Les schemas ont été repris du livre de Marko Luksa "Kubernetes in Action"

- Le volume /var/logs n'est pas monté dans le conteneur ContentAgent.

- Le conteneur ne peut pas accéder à ses fichiers, même si le conteneur et le volume font partie du même conteneur.

- Il ne suffit pas de définir un volume dans le pod; vous devez également définir un VolumeMount dans la spécification du conteneur, si vous voulez que le conteneur puisse y accéder.

---

## Types de volume

- Une grande variété de types de volumes est disponible. Plusieurs sont génériques, tandis que d'autres sont spécifiques aux technologies de stockage utilisées en dessous.

* `emptyDir`: un répertoire vide simple utilisé pour stocker des données transitoires.
* `hostPath`: Utilisé pour monter les répertoires du système de fichiers du noeud worker dans le pod.
* `gitRepo`: Un volume initialisé en vérifiant le contenu d'un dépôt Git.
* `nfs`: un partage NFS monté dans le pod.
* `gcePersistentDisk`, `awsElasticBlockStore`, `azureDisk`: Utilisé pour monter le stockage spécifique au fournisseur de cloud.
* `cinder`, `cephfs`, ...: Utilisé pour monter d'autres types de stockage réseau.
* `configMap`, `secret`, `downwardAPI`: Types spéciaux de volumes utilisés pour exposer certaines ressources et informations de cluster Kubernetes au pod.
* `persistentVolumeClaim`: un moyen d'utiliser un stockage persistant pré-provisionné ou dynamiquement.

---

## Remarque

- Un seul pod peut utiliser plusieurs volumes de types différents en même temps

- Chacun des conteneurs du pod peut avoir le volume monté ou non.

---

## Exemple d'un pod utilisant le volume gitrepo

---

.exercise[
  ```bash
apiVersion: v1
kind: Pod
metadata:
  name: gitrepo-volume-pod
spec:
  containers:
  - image: nginx:alpine
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:
  - name: html
    gitRepo:
      repository: https://github.com/luksa/kubia-website-example.git
      revision: master
      directory: .   
  ```
]

---

## Découplage des pods de la technologie de stockage sous-jacente

- Le cas ci-dessus est contre l'idée de base de Kubernetes, qui vise à cacher l'infrastructure réelle de l'application et de son développeur.

- Lorsqu'un développeur a besoin d'une certaine quantité de stockage persistant pour son application, il doit le demander à Kubernetes.

- De la même manière qu'ils demandent du CPU, de la mémoire et d'autres ressources lors de la création d'un pod.

- L'administrateur système peut configurer le cluster afin qu'il puisse donner aux applications ce qu'elles demandent.

---

# Introduction de PersistentVolumes et PersistentVolumeClaims

- Au lieu que le développeur ajoute un volume spécifique à son pod, c'est l'administrateur du cluster qui configure le stockage sous-jacent, puis l'enregistre dans
Kubernetes en créant une ressource PersistentVolume via le serveur de l'API Kubernetes.

- Lors de la création de PersistentVolume, l'administrateur spécifie sa taille et les modes d'accès
qu'il supporte.

---

## Introduction de PersistentVolumes et PersistentVolumeClaims

- Lorsqu'un utilisateur de cluster doit utiliser un stockage persistant dans l'un de ses pods, il crée d'abord un manifeste PersistentVolumeClaim, en spécifiant la taille minimale et le mode d'accès qu'ils exigent.

- L'utilisateur soumet ensuite le manifeste PersistentVolumeClaim au serveur de l'API Kubernetes, et Kubernetes trouve le PersistentVolume approprié et lie au Volume Claim.

- Le PersistentVolumeClaim peut alors être utilisé comme l'un des volumes à l'intérieur d'un pod. Les autres utilisateurs ne peuvent pas utiliser le même PersistentVolume jusqu'à ce qu'il ait été libéré en supprimant
le PersistentVolumeClaim lié.

---

## Exemple de PersistentVolumes et PersistentVolumeClaims

---

class: pic

![haha seulement blague](images/volumes3.png)

---

## PersistentVolumes et Namespaces

---

class: pic

![haha seulement blague](images/Volume4.png)

---

## Durée de vie de PersistentVolume et PersistentVolumeClaims

---

class: pic

![haha seulement blague](images/Volume5.png)

---
# Provisionnement dynamique des volumes persistants

- Les schemas précédents ont été repris du livre de Marko Luksa "Kubernetes in Action"

- Nous avons vu comment l'utilisation de PersistentVolumes et PersistentVolumeClaims facilite l'obtention d'un stockage persistant sans que le développeur n'ait à gérer le stockage réel utilisée en dessous.

- Mais cela nécessite toujours un administrateur de cluster pour provisionner le stockage réel à l'avance.

---

## Provisionnement dynamique des volumes persistants

- Heureusement, Kubernetes peut également effectuer ce travail automatiquement grâce au provisionnement dynamique de PersistentVolumes.

- L'administrateur du cluster, au lieu de créer PersistentVolumes, peut déployer un provisionneur PersistentVolume et définir un ou plusieurs objets StorageClass pour permettre aux utilisateurs de choisir le type de PersistentVolume souhaité.

- Les utilisateurs peuvent se référer à StorageClass dans leur PersistanceVolumeClaims et le provisionneur en tiendra compte lors de l'approvisionnement du stockage persistant.

- Le schema suivant a été repris du livre de Marko Luksa "Kubernetes in Action" 

---

## Provisionnement dynamique des volumes persistants

---

class: pic

![haha seulement blague](images/volume6.png)

---

# Rook orchestration de stockage distribué

- Rook est un orchestrateur open source pour les systèmes de stockage distribués.

- Rook transforme le logiciel de stockage distribué en un service de stockage auto-géré, auto-scalable et auto-guérisant.

- Il le fait en automatisant le déploiement, l'amorçage, la configuration, l'approvisionnement, la mise à l'échelle, la mise à niveau, la migration, la reprise après sinistre, la surveillance et la gestion des ressources.

---

## Rook orchestration de stockage distribué

- Rook se concentre d'abord sur l'orchestration de Ceph sur Kubernetes. Ceph est un système de stockage distribué qui permet le stockage de fichiers, de blocs et d'objets et qui est déployé dans des clusters de production à grande échelle.

- Rook est hébergé par la Cloud Native Computing Foundation (CNCF) en tant que projet de niveau initial.

---

## Exemple de provisionnement dynamique de PersistentVolumes à l'aide de Rook

.exercise[
  ```bash
   git clone https://github.com/rook/rook.git
   cd rook/cluster/examples/kubernetes/ceph
   kubectl create -f operator.yaml
   kubectl create -f cluster.yaml
  ```
- vérifiez pour voir si tout fonctionne comme prévu
  ```bash
   kubectl get pods -n rook-ceph
  ```

]

---

## Exemple de provisionnement dynamique de PersistentVolumes à l'aide de Rook

- Le stockage 'block' vous permet de monter le stockage dans un seul pod.

- Voyons comment construire une application web simple et multi-niveaux sur Kubernetes en utilisant des volumes persistants activés par Rook.

--

- Avant que Rook puisse démarrer le provisionnement, une classe StorageClass et son pool de stockage doivent être créés.

- Ceci est nécessaire pour que Kubernetes puisse interopérer avec Rook pour provisionner des volumes persistants.

---
## Exemple de provisionnement dynamique de PersistentVolumes à l'aide de Rook

<!--   kubectl create -f pool.yaml -->
.exercise[
- Créez le pool et le storage class:
  ```bash
  kubectl create -f storageclass.yaml
  ```
]
- Consommez le stockage avec l'échantillon wordpress
- Nous créons un exemple d'application pour consommer le stockage en 'block' provisionné par Rook avec les applications classiques wordpress et mysql.
- Ces deux applications utiliseront les volumes 'block' provisionnés par Rook.

---

## Exemple de provisionnement dynamique de PersistentVolumes à l'aide de Rook


.exercise[
- Démarrez mysql et wordpress depuis le dossier cluster/examples/kubernetes:
  ```bash
  kubectl create -f mysql.yaml
  kubectl create -f wordpress.yaml
  ```
- Ces deux applications créent un volume en 'block' et le montent dans leur pod respectif. Vous pouvez voir les 'volume claims' de Kubernetes en exécutant les opérations suivantes:

  ```bash
  kubectl get pvc
  ```
- Vous devriez voir quelque chose comme ça:
```bash
NAME             STATUS    VOLUME        CAPACITY   ACCESSMODES   AGE
mysql-pv-claim   Bound     pvc-954459ee   20Gi       RWO           1m
wp-pv-claim      Bound     pvc-39e459ee   20Gi       RWO           1m
```
]
---

## Exemple de provisionnement dynamique de PersistentVolumes à l'aide de Rook

.exercise[
- Une fois que les pods wordpress et mysql sont dans l'état Running, récupérez l'adresse IP du cluster de l'application wordpress et entrez-la dans votre navigateur avec le port:

 ```bash
 kubectl get svc wordpress
 ```
]
Vous devriez voir l'application wordpress en cours d'exécution.

---

## Lancez un autre exemple de provisionnement dynamique

.exercise[

- Récupérez le fichier:
  ```bash
  wget https://raw.githubusercontent.com/zonca/jupyterhub-deploy-kubernetes-jetstream/master/storage_rook/alpine-rook.yaml
  ```

- Modifiez-le pour qu'il corresponde aux spécifications de votre cluster (notre `storageClassName` est `"rook-ceph-block"`) et exécutez-le en utilisant:
  ```bash
  kubectl create -f alpine-rook.yaml
  ```

]

---

## Lancez un autre exemple de provisionnement dynamique (suite)

- C'est un petit pod avec Alpine Linux qui crée un volume de 2 Go à partir de Rook et le monte sur /data.

- Cela crée un Pod avec Alpine Linux qui demande qu'un Persistent Volume Claim soit montée sous /data.

- Le PersistentVolumeClaim spécifiait le type de stockage et sa taille.

- Une fois le Pod créé, il demande au PersistentVolumeClaim de demander à Rook de préparer un volume persistant qui sera ensuite monté dans le pod.

---

## Lancez un autre exemple de provisionnement dynamique (suite)

- Nous pouvons vérifier que les Volumes Persistants sont créés et associés au pod, vérifiez:

.exercise[
  ```bash
  kubectl get pv
  kubectl get pvc
  kubectl logs alpine
  ```
- Obtenez un shell dans le pod avec:
  ```bash
  kubectl exec -it alpine /bin/sh
  ```
- Créer des fichiers dans `/data/`.
- Quitter le terminal
- Maintenant supprimez le pod. Est-il encore possible daccéder ces données ? Si oui, comment ?
]

<!-----
## Lancez un autre exemple de provisionnement dynamique (suite)

.exercise[
- Comment aurions-nous pu récupérer les données dans le dernier cas?
- Changeons alpine-rook.yaml en `kind:deployment`, écrivez quelques fichiers et tuez à nouveau le pod pour voir ce qui se passe.
]-->

