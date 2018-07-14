class: title

Notre application sur Kubernetes

---

## Qu'est-ce qu'il y'a au menu?

Dans cette partie, nous allons:

- **construire** des images pour notre application,

- **expédier** ces images avec un registre,

- **déployer** des déploiements utilisant ces images,

- exposer ces déploiements pour qu'ils puissent communiquer entre eux,

- exposer l'interface web afin que nous puissions y accéder de l'extérieur.

---

## Le plan

- Construction sur notre noeud de contrôle (`node1`)

- Marquage des images pour qu'elles soient nommées `$REGISTRY/servicename`

- Téléchargement sur un registre

- Creation des déploiements en utilisant les images

- Exposition (avec un ClusterIP) des services qui ont besoin de communiquer

- Exposition (avec un NodePort) de l'interface Web

---

## Quel registre voulons-nous utiliser?

- Nous pourrions utiliser le Docker Hub

- Ou un service offert par notre fournisseur de cloud (ACR, GCR, ECR ...)

- Ou nous pourrions simplement auto-héberger ce registre

*Nous hébergerons automatiquement le registre car c'est la solution la plus générique pour cet atelier.*

---

## Utiliser le registre open source

- Nous devons lancer un conteneur `registry:2`
  <br/>(assurez-vous de spécifier la balise `:2` pour exécuter la nouvelle version!)

- Il va stocker des images et des couches dans le système de fichiers local
  <br/>(mais vous pouvez ajouter un fichier de configuration pour utiliser S3, Swift, etc.)

- Docker *nécessite* TLS lors de la communication avec le registre

  - sauf pour les registres sur «127.0.0.0/8» (c'est-à-dire `localhost`)

  - ou avec le flag Engine `--insecure-registry`

- Notre stratégie: publier le conteneur de registre sur un NodePort,
  <br/> pour qu'il soit disponible via `127.0.0.1:xxxxx` sur chaque noeud

---

# Déployer un registre auto-hébergé

- Nous allons déployer un conteneur de registre et l'exposer avec un NodePort

.exercise[

- Créez le service de registre:
  ```bash
  kubectl run registry --image=registry:2
  ```

- Exposez-le sur un NodePort:
  ```bash
  kubectl expose deploy/registry --port=5000 --type=NodePort
  ```

]

---

## Connexion à notre registre

- Nous devons trouver quel port a été attribué

.exercise[

- Voir les détails du service:
  ```bash
  kubectl describe svc/registry
  ```

- Obtenez le numéro de port par programme:
  ```bash
  NODEPORT=$(kubectl get svc/registry -o json | jq .spec.ports[0].nodePort)
  REGISTRY=127.0.0.1:$NODEPORT
  ```

]

---

## Test de notre registre

- Une route API de registre Docker pratique à retenir est `/v2/_catalog`

.exercise[

- Voir les dépôts actuellement détenus dans notre registre:
  ```bash
  curl $REGISTRY/v2/_catalog
  ```

]

--

Nous devrions voir:
```json
{"repositories": []}
```

---

## Test de notre registre local

- Nous pouvons retagger une petite image, et la pousser vers le registre

.exercise[

- Assurez-vous que nous avons l'image busybox, et retaggez la:
  ```bash
  docker pull busybox
  docker tag busybox $REGISTRY/busybox
  ```

- Poussez-le:
  ```bash
  docker push $REGISTRY/busybox
  ```

]

---

## Vérifier à nouveau ce qu'il y a dans notre registre local

- Utilisons le même point final que précédemment

.exercise[

- Assurez-vous que notre image busybox est maintenant dans le registre local:
  ```bash
  curl $ REGISTRY / v2 / _catalog
  ```

]

La commande curl devrait maintenant sortir:
```json
{"repositories": ["busybox"]}
```

---

## Construire et pousser nos images

- Nous allons utiliser une fonctionnalité pratique de Docker Compose

.exercise[

- Allez dans le répertoire `stacks`:
  ```bash
  cd ~/container.training/stacks
  ```

- Construire et pousser les images:
  ```bash
  export REGISTRY
  export TAG=v0.1
  docker-compose -f dockercoins.yml build
  docker-compose -f dockercoins.yml push
  ```

]

Jetons un coup d'œil au fichier `dockercoins.yml` pendant que ce dernier construit et pousse.

---

```yaml
version: "3"

services:
  rng:
    build: dockercoins/rng
    image: ${REGISTRY-127.0.0.1:5000}/rng:${TAG-latest}
    deploy:
      mode: global
  ...
  redis:
    image: redis
  ...
  worker:
    build: dockercoins/worker
    image: ${REGISTRY-127.0.0.1:5000}/worker:${TAG-latest}
    ...
    deploy:
      replicas: 10
```

.warning[Juste au cas où vous vous poseriez la question ... Les "services" de Docker ne sont pas des "services" de Kubernetes.]

---

class: extra-details

## Éviter le tag `latest`

.warning[Assurez-vous d'avoir bien défini la variable `TAG`!]

- Si vous ne le faites pas, le tag sera par défaut `latest`

- Le problème avec `latest`: personne ne sait à quoi ça veut dire!

  - Le dernier commit dans le repo?

  - Le dernier commit dans une branche? (Laquelle?)

  - Le dernier tag?

  - Une version aléatoire poussée par un membre de l'équipe aléatoire?

- Si vous continuez à appuyer sur la balise `latest`, comment faire de rollback?

- Les tags de "Images" doivent être significatives, c'est-à-dire correspondre à des branches, tags, ou hashes

---

## Déploiement de toutes les choses

- Nous pouvons maintenant déployer notre code (ainsi qu'une instance redis)

.exercise[

- Déployer `redis`:
  ```bash
  kubectl run redis --image=redis
  ```

- Déployer tout le reste:
  ```bash
   for SERVICE in hasher rng webui worker; do
      kubectl run $SERVICE --image=$REGISTRY/$SERVICE:$TAG
    done
  ```

]

---

## Est-ce que ça marche?

- Après avoir attendu la fin du déploiement, regardons les logs!

  (Indice: utilisez `kubectl get deploy -w` pour regarder les événements de déploiement)

.exercise[

- Regardez quelques logs:
  ```bash
  kubectl logs deploy/rng
  kubectl logs deploy/worker
  ```

]

--

🤔 `rng` va bien ... Mais pas `worker`.

--

💡 Oh, c'est vrai! Nous avons oublié de "exposer".

---

# Exposant des services en interne

- Trois déploiements doivent être accessibles par d'autres: `hasher`,` redis`, `rng`

- `worker` n'a pas besoin d'être exposé

- `webui` sera traité plus tard

.exercise[

- Exposez chaque déploiement, en spécifiant le bon port:
  ```bash
  kubectl expose deployment redis --port 6379
  kubectl expose deployment rng --port 80
  kubectl expose deployment hasher --port 80
  ```

]

---

## Est-ce que ça marche encore?

- Le `worker` a une boucle infinie, qui réessaie 10 secondes après une erreur

.exercise[

- Diffuser les logs du worker:
  ```bash
  kubectl logs deploy/worker --follow
  ```

  (Donnez-lui environ 10 secondes pour récupérer)

]

--

Nous devrions maintenant voir le «travailleur», bien, travaillant heureusement.

---

# Exposant des services pour un accès externe

- Maintenant, nous aimerions accéder à l'interface Web

- Nous l'exposerons avec un `NodePort`

  (Juste comme nous l'avons fait pour le registre)

.exercise[

- Créez un service `NodePort` pour l'interface Web:
  ```bash
  kubectl expose deploy/webui --type=NodePort --port=8080
  ```

- Vérifiez le port qui a été alloué:
  ```bash
  kubectl obtenir svc
  ```

]

---

## Accès à l'interface utilisateur Web

- Nous pouvons maintenant nous connecter à *n'importe quel noeud*, sur le port de noeud alloué, pour voir l'interface web

.exercise[

- Ouvrez l'interface web dans votre navigateur (http://node-ip-address:3xxxx/)
]

--

*D'accord, nous sommes de retour là où nous avons commencé, quand nous utilisions un seul nœud!*


