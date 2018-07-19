# Gérer nos premiers conteneurs sur Kubernetes

- Premières choses d'abord: nous ne pouvons pas executer un conteneur

--

- Nous allons lancer un pod, et dans ce pod il y aura un seul conteneur

--

- Dans ce conteneur dans le pod, nous allons lancer une simple commande `ping`

- Ensuite, nous allons commencer des copies supplémentaires du pod

---

## Démarrer un pod simple avec `kubectl run`

- Nous devons spécifier au moins un *name* et l'image que nous voulons utiliser

.exercise[

- Nous allong pinger `1.1.1.1`, Cloudflare's
  [DNS public resolver](https://blog.cloudflare.com/announcing-1111/):
  ```bash
  kubectl run pingpong --image alpine ping 1.1.1.1
  ```

]

--

OK, qu'est-ce qui vient de se passer?

---

## Dans les coulisses de `kubectl run`

- Regardons les ressources qui ont été créées par `kubectl run`

.exercise[

- Listez la plupart des types de ressources:
  ```bash
  kubectl get all
  ```

]

--

Nous devrions voir les choses suivantes:
- `deployment.apps/pingpong` (le *deployment* que nous venons de créer)
- `replicaset.apps/pingpong-xxxxxxxxxx` (un *replica set* créé par le deployment)
- `pod/pingpong-xxxxxxxxxx-yyyyy` (un *pod* créé par le replica set)

Note: à partir de 1.10.1, les types de ressources sont affichés plus en détail.

---

## Quelles sont ces différentes choses?

- Un *deployment* est une construction de haut niveau

  - permet le "scaling", "rolling updates", "rollbacks"

  - plusieurs déploiements peuvent être utilisés ensemble pour mettre en œuvre
    [canary deployment](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#canary-deployments)

  - délègue la gestion des pods aux *replica sets*

- Un *replica set* est une construction de bas niveau

  - s'assure qu'un nombre donné de pods identiques fonctionnent

  - permet le "scaling"

  - rarement utilisé directement

---

## Notre deployment `pingpong`

- `kubectl run` a créé un *deployment*,`deployment.apps/pingpong`

```
NAME                       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/pingpong   1         1         1            1           10m
```

- Ce deployment a créé un *replica set*, `replicaset.apps/pingpong-xxxxxxxxxx`

```
NAME                                  DESIRED   CURRENT   READY     AGE
replicaset.apps/pingpong-7c8bbcd9bc   1         1         1         10m
```

- Ce replica set a créé un *pod*, `pod/pingpong-xxxxxxxxxx-yyyyy`

```
NAME                            READY     STATUS    RESTARTS   AGE
pod/pingpong-7c8bbcd9bc-6c9qz   1/1       Running   0          10m
```

- Nous verrons plus tard comment ces trucs jouent ensemble pour:

    - scaling, high availability, rolling updates
---

## Affichage de la sortie du conteneur

- Utilisons la commande `kubectl logs`

- Nous allons passer soit un *pod name*, soit un *type/name*

  (Par exemple, si nous spécifions un deployment ou un replica set, il recevra le premier pod)

- Sauf indication contraire, il ne montrera que les logs du premier conteneur dans le pod

  (Bonne chose, il n'y en a qu'une dans la nôtre!)

.exercise[

- Voir le résultat de notre commande `ping`:
  ```bash
  kubectl logs deploy/pingpong
  ```

]

---

## Flux de logs en temps réel

- Tout comme `docker logs`, `kubectl logs` supporte les options pratiques:

  - `-f`/`--follow` pour streamer les logs en temps réel (à la `tail -f`)

  - `--tail` pour indiquer combien de lignes vous voulez voir (à partir de la fin)

  - `--since` pour obtenir les logs seulement après un timestamp donné

.exercise[

- Voir les derniers logs de notre commande `ping`:
  ```bash
  kubectl logs deploy/pingpong --tail 1 --follow
  ```

]

---

## "Scaling" de notre application

- Nous pouvons créer des copies supplémentaires de notre conteneur (je veux dire, notre pod) avec «kubectl scale»

.exercise[

- Scale notre deployment `pingpong`:
  ```bash
  kubectl scale deploy/pingpong --replicas 8
  ```

]

Note: Et si nous essayions de scaler `replicaset.apps/pingpong-xxxxxxxxxx`?

Nous pourrions! Mais le *deployment* le remarquerait tout de suite et reviendrait au niveau initial.

---

## Résilience

- Le *deployment* `pingpong` regarde son *replica set*

- Le *replica set* assure que le bon nombre de *pods* sont en cours d'exécution

- Que se passe-t-il si les pods disparaissent?

.exercise[

- Dans une fenêtre séparée, affichez les pods et continuez à les regarder:
  ```bash
  kubectl get pods -w
  ```

- Détruire un pod:
  ```bash
  kubectl delete pod pingpong-xxxxxxxxxx-yyyyy
  ```
]

---

## Et si on voulait quelque chose de différent?

- Et si nous voulions démarrer un conteneur "one-shot" qui ne redémarre pas?

- Nous pourrions utiliser `kubectl run --restart=OnFailure` ou `kubectl run --restart=Never`

- Ces commandes créeraient *jobs* ou *pods* au lieu de *deployments*

- Sous le tapis, `kubectl run` invoque des "generators" pour créer des descriptions de ressources

- Nous pourrions aussi écrire nous-mêmes ces descriptions de ressources (typiquement en YAML), et les créer sur le cluster avec `kubectl apply -f` (discuté plus tard)

- Avec `kubectl run --schedule=...`, nous pouvons aussi créer des *cronjobs*

---

## Affichage des logs de plusieurs pods

- Lorsque nous spécifions un nom de deployment, seuls les logs d'un seul pod sont affichés

- Nous pouvons voir les logs de plusieurs pods en spécifiant un *selector*

- Un selector est une expression logique utilisant des *labels*

- Commodément, quand vous "kubectl run somename", les objets associés ont un label `run = somename`

.exercise[

- Regardez la dernière ligne du log de tous les pods avec le label `run = pingpong`:
  ```bash
  kubectl logs -l run=pingpong --tail 1
  ```

]

Malheureusement, `--follow` ne peut pas (encore) être utilisé pour diffuser les logs de plusieurs conteneurs.

---

## Ne nous inondons pas 1.1.1.1?

- Si vous vous posez cette question, bonne question!

- Ne vous inquiétez pas, cependant:

  *Le groupe de recherche de l'APNIC détenait les adresses IP 1.1.1.1 et 1.0.0.1. Alors que les adresses étaient valides, tant de gens les avaient entrés dans divers systèmes aléatoires qu'ils étaient continuellement submergés par un flot de déchets. L'APNIC voulait étudier ce trafic de déchets, mais chaque fois qu'il avait essayé d'annoncer les IP, l'inondation submergerait tout réseau conventionnel.*

  (Source: https://blog.cloudflare.com/announcing-1111/)

- Il est très peu probable que nos pings concertés parviennent à produire
  même un modeste coup au Cloudflare!

---

## Tout couper

.exercise[

- Arrétez le deployment:
  ```bash
  kubectl delete deploy/pingpong
  ```
- Quel est l'état de l'application ?
  ```bash
  kubectl get all
  ```

]

- Pour aller plus loin:

  - [Lancer un deployement dupuis un fichier YAML](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/)

  - [Lancer un *cronjob*](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/)

