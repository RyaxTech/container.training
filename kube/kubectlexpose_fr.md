# Exposition des conteneurs

<div class="viz-float-right"><div class="vizgraph">
digraph { "Service A" [shape=hexagon] }
</div></div>

- `kubectl expose` crée un *service* pour les pods existants

- Un *service* est une adresse stable pour un pod (ou un groupe de pods)

- Si nous voulons nous connecter à notre (nos) pod(s), nous devons créer un *service*

- Une fois qu'un service est créé, `kube-dns` nous permettra de l'acceder par son nom

  (c'est-à-dire après avoir créé le service "hello", le nom "hello" va se lier à quelque chose)

- Il existe différents types de services, détaillés sur les diapositives suivantes:

  `ClusterIP`,` NodePort`, `LoadBalancer`,` ExternalName`

---

## Types de service de base

- `ClusterIP` (type par défaut)

  - une adresse IP virtuelle est allouée au service (dans une plage interne, privée)
  - cette adresse IP est accessible uniquement depuis le cluster (nœuds et pods)
  - notre code peut se connecter au service en utilisant le numéro de port d'origine

- `NodePort`

  - un port est attribué au service (par défaut, dans la plage 30000-32768)
  - ce port est disponible *sur tous nos nœuds* et n'importe qui peut s'y connecter
  - notre code doit être changé pour se connecter à ce nouveau numéro de port

Ces types de service sont toujours disponibles.

Sous le tapis: `kube-proxy` utilise un proxy userland et un tas de règles `iptables`.

---

## Plus de types de services

- `LoadBalancer`

  - un équilibreur de charge externe est affecté au service
  - l'équilibreur de charge est configuré en conséquence
    <br/>(par exemple: un service `NodePort` est créé et l'équilibreur de charge envoie le trafic vers ce port)

- `ExternalName`

  - l'entrée DNS gérée par `kube-dns` sera juste un `CNAME` dans un enregistrement fourni
  - pas de port, pas d'adresse IP, rien d'autre n'est attribué

Le type `LoadBalancer` est actuellement disponible uniquement sur AWS, Azure et GCE.

---

## Exécuter des conteneurs avec des ports ouverts

- Puisque `ping` n'a rien à connecter, nous devrons exécuter autre chose

.exercise[

- Démarrer un tas de conteneurs ElasticSearch:
  ```bash
  kubectl run elastic --image=elasticsearch:2 --replicas=7
  ```

- Regardez-les commencer:
  ```bash
  kubectl get pods -w
  ```

]

L'option `-w` "watches" les événements se produisant sur les ressources spécifiées.

Note: veuillez NE PAS appeler le service `search`. Cela entrerait en conflit avec le TLD.

---

## Exposant notre déploiement

- Nous allons créer un service `ClusterIP` par défaut

.exercise[

- Exposez le port de l'API HTTP ElasticSearch:
  ```bash
  kubectl expose deploy/elastic --port 9200
  ```

- Rechercher quelle adresse IP a été attribuée:
  ```bash
  kubectl get svc
  ```

]

---

## Les objets que nous venons de créer

<div class="viz-center"><div class="vizgraph">
digraph {

"Pod\nelastic-fd4fd-s89" [shape=circle]
"Pod\nelastic-fd4fd-df7" [shape=circle]
"Pod\nelastic-fd4fd-hzd" [shape=circle]
"Pod\nelastic-fd4fd-c4c" [shape=circle]
c1 [shape=cds, label="container: elasticsearch:2"]
c2 [shape=cds, label="container: elasticsearch:2"]
c3 [shape=cds, label="container: elasticsearch:2"]
c4 [shape=cds, label="container: elasticsearch:2"]


"Pod\nelastic-fd4fd-s89" -> c1
"Pod\nelastic-fd4fd-df7" -> c2
"Pod\nelastic-fd4fd-hzd" -> c3
"Pod\nelastic-fd4fd-c4c" -> c4

"Svc NodePort elastic" [shape=hexagon]
"Svc NodePort elastic" -> "Pod\nelastic-fd4fd-s89"
"Svc NodePort elastic" -> "Pod\nelastic-fd4fd-df7"
"Svc NodePort elastic" -> "Pod\nelastic-fd4fd-hzd"
"Svc NodePort elastic" -> "Pod\nelastic-fd4fd-c4c"

"Deploy elastic" [shape=trapezium]
"ReplicaSet elastic-fd4fd" [shape=house]
"Deploy elastic" -> "ReplicaSet elastic-fd4fd"
"ReplicaSet elastic-fd4fd" -> "Pod\nelastic-fd4fd-s89"
"ReplicaSet elastic-fd4fd" -> "Pod\nelastic-fd4fd-df7"
"ReplicaSet elastic-fd4fd" -> "Pod\nelastic-fd4fd-hzd"
"ReplicaSet elastic-fd4fd" -> "Pod\nelastic-fd4fd-c4c"


}
</div></div>



---

## Les services sont des constructions de couche 4

- Vous pouvez attribuer des adresses IP aux services, mais ils sont toujours *couche 4*

  (c'est-à-dire qu'un service n'est pas une adresse IP, c'est une adresse IP + un protocole + un port)

- Ceci est causé par l'implémentation actuelle de `kube-proxy`

  (il repose sur des mécanismes qui ne supportent pas la couche 3)

- En conséquence: vous *devez* indiquer le numéro de port pour votre service
    
- L'exécution de services avec un port arbitraire (ou des plages de ports) nécessite des hacks

  (par exemple, host networking mode)

---

## Test de notre service

- Nous allons maintenant envoyer quelques requêtes HTTP à nos pods ElasticSearch

.exercise[

- Obtenons l'adresse IP qui a été allouée pour notre service, *par programmation:*
  ```bash
  IP=$(kubectl get svc elastic -o go-template --template '{{.spec.clusterIP}}')
  ```

- Envoyez quelques demandes:
  ```bash
  curl http://$IP:9200/
  ```

]

--

Nous pouvons voir `curl: (7) Failed to connect to _IP_ port 9200: Connection refused`. C'est normal pendant que le service démarre.

--

Une fois qu'il est en cours d'exécution, nos demandes sont équilibrées en charge sur plusieurs pods.

---

class: extra-details

## Si nous n'avons pas besoin d'un équilibreur de charge

- Parfois, nous voulons accéder directement à nos services qui passent à l'échelle:

  - Si nous voulons sauver un petit peu de latence (typiquement moins de 1ms)

  - si nous devons nous connecter sur des ports arbitraires (au lieu de quelques uns fixes)

  - si nous avons besoin de communiquer sur un autre protocole que UDP ou TCP

  - si nous voulons décider comment équilibrer les demandes côté client

  - ...

- Dans ce cas, nous pouvons utiliser un "headless service"

---

class: extra-details

## Headless Services

- Un "headless service" est obtenu en définissant le champ `clusterIP` sur `None`

  (Soit avec `--cluster-ip = None`, soit en fournissant un YAML personnalisé)

- Par conséquent, le service n'a pas d'adresse IP virtuelle

- Comme il n'y a pas d'adresse IP virtuelle, il n'y a pas non plus d'équilibreur de charge

- `kube-dns` retournera les adresses IP des pods en plusieurs enregistrements `A`

- Cela nous donne un moyen facile de découvrir toutes les répliques pour un déploiement

---

class: extra-details

## Services et endpoints

- Un service a un certain nombre de "endpoints"

- Chaque endpoint est un hôte + port où le service est disponible

- Les endpoints sont maintenus et mis à jour automatiquement par Kubernetes

.exercise[

- Vérifiez les points de terminaison que Kubernetes a associés à notre service `elastic`:
  ```bash
  kubectl describe service elastic
  ```

]

Dans la sortie, il y aura une ligne commençant par `Endpoints:`.

Cette ligne listera un tas d'adresses au format `host:port`.

---

class: extra-details

## Affichage des détails du point de terminaison

- Lorsque nous avons beaucoup de endpoints, nos commandes d'affichage tronquent la liste
  ```bash
  kubectl get endpoints
  ```

- Si nous voulons voir la liste complète, nous pouvons utiliser l'une des commandes suivantes:
  ```bash
  kubectl describe endpoints elastic
  kubectl get endpoints elastic -o yaml
  ```

- Ces commandes vont nous montrer une liste d'adresses IP

- Ces adresses IP doivent correspondre aux adresses des pods correspondants:
  ```bash
  kubectl get pods -l run=elastic -o wide
  ```

---

class: extra-details

## "endpoints" pas "endpoint"

- `endpoints` est la seule ressource qui ne peut pas être singulière

```bash
$ kubectl get endpoint
error: the server doesn't have a resource type "endpoint"
```

- C'est parce que le type lui-même est pluriel (contrairement à toutes les autres ressources)

- Il n'y a pas d'objet `endpoint` object: `type Endpoints struct`

- Le type ne représente pas un seul endpoint, mais une liste de endpoints

---

## Reset

- Une fois que vous avez fini de jouer avec ce deployement:

```bash
kubectl delete deployments elastic
```
- Pour aller plus loin:
  - Le [concept](https://kubernetes.io/docs/concepts/services-networking/service/) des services de la doc officiel
  - [DNS pour les services](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)

