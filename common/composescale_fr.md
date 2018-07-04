## Redémarrage en arrière-plan

- De nombreux flags et commandes de Compose sont modélisés après ceux de `docker`

.exercise[

- Démarrez l'application en arrière-plan avec l'option `-d`:
  ```bash
  docker-compose up -d
  ```

- Vérifiez que notre application fonctionne avec la commande `ps`:
  ```bash
  docker-compose ps
  ```

]

`docker-composer ps` montre également les ports exposés par l'application.

---

class: extra-details

## Affichage des logs

- La commande `docker-compose logs` fonctionne comme les `docker logs`

.exercise[

- Voir tous les logs depuis la création du conteneur et quitter lorsque vous avez terminé:
  ```bash
  docker-compose logs
  ```

- Diffuser les logs de conteneur, en commençant par les 10 dernières lignes pour chaque conteneur:
  ```bash
  docker-compose logs --tail 10 --follow
  ```

]

Astuce: utilisez `^ S` et` ^ Q` pour mettre en pause / reprendre la sortie du log.

---

## Passage à l'échelle de l'application

- Notre objectif est de faire monter ce graphique de performance (sans changer de ligne de code!)

-

- Avant d'essayer de faire évoluer l'application, nous déterminerons si nous avons besoin de plus de ressources

  (CPU, RAM ...)

- Pour cela, nous utiliserons de bons vieux outils UNIX sur notre noeud Docker

---

## Regard sur l'utilisation des ressources

- Regardons le CPU, la mémoire et l'utilisation des I/O

.exercise[

- Exécutez `top` pour voir l'utilisation du processeur et de la mémoire (vous devriez voir les cycles d'inactivité)


- Exécutez `vmstat 1` pour voir l'utilisation des I/O (si/so/bi/bo)
  <br/>(les 4 nombres devraient être presque zéro, sauf `bo` pour l'enregistrement)

]

Nous avons des ressources disponibles.

- Pourquoi?
- Comment pouvons-nous les utiliser?

---

## Passage à l'échelle des workers sur un seul noeud

- Docker Compose prend en charge le passage à l'échelle
- Nous allons scaler  `worker` et voir ce qui se passe!

.exercise[

- Démarrer un autre conteneur `worker`:
  ```bash
  docker-compose up --scale worker = 2
  ```

- Regardez le graphique de performance (il devrait montrer une amélioration de x2)

- Regardez les logs agrégés de nos conteneurs (`worker_2` devrait apparaître)

- Regardez l'impact sur la charge du processeur avec, par exemple, haut (il devrait être négligeable)

]

---

## Ajouter plus de workers

- Super, ajoutons plus de workers, alors!

.exercise[

- Commencez huit autres conteneurs «worker»:
  ```bash
  docker-compose up --scale worker = 10
  ```

- Regardez le graphique des performances: montre-t-il une amélioration x10?

- Regardez les logs agrégés de nos conteneurs

- Regardez l'impact sur la charge du processeur et l'utilisation de la mémoire

]

---

# Identifier les goulots d'étranglement

- Vous devriez avoir vu une amelioration de vitesse 3x (pas 10x)

- L'ajout de workers n'a pas entraîné d'amélioration linéaire

- * Quelque chose d'autre * nous ralentit

-

- ... Mais quoi?

-

- Le code n'a pas d'instrumentation

- Utilisons l'analyse de performance HTTP de pointe!
  <br/> (c'est-à-dire de bons vieux outils comme `ab`,` https` ...)

---

## Accès aux services internes

- `rng` et` hasher` sont exposés sur les ports 8001 et 8002

- Ceci est déclaré dans le fichier Compose:

  ```yaml
    ...
    rng:
      build: rng
      ports:
      - "8001:80"

    hasher:
      build: hasher
      ports:
      - "8002:80"
    ...
  ```

---

## Mesure de la latence en charge

Nous allons utiliser `httping`.

.exercise[

- Vérifiez la latence de `rng`:
  ```bash
  https -c 3 localhost: 8001
  ```

- Vérifiez la latence de `hasher`:
  ```bash
  https -c 3 localhost: 8002
  ```

]

`rng` a une latence beaucoup plus élevée que` hasher`.

---

## Tirons des conclusions simplistes

- Le goulot d'étranglement semble être `rng`

- *Que se passe-t-il si* nous n'avons pas assez d'entropie et que nous ne pouvons pas générer suffisamment de nombres aléatoires?

- Nous devons étendre le service `rng` sur plusieurs machines!

Note: ceci est une fiction! Nous avons assez d'entropie. Mais nous avons besoin d'un prétexte pour l'étendre.

(En fait, le code de `rng` utilise `/dev/urandom`, qui ne manque jamais d'entropie ...
<br/>
... et est [aussi bon que `/dev/random`](http://www.slideshare.net/PacSecJP/filippo-plain-simple-reality-of-entropy).)
