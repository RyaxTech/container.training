# Accès aux logs depuis le CLI

- Les commandes `kubectl logs` ont des limitations:

  - il ne peut pas diffuser les logs de plusieurs pods à la fois

  - lors de l'affichage des logs de plusieurs pods, il les mélange tous ensemble

- Nous allons voir comment le faire mieux

---

## Le faire manuellement

- Nous *pourrions* (si nous étions si motivé), écrire un programme ou un script qui:

  - prendre un selector comme argument

  - énumérer tous les pods correspondant à ce selector (avec `kubectl get -l ...`)

  - fork un `kubectl logs --follow ...` commande par conteneur

  - annoter les logs (le résultat de chaque processus `kubectl logs ...`) avec leur origine

  - conserver la commande en utilisant `kubectl logs --timestamps ...` et fusionner la sortie

--

- Nous *pourrions* le faire, mais heureusement, d'autres l'ont déjà fait pour nous!

---

## Stern

[Stern](https://github.com/wercker/stern) est un projet open source
par [Wercker](http://www.wercker.com/).

À partir du fichier README:

*Stern vous permet d'empiler plusieurs pods sur Kubernetes et plusieurs conteneurs dans le pod. Chaque résultat est codé en couleur pour un débogage plus rapide.*

*La requête est une expression régulière, de sorte que le nom du pod peut facilement être filtré et que vous n'avez pas besoin de spécifier l'identifiant exact (par exemple en omettant l'ID de déploiement). Si un pod est supprimé, il est retiré de la queue et si un nouveau pod est ajouté, il est automatiquement suivi.*

Exactement ce dont nous avons besoin!

---

## Installation de Stern

- Pour simplifier, prenons simplement une version binaire

.exercise[

- Télécharger une version binaire de GitHub:
  ```bash
  sudo curl -L -o /usr/local/bin/stern \
       https://github.com/wercker/stern/releases/download/1.6.0/stern_linux_amd64
  sudo chmod +x /usr/local/bin/stern
  ```


]

Ces instructions d'installation fonctionneront sur nos clusters, car ce sont des VM Linux amd64.

---

## Utilisation de Stern

- Il existe deux façons de spécifier les pods pour lesquels nous voulons voir les logs:

  - `-l` suivi d'une expression de sélection (comme avec de nombreuses commandes `kubectl`)

  - avec une "requête de pod", c'est-à-dire une expression rationnelle (regex) utilisée pour faire correspondre les noms de pod

- Ces deux voies peuvent être combinées si nécessaire

.exercise[

- Voir les logs pour tous les conteneurs rng:
  ```bash
  stern rng
  ```

]

---

## Options pratiques Stern

- Le flag `--tail N` montre les dernières lignes `N` pour chaque conteneur

  (Au lieu d'afficher les logs depuis la création du conteneur)

- Le flag  `-t`/`--timestamps` montre les timestamps

- Le flag `--all-namespaces` est explicite

.exercise[

- Voir ce qui se passe avec les conteneurs du système `weave`:
  ```bash
  stern --tail 1 --timestamps --all-namespaces weave
  ```
]

---

## Utiliser Stern avec un selector

- Lorsque vous spécifiez un selector, nous pouvons omettre la valeur d'un label

- Cela va correspondre à tous les objets ayant cette label (quelle que soit la valeur)

- Tout ce qui a été créé avec `kubectl run` a une étiquette `run`

- Nous pouvons utiliser cette propriété pour voir les logs de tous les pod créés avec `kubectl run`

.exercise[

- Voir les logs pour toutes les choses commencées avec `kubectl run`:
  ```bash
  stern -l run
  ```
