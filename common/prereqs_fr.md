# Pré-requis

- Soyez à l'aise avec la ligne de commande UNIX

  - naviguer dans les répertoires

  - éditer des fichiers

  - un peu de bash (variables d'environnement, boucles)

- Quelques connaissances de Docker

  - `docker run`,` docker ps`, `docker build`

  - idéalement, vous savez écrire un Dockerfile et le construire
    <br/>
    (même si c'est une ligne `FROM` et quelques commandes` RUN`)

- C'est tout à fait OK si vous n'êtes pas un expert Docker!

---

class: title

*Dites-moi et j'oublie.*
<br/>
*Apprends-moi et je me souviens.*
<br/>
*Implique-moi et j'apprends.*

Erronément attribué à Benjamin Franklin

[(Probablement inspiré par le philosophe confucéen chinois Xunzi)](https://www.barrypopik.com/index.php/new_york_city/entry/tell_me_and_i_forget_teach_me_and_i_may_remember_involve_me_and_i_will_lear/)

---

## Sections pratiques

- Tout l'atelier est pratique

- Nous allons construire, expédier et faire fonctionner des conteneurs!

- Nous allons reproduire toutes les démos

- Toutes les sections pratiques sont clairement identifiées, comme le rectangle gris ci-dessous

.exercise[

- C'est ce que tu es censé faire!

<!-- - Allez dans [kube.training] (https://goo.gl/dekbTb) pour voir ces diapositives -->

]

---

class: in person

## Où allons-nous faire fonctionner nos conteneurs?

---

class: in person, pic

![Vous obtenez un cluster](images/you-get-a-cluster.jpg)

---

class: in person

## Vous obtenez un cluster de machines virtuelles cloud

- Chaque personne reçoit un cluster privé de machines virtuelles cloud (non partagées avec d'autres utilisateurs)

- Ils resteront la pendant la durée de la formation

- Vous pouvez automatiquement SSH d'une VM à l'autre

- Les nœuds ont des alias: `node1`, `node2`...

---

class: in person

## Pourquoi ne faisons-nous pas des conteneurs localement?

- L'installation de ce truc peut être difficile sur certaines machines

  (32 bits CPU ou OS ... Ordinateurs portables sans accès administrateur ... etc.)

- Tout ce dont vous avez besoin est un ordinateur (ou même un téléphone ou une tablette!), Avec:

  - une connexion internet

  - un navigateur Web

  - un client SSH

---

class: in person

## Connexion à l'environnement d'exercices

.exercise[

- Connectez-vous à la première machine virtuelle (`node1`) avec votre client SSH

- Vérifiez que vous pouvez SSH (sans mot de passe) à `node2`:
  ```bash
  ssh node2
  ```
- Tapez `exit` ou` ^ D` pour revenir à `asterix-1`

]

Si quelque chose ne va pas, demandez de l'aide!

---

## Faire ou refaire des exercises seul?

- Utilisez quelque chose comme
  [Play-With-Docker](http://play-with-docker.com/) ou
  [Play-With-Kubernetes](https://medium.com/@marcosnils/introducing-pwk-play-with-k8s-159fcfeb787b)

  Zéro effort d'installation; mais l'environnement est de courte durée et
  pourrait avoir des ressources limitées

- Créez votre propre cluster (VM locales ou cloud)

  Petit effort d'installation; petit coût; environnements flexibles

- Créer un tas de clusters pour vous et vos amis
    ([instructions](https://github.com/RyaxTech/kube.training/tree/master/prepare-vms))

  Effort de configuration plus important; idéal pour la formation de groupe

---

## Nous allons (surtout) interagir avec node1 seulement

*Ces remarques ne s'appliquent que lorsque vous utilisez plusieurs nœuds, bien sûr.*

- Sauf instructions, **toutes les commandes doivent être exécutées à partir de la première VM, `node1`**

- Nous allons seulement vérifier / copier le code sur `node1`

- Pendant les opérations normales, nous n'avons pas besoin d'accéder aux autres nœuds

- Si nous devions résoudre les problèmes, nous utiliserions une combinaison de:

  - SSH (pour accéder aux logs du système, état du démon ...)
  
  - API Docker (pour vérifier l'état des conteneurs en cours d'exécution et du moteur de conteneur)

