# Daemon sets

- Nous voulons passer à l'échelle `rng` d'une manière qui est différente de la façon dont nous avons passer à l'échelle `worker`

- Nous voulons une (et exactement une) instance de `rng` par noeud

- Et si nous déployions simplement `deploy/rng` sur le nombre de nœuds?

  - rien ne garantit que les conteneurs `rng` seront distribués uniformément

  - Si nous ajoutons des nœuds plus tard, ils ne lanceront pas automatiquement une copie de `rng`

  - Si nous supprimons (ou redémarrons) un nœud, un conteneur `rng` va redémarrer ailleurs

- Au lieu d'un `deployment`, nous utiliserons un `daemonset`

---

## Daemon set en pratique

- Les daemons sets sont parfaits pour les processus par nœud à l'échelle du cluster:

  - `kube-proxy`

  - `weave` (notre overlay de réseau)

  - agents de surveillance

  - des outils de gestion du matériel (par exemple des agents SCSI / FC HBA)

  - etc.

- Ils peuvent également être limités à l'exécution [uniquement sur certains nœuds](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/#running-pods-on-only-some-nodes)

---

## Création d'un daemon set

- Malheureusement, à partir de Kubernetes 1.10, l'interface de ligne de commande ne peut pas créer de jeux de démons

--

- Plus précisément: il n'a pas de sous-commande pour créer un daemon set

--

- Mais n'importe quel type de ressource peut toujours être créé en fournissant une description YAML:
  ```bash
  kubectl apply -f foo.yaml
  ```

--

- Comment créons-nous le fichier YAML pour notre daemon set?

--

  - option 1: [lire les docs](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/#create-a-daemonset)

--

  - option 2: `vi` notre moyen de sortir de celui-ci

---

## Création du fichier YAML pour notre daemon set

- Commençons par le fichier YAML pour la ressource `rng` courante

.exercise[

- Faites un dump du ressource `rng` dans YAML:
  ```bash
  kubectl get deploy/rng -o yaml --export> rng.yml
  ```

- Modifier `rng.yml`

]

Note: `--export` supprimera les informations spécifiques au cluster, c'est-à-dire:
- namespace (pour que la ressource ne soit pas liée à un espace de noms spécifique)
- status et creation timestamp (inutile lors de la création d'une nouvelle ressource)
- resourceVersion et uid (ils causeraient des problèmes ... *intéressants*)

---

## "Casting" d'une ressource à un autre

- Et si on changeait juste le champ `kind`?

  (Ça ne peut pas être aussi simple, non?)

.exercise[

- Changez `kind: Deployment` en `kind: DaemonSet`

- Enregistrer, quitter

- Essayez de créer notre nouvelle ressource:
  ```bash
  kubectl apply -f rng.yml
  ```

]

--

Nous savions tous que cela ne pourrait pas être aussi facile, non!

---

## Comprendre le problème

- Le coeur de l'erreur est:
  ```
  error validating data:
  [ValidationError(DaemonSet.spec):
  unknown field "replicas" in io.k8s.api.extensions.v1beta1.DaemonSetSpec,
  ...
  ```
--

- *De toute évidence,* cela n'a pas de sens de spécifier un nombre de réplicas pour un ensemble de démons

--

- Solution de contournement: résolvez le problème du YAML

  - supprimer le champ `replicas`
  - supprimer le champ `strategy` (qui définit le mécanisme de déploiement pour un déploiement)
  - enlever la ligne `status: {}` à la fin

--

- Ou, on pourrait aussi ...

---

## Utilise le `--force`, Luke

- Nous pourrions aussi dire à Kubernetes d'ignorer ces erreurs et essayer quand même

- Le nom actuel du flag `--force` est` --validate = false`

.exercise[

- Essayez de charger notre fichier YAML et ignorez les erreurs:
  ```bash
  kubectl apply -f rng.yml --validate=false
  ```

]

--

🎩✨🐇

--

Attendez ... Maintenant, cela peut-il être * aussi facile?

---

## Vérification de ce que nous avons fait

- Avons-nous transformé notre «deployment» en un «daemonset»?

.exercise[

- Regardez les ressources que nous avons maintenant:
  ```bash
  kubectl get all
  ```

]

--

Nous avons deux ressources appelées `rng`:

- le *deployment* existant avant

- le *daemon set* que nous venons de créer

Nous avons aussi un trop grand nombre de pods.
<br/>
(Le module correspondant au *deployment* existe toujours.)

---

## `deploy/rng` et `ds/rng`

- Vous pouvez avoir différents types de ressources avec le même nom

  (c'est-à-dire un *deploiement* et un *daemon set* tous deux nommés "rng")

- Nous avons toujours l'ancien déploiement `rng` * *

  ```
NAME                       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/rng        1         1         1            1           18m
  ```


- Mais maintenant nous avons le nouveau *daemon set* `rng`

  ```
NAME                DESIRED  CURRENT  READY  UP-TO-DATE  AVAILABLE  NODE SELECTOR  AGE
daemonset.apps/rng  2        2        2      2           2          <none>         9s
  ```

---

## Trop de pods

- Si nous vérifions avec `kubectl get pods`, nous voyons:
  - *un pod* pour le deployment (nommé `rng-xxxxxxxxxx-yyyyy`)
  - *un pod par nœud* pour le daemon set (nommé `rng-zzzzz`)

  ```
  NAME                        READY     STATUS    RESTARTS   AGE
  rng-54f57d4d49-7pt82        1/1       Running   0          11m
  rng-b85tm                   1/1       Running   0          25s
  rng-hfbrr                   1/1       Running   0          25s
  [...]
  ```
--

Le daemon set a créé un pod par nœud, sauf sur le nœud master. 
Le nœud principal a [taints](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) empêchant les pods de s'exécuter.

(Pour planifier un pod sur ce nœud de toute façon, le pod requiert les [tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) appropriées.)

<!-- .footnote[(Désactivé par un? Nous n'exécutons pas ces pods sur le nœud hébergeant le Control Plane.)] -->

---

## Que font tous ces pods?

- Vérifions les logs de tous ces pods `rng`

- Tous ces pods ont un label `run=rng`:

  - le premier pod, parce que c'est ce que `kubectl run` fait
  - les autres (dans le daemon set), parce que nous avons
    *copié la spécification du premier*

- Par conséquent, nous pouvons interroger les logs de tout le monde en utilisant ce selector `run=rng`

.exercise[

- Vérifier les logs de tous les pods ayant un label `run=rng`:
  ```bash
  kubectl logs -l run=rng --tail 1
  ```

]

--

Il semble que *tous les pods* servent des requêtes pour le moment.

---

## La magie des selectors

- Le *service* `rng` fait l'équilibrage de charge de requêtes vers un ensemble de pods

- Cet ensemble de pods est défini comme "pods ayant le label `run=rng`"

.exercise[

- Vérifiez le *selector* dans la définition du service `rng`:
  ```bash
  kubectl describe service rng
  ```

]

Lorsque nous avons créé des pods supplémentaires avec ce label, ils étaient
automatiquement détecté par `svc/rng` et ajouté en tant que *endpoints*
à l'équilibreur de charge associé.

---

## Retrait du premier pod de l'équilibreur de charge

- Que se passerait-il si on supprimait ce pod, avec `kubectl delete pod ...`?

--

  Le `replica set` le recréerait immédiatement.

--

- Que se passerait-il si nous enlevions le label `run=rng` de ce pod?

--

  Le `replica set` le recréerait immédiatement.

--

  ... Parce que ce qui compte pour le `replica set`, c'est le nombre de pods *correspondant à ce selector.*

--

- Mais mais mais ... N'avons-nous pas plus d'un pod avec `run=rng` maintenant?

--

  La réponse réside dans le selector exact utilisé par le `replica set` ...

---

## Plongée profonde dans les selectors

- Regardons les selectors pour le *deployment* `rng` et le *replica set* associé

.exercise[

- Afficher des informations détaillées sur le deployment `rng`:
  ```bash
  kubectl describe deploy rng
  ```

- Afficher des informations détaillées sur le réplica `rng`:
  <br/> (La deuxième commande ne nécessite pas que vous obteniez le nom exact du replica set)
  ```bash
  kubectl describe rs rng-yyyy
  kubectl describe rs -l run=rng
  ```

]

--

Le selector du replica set possède également un `pod-template-hash`, contrairement aux pods de notre daemon set.

---

# Mise à jour d'un service via des labels et des selectors

- Et si nous voulons supprimer le deployment `rng` de l'équilibreur de charge?

- Option 1:

  - Detruis-le

- Option 2:

  - ajouter un *label* supplémentaire au daemon set

  - mettre à jour le service *selector* pour faire référence à ce *label*

--

Bien sûr, l'option 2 offre plus d'opportunités d'apprentissage. Non?

---

## Ajouter un label supplémentaire au daemon set

- Nous mettrons à jour le daemon set "spec"

- Option 1:

  - éditez le fichier `rng.yml` que nous avons utilisé plus tôt

  - chargez la nouvelle définition avec `kubectl apply`

- Option 2:

  - utilisez `kubectl edit`

--

*Nous avons inclus quelques conseils sur les prochaines diapositives pour votre facilitation!*

---

## Nous avons mis des ressources dans vos ressources

- Rappel : un daemon set est une ressource qui crée plus de ressources!
- Il y a une différence entre:

  - le(s) label(s) d'une ressource (dans le bloc `metadata` au début)

  - le selector d'une ressource (dans le bloc `spec`)

  - le(s) label(s) de la (des) ressource(s) créée(s) par la première ressource (dans le bloc `template`)

- Vous devez mettre à jour le selector et le template (les labels de metadata ne sont pas obligatoires)

- Le template doit correspondre au selector
  (c'est-à-dire que la ressource refusera de créer des ressources qu'elle ne sélectionnera pas)

---

## Ajout de notre label

- Ajoutons un label `isactive: yes`

- En YAML, `yes` doit être cité; c'est-à-dire `isactive: "yes"`

.exercise[

- Mettre à jour le daemon set pour ajouter `isactive: "yes"` au label du selector et du template:
  ```bash
  kubectl edit daemonset rng
  ```

- Mettre à jour le service pour ajouter `isactive: "yes"` à son selector:
  ```bash
  kubectl edit service rng
  ```

]

---

## Vérification de ce que nous avons fait

.exercise[

- Vérifiez la ligne du log la plus récente de tous les pods `run=rng` pour confirmer que exactement un par nœud est maintenant actif:
  ```bash
  kubectl logs -l run=rng --tail 1
  ```

]

Les timestamps devraient nous donner un indice sur le nombre de pods qui reçoivent actuellement du trafic.

.exercise[

- Regardez les pods que nous avons en ce moment:
  ```bash
  kubectl get pods
  ```

]

---

## Nettoyage

- Les pods du deployment et le "vieux" daemon set sont toujours en cours d'exécution

- Nous allons les identifier par programme

.exercise[

- Listez les pods avec `run=rng` mais sans `isactive=yes`:
  ```bash
  kubectl get pods -l run=rng,isactive!=yes
  ```

- Enlevez ces pods:
  ```bash
  kubectl delete pods -l run=rng,isactive!=yes
  ```

]

---

## Nettoyage des pods morts

```
$ kubectl get pods
NAME                        READY     STATUS        RESTARTS   AGE
rng-54f57d4d49-7pt82        1/1       Terminating   0          51m
rng-54f57d4d49-vgz9h        1/1       Running       0          22s
rng-b85tm                   1/1       Terminating   0          39m
rng-hfbrr                   1/1       Terminating   0          39m
rng-vplmj                   1/1       Running       0          7m
rng-xbpvg                   1/1       Running       0          7m
[...]
```

- Les pods supplémentaires (notés `Terminating` ci-dessus) vont disparaître

- ... Mais un nouveau (`rng-54f57d4d49-vgz9h` ci-dessus) a été redémarré immédiatement!

--

- Rappelez-vous, le *deployment* existe toujours et vérifie qu'un pod est opérationnel

- Si on supprime le pod associé au deployment, il est recréé automatiquement

---

## Suppression d'un déploiement

.exercise[

- Supprimez le déploiement `rng`:
  ```bash
  kubectl delete deployment rng
  ```
]

-

- Le pod créé par le déploiement est en cours de finalisation:

```
$ kubectl get pods
NAME                        READY     STATUS        RESTARTS   AGE
rng-54f57d4d49-vgz9h        1/1       Terminating   0          4m
rng-vplmj                   1/1       Running       0          11m
rng-xbpvg                   1/1       Running       0          11m
[...]
```

Ding, dong, le déploiement est mort! Et le daemon set continue à vivre.

---

## Éviter les pods supplémentaires

- Lorsque nous avons changé la définition de daemon set, il a immédiatement créé de nouveaux pods. Nous avons dû enlever les anciens manuellement.

- Comment aurions-nous pu éviter cela?

-

- En ajoutant le label `isactive:"yes"` aux pods avant de changer le daemon set!

- Cela peut être fait par programme avec `kubectl patch`:

  ```bash
    PATCH='
    metadata:
      labels:
        isactive: "yes"
    '
    kubectl get pods -l run=rng -l controller-revision-hash -o name |
      xargs kubectl patch -p "$PATCH" 
  ```


---

## Labels et débogage

- Quand un pod se comporte mal, on peut le supprimer: un autre sera recréé

- Mais on peut aussi changer ses labels

- Il sera supprimé de l'équilibreur de charge (load balancer) (il ne recevra plus de trafic)

- Un autre pod sera recréé immédiatement

- Mais le pod problématique est toujours là, et nous pouvons l'inspecter et le déboguer

- Nous pouvons même le rajouter à la rotation si nécessaire

  (Très utile pour résoudre les bugs intermittents et insaisissables)

---

## Labels et contrôle de rollout avancé

- Inversement, nous pouvons ajouter des pods correspondant au selector d'un service

- Ces pods recevront alors des requêtes et serviront le trafic

- Exemples:

  - pod One-shot avec tous les flags de débogage activé, pour collecter des logs

  - pods créés automatiquement, mais ajoutés à la rotation dans une seconde étape
    <br/>
    (en définissant leur label en conséquence)

- Cela nous donne des blocs de construction pour les "canary" et "blue/green deployments"

---

## Pour aller plus loin

- Comprendre le concept des [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

- Comprendre les [labels et selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)




