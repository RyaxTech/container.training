# Rolling updates

- Rolling update est la mise à jour continue

- Par défaut (sans le rolling update), lorsqu'une ressource qui passe l'echelle est mise à jour:

  - De nouveaux pods sont créés

  - les anciennes pods sont terminées
  
  - ... Tout en même temps
  
  - Si quelque chose ne va pas, ¯\\\_(ツ)\_/¯

---

## Rolling updates

- Avec les 'rolling updates', lorsqu'une ressource est mise à jour, ca se fait progressivement

- Deux paramètres déterminent le rythme du rollout: `maxUnavailable` et `maxSurge`

- Ils peuvent être spécifiés en nombre absolu de pods, ou en pourcentage du nombre de replicas

- N'importe quand ...

  - il y aura toujours au moins des `replicas`-`maxUnavailable` pods disponibles

  - il n'y aura jamais plus que des `replicas`+`maxSurge` pods au total

  - il y aura donc jusqu'à  `maxUnavailable`+`maxSurge` pods qui sont mises a jour

- Nous avons la possibilité de revenir à la version précédente (rollback)
  <br/> (si la mise à jour échoue ou est insatisfaisante)

---

## Vérification des paramètres de déploiement actuels

- Rappelez-vous comment nous construisons des rapports personnalisés avec `kubectl` et `jq`:

.exercise[

- Afficher le plan de rollout pour nos deployments:
  ```bash
    kubectl get deploy -o json |
            jq ".items[] | {name:.metadata.name} + .spec.strategy.rollingUpdate"
  ```

]

---


## Rolling update en pratique

- À partir de Kubernetes 1.8, nous pouvons faire des rolling update avec:

  `deployments`, `daemonsets`, `statefulsets`

- La modification de l'une de ces ressources entraînera automatiquement une mise à jour progressive

- Les rolling updates peuvent être surveillées avec la sous-commande `kubectl rollout`

---

## Construire une nouvelle version du service `worker`

.exercise[

- Allez dans le répertoire `stacks`:
  ```bash
  cd ~/container.training/stacks
  ```

- Editez `dockercoins/worker/worker.py`, mettez à jour la ligne `sleep` pour dormir 1 seconde

- Construire un nouveau tag et le pousser dans le registry:
  ```bash
  #export REGISTRY=localhost:3xxxx
  export TAG=v0.2
  docker-compose -f dockercoins.yml build
  docker-compose -f dockercoins.yml push
  ```

]

---

## Rolling out du nouveau service `worker`

.exercise[

- Surveillons ce qui se passe en ouvrant quelques terminaux, et exécutons:
  ```bash
  kubectl get pods -w
  kubectl get replicasets -w
  kubectl get deployments -w
  ```

- Mettre à jour `worker` soit avec `kubectl edit`, soit en exécutant:
  ```bash
  kubectl set image deploy worker worker=$REGISTRY/worker:$TAG
  ```

]

--

Ce rollout devrait être assez rapide. Que montre l'interface web?

---

## Donnez-lui du temps

- Au début, il semble que rien ne se passe (le graphique reste au même niveau)

- Selon `kubectl get deploy -w`, le `deployment` a été mis à jour très rapidement

- Mais `kubectl get pods -w` raconte une histoire différente

- Les anciens `pods` sont toujours là, et ils restent dans l'état `Terminating` pendant un certain temps

- Finalement, ils sont terminés; puis le graphique diminue de manière significative

- Ce retard est dû au fait que notre worker ne gère pas les signaux

- Kubernetes envoie une requête d'arrêt "polie" au worker, qui l'ignore

- Après une période de grâce, Kubernetes s'impatiente et tue le conteneur

  (La période de grâce est de 30 secondes, mais [peut être modifiée](https://kubernetes.io/docs/concepts/workloads/pods/pod/#termination-of-pods) si nécessaire)

---

## Le cas d'une erreur

- Que se passe-t-il si nous faisons une erreur?

.exercise[

- Mettre à jour `worker` en spécifiant une image inexistante:
  ```bash
  export TAG=v0.3
  kubectl set image deploy worker worker=$REGISTRY/worker:$TAG
  ```

- Vérifiez ce qui se passe:
  ```bash
  kubectl rollout status deploy worker
  ```

]

--

Notre déploiement est bloqué. Cependant, l'application n'est pas morte (seulement 10% plus lent).

---

## Que se passe-t-il avec notre déploiement?

- Pourquoi notre application est-elle 10% plus lente?

- Parce que `MaxUnavailable=1`, le deployment s'est terminé 1 replica sur 10 disponible

- D'accord, mais pourquoi voyons-nous 2 nouvelles replicas en cours de deployment?

- Parce que `MaxSurge=1`, donc en plus de remplacer le "terminated", le déploiement demarre un de plus

---

class: extra-details

## Quelques détails

- Nous commençons avec 10 pods en cours d'exécution pour le déploiement `worker`

- Paramètres actuels: MaxUnavailable=1 et MaxSurge=1

- Quand nous commençons le déploiement:

  - un replicas est supprimée (selon MaxUnavailable = 1)
  - un autre est créé (avec la nouvelle version) pour le remplacer
  - un autre est créé (avec la nouvelle version) par MaxSurge = 1

- Nous avons maintenant 9 réplicas en service et 2 en cours de déploiement

- Notre déploiement est bloqué à ce stade!

---

## Récupération à partir d'un mauvais déploiement

- Nous pourrions pousser une image `v0.3`

  (la logique de réessai de pod l'attrapera finalement et le déploiement se poursuivra)

- Ou nous pourrions invoquer une restauration manuelle

.exercise[

- Annuler le déploiement et attendre que la poussière s'installe:
  ```bash
  kubectl rollout undo deploy worker
  kubectl rollout status deploy worker
  ```

]

---

## Modification des paramètres de rollout

- Nous voulons:

  - revenir à `v0.1`
  - être prudent sur la disponibilité (toujours avoir le nombre désiré de workers disponibles)
  - être agressif sur la vitesse de rollout (mettre à jour plus d'un pod à la fois)
  - donner un peu de temps à nos workers pour "se réchauffer" avant de commencer plus

Les modifications correspondantes peuvent être exprimées dans l'extrait YAML suivant:

.small[
```yaml
spec:
  template:
    spec:
      containers:
      - name: worker
        image: $REGISTRY/worker:v0.1
  strategy:
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 3
  minReadySeconds: 10
```
]


---

## Application de modifications via un patch YAML

- Nous pourrions utiliser `kubectl edit deployment worker`

- Mais nous pourrions également utiliser `kubectl patch` avec le YAML exact montré avant

.exercise[

.small[

- Appliquez tous nos changements et attendez qu'ils prennent effet:
  ```bash
  kubectl patch deployment worker -p "
    spec:
      template:
        spec:
          containers:
          - name: worker
            image: $REGISTRY/worker:v0.1
      strategy:
        rollingUpdate:
          maxUnavailable: 0
          maxSurge: 3
      minReadySeconds: 10
    "
  kubectl rollout status deployment worker
  kubectl get deploy -o json worker |
          jq "{name:.metadata.name} + .spec.strategy.rollingUpdate"
  ```
  ] 

]


