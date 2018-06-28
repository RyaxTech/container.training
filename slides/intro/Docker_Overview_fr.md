# Vue d'ensemble de Docker

Dans cette partie, nous allons apprendre:

* Pourquoi les conteneurs ('elevator pitch' non-technique)

* Pourquoi les conteneurs ('elevator pitch' technique)

* Comment Docker nous aide à construire, expédier et exécuter

* L'histoire des conteneurs

Nous n'utiliserons pas Docker ni les conteneurs dans ce chapitre (pour l'instant!).

Ne vous inquiétez pas, nous y arriverons assez vite!

---

## Elevator pitch

### (pour votre manager, votre patron ...)

---

## OK ... Pourquoi le buzz autour des conteneurs?

* L'industrie du logiciel a changé

* Avant:
  * applications monolithiques
  * longs cycles de développement
  * environnement unique
  * redimensionner lentement

* À présent:
  * services découplés
  * améliorations rapides et itératives
  * plusieurs environnements
  * Élargir rapidement

---

## Le déploiement devient très complexe

* Beaucoup de piles différentes:
  * langues
  * cadres
  * des bases

* Beaucoup de cibles différentes:
  * environnements de développement individuels
  * pré-production, QA, mise en scène ...
  * production: sur prém, nuage, hybride

---

class: pic

## Le problème de déploiement

![problem](images/shipping-software-problem.png)

---

class: pic

## La matrice de l'enfer

![matrix](images/shipping-matrix-from-hell.png)

---

class: pic

## Le parallèle avec l'industrie maritime

![history](images/shipping-industry-problem.png)

---

class: pic

## Conteneurs d'expédition intermodaux

![shipping](images/shipping-industry-solution.png)

---

class: pic

## Un nouvel écosystème d'expédition

![shipeco](images/shipping-indsutry-results.png)

---

class: pic

## Un système de conteneur d'expédition pour les applications

![shipapp](images/shipping-software-solution.png)

---

class: pic

## Éliminer la matrice de l'enfer

![elimatrix](images/shipping-matrix-solved.png)

---

## Résultats

* [Dev-to-prod réduit de 9 mois à 15 minutes (ING)](
  https://www.docker.com/sites/default/files/CS_ING_01.25.2015_1.pdf)

* [Temps d'intégration continue réduit de plus de 60% (BBC)](
  https://www.docker.com/sites/default/files/CS_BBCNews_01.25.2015_1.pdf)

* [Déployer 100 fois par jour au lieu d'une fois par semaine (GILT)](
  https://www.docker.com/sites/default/files/CS_Gilt%20Groupe_03.18.2015_0.pdf)

* [Consolidation de l'infrastructure de 70% (MetLife)](
  https://www.docker.com/customers/metlife-transforms-customer-experience-legacy-and-microservices-mashup)

* [Consolidation de l'infrastructure de 60% (Intesa Sanpaolo)](
  https://blog.docker.com/2017/11/intesa-sanpaolo-builds-resilient-foundation-banking-docker-enterprise-edition/)

* [14x densité d'application; 60% du centre de données existant migré en 4 mois (GE Appliances)](
  https://www.docker.com/customers/ge-uses-docker-enable-self-service-their-developers)

* etc.

---

## Elevator pitch

###(pour vos collègues devs et ops)

---

## Échapper à la dépendance d'enfer

1. Écrire les instructions d'installation dans un fichier `INSTALL.txt`

2. En utilisant ce fichier, écrivez un script `install.sh` qui *vous convient*

3. Transformez ce fichier dans un `Dockerfile`, testez-le sur votre machine

4. Si le Dockerfile se construit sur votre machine, il se construira *n'importe où*

5. Réjouis-toi en évitant l'enfer de la dépendance et "ca marche sur ma machine"

---

## Développeurs et contributeurs embarqués rapidement

1. Écrire des fichiers Docker pour vos composants d'application

2. Utilisez des images pré-faites depuis le Docker Hub (mysql, redis ...)

3. Décrivez votre pile avec un fichier Compose

4. Embarquez quelqu'un avec deux commandes:

```bash
git clone ...
docker-compose up
```

Avec cela, vous pouvez créer des environnements de développement, d'intégration et d'assurance qualité en quelques minutes!

---

class: extra-details

## Mettre en œuvre un CI fiable facilement

1. Construire un environnement de test avec un fichier Dockerfile ou Compose

2. Pour chaque série de tests, placez un nouveau conteneur ou une nouvelle pile

3. Chaque course est maintenant dans un environnement propre

4. Aucune pollution des tests précédents

Beaucoup plus rapide et moins cher que de créer des machines virtuelles à chaque fois!

---

class: extra-details

## Utiliser les images de conteneur comme artefacts de construction

1. Construisez votre application depuis Dockerfiles

2. Stocker les images résultantes dans un registre

3. Garde-les pour toujours (ou aussi longtemps que nécessaire)

4. Testez ces images dans QA, CI, intégration ...

5. Exécuter les mêmes images en production

6. Quelque chose ne va pas? Retour à l'image précédente

7. Enquêter sur l'ancienne régression? L'ancienne image vous couvre!

Les images contiennent toutes les bibliothèques, dépendances, etc. nécessaires pour exécuter l'application.

---

class: extra-details

## Découpler "plomberie" de la logique de l'application

1. Ecrivez votre code pour vous connecter aux services nommés ("db", "api" ...)

2. Utilisez Composer pour commencer votre pile

3. Docker va configurer le résolveur DNS par conteneur pour ces noms

4. Vous pouvez maintenant redimensionner, ajouter des équilibreurs de charge, réplication ... sans changer votre code

Note: ceci n'est pas couvert dans cet atelier de niveau intro!

---

class: extra-details

## Qu'est-ce que Docker a apporté à la table?

### Docker avant / après

---

class: extra-details

## Formats et API, avant Docker

* Pas de format d'échange standardisé.
  <br/>(Non, une archive tar de rootfs *n'est pas* un format!)

* Les conteneurs sont difficiles à utiliser pour les développeurs.
  <br/>(Où est l'équivalent de `docker run debian`?)

* En conséquence, ils sont cachés aux utilisateurs finaux.

* Aucun composant, API ou outil réutilisable.
  <br/>(Au mieux: abstractions de VM, par exemple libvirt.)


Analogie:

* Les conteneurs d'expédition ne sont pas seulement des boîtes en acier.
* Ce sont des boîtes en acier de taille standard, avec les mêmes crochets et trous.

---

class: extra-details

## Formats et API, après Docker

* Normaliser le format du conteneur, car les conteneurs n'étaient pas portables.

* Rendre les conteneurs faciles à utiliser pour les développeurs.

* Accent sur les composants réutilisables, API, écosystème d'outils standards.

* Amélioration des outils spécifiques ad-hoc, internes.

---

class: extra-details

## Expédition, avant Docker

* Expédier les paquets: deb, rpm, gem, pot, homebrew ...

* Dépendance de l'enfer.

* "Fonctionne sur ma machine."

* Déploiement de base souvent fait à partir de zéro (debootstrap ...) et peu fiable.

---

class: extra-details

## Expédition, après Docker

* Expédier des images de conteneur avec toutes leurs dépendances.

* Les images sont plus grandes, mais elles sont divisées en couches.

* Envoyez uniquement les couches qui ont changé.

* Enregistrer l'utilisation du disque, du réseau, de la mémoire.

---

class: extra-details

## Exemple

Couches:

* CentOS
* JRE
* Matou
* Dépendances
* Application JAR
* Configuration

---

class: extra-details

## Devs vs Ops, avant Docker

* Déposez une archive tar (ou un hash de commit) avec des instructions.

* Environnement de développement très différent de la production.

* Les Ops n'ont pas toujours un environnement de dev eux-mêmes ...

* ... et quand ils le font, cela peut différer de ceux des développeurs.

* Les opérations doivent trier les différences et le faire fonctionner ...

* ... ou rebondir vers les développeurs.

* Le code de livraison provoque des frictions et des retards.

---

class: extra-details

## Devs vs Ops, après Docker

* Déposer une image de conteneur ou un fichier de composition.

* Les opérations peuvent toujours exécuter cette image de conteneur.

* Les opérations peuvent toujours exécuter ce fichier de composition.

* Les opérations doivent encore s'adapter à l'environnement de prod,
   mais au moins ils ont un point de référence.

* Les opérations ont des outils permettant d'utiliser la même image
   en dev et prod.

* Les développeurs peuvent être autorisés à faire eux-mêmes des publications
   plus facilement.
