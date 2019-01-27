---

# Notre application sample

- Nous allons cloner le dépôt GitHub sur notre 1er noeud

- Le référentiel contient également des scripts et des outils que nous utiliserons à travers l'atelier

.exercise[

- Cloner le dépôt sur `node1`:
  ```bash
  git clone https://github.com/RyaxTech/kube.training 
  ```

]

(Vous pouvez également faire un fork du dépôt sur GitHub et cloner votre fork si vous préférez cela.)

---

## Téléchargement et exécution de l'application

Commençons la procedure, car le téléchargement prendra un peu de temps ...

.exercise[

- Allez dans le répertoire `dockercoins`, dans le repo clone:
  ```bash
  cd ~/kube.training/dockercoins
  ```

- Utilisez Compose pour générer et exécuter tous les conteneurs:
  ```bash
  docker-compose up
  ``` 
]

Compose dit à Docker de construire toutes les images du conteneur (en tirant
les images de base correspondantes), puis démarre tous les conteneurs,
et affiche les logs agrégés.

---

## Plus de détails sur notre exemple d'application

- Visitez le lien GitHub avec tous les matériaux de cet atelier:
  <br/> https://github.com/RyaxTech/kube.training

- L'application est dans le sous-répertoire [dockercoins](https://github.com/RyaxTech/kube.training/tree/master/dockercoins)

- Regardons la disposition générale du code source:

  il y a un fichier Compose [docker-compose.yml](https://github.com/RyaxTech/kube.training/blob/master/dockercoins/docker-compose.yml) ...

  ... et 4 autres services, chacun dans son propre répertoire:

  - `rng` = service web générant des octets aléatoires
  - `hasher` = hachage informatique du service Web des données POSTed
  - `worker` = processus de fond utilisant `rng` et `hasher`
  - `webui` = interface web pour suivre les progrès

---

## Découverte de service dans le terrain de conteneurs

- Nous ne codons pas les adresses IP dans le code

- Nous ne codons pas le nom de domaine complet dans le code, soit

- Nous nous connectons simplement à un nom de service, et la magie des conteneurs fait le reste

  (Et par magie des conteneurs, nous entendons "un serveur DNS dynamique et embarqué")

---

## Exemple dans `worker/worker.py`

```python
redis = Redis("`redis`")


def get_random_bytes():
    r = requests.get ("http://`rng`/32")
    return r.content


def hash_bytes(data):
    r = requests.post("http://`hasher`/",
                      data = data,
                      headers = {"Content-Type": "application/octet-stream"})
```

(Code source complet disponible [ici](
https://github.com/RyaxTech/kube.training/blob/8279a3bce9398f7c1a53bdd95187c53eda4e6435/dockercoins/worker/worker.py#L17
))

---

class: extra-details

## Liens, dénomination et découverte de service

- Les conteneurs peuvent avoir des alias réseau (résolvables via DNS)

- Compose le fichier version 2+ rend chaque conteneur accessible via son nom de service

- Compose la version 1 du fichier a nécessité des sections "liens"

- Les alias réseau sont automatiquement "namespaced"

  - vous pouvez avoir plusieurs applications déclarant et utilisant un service nommé `database`

  - les conteneurs dans l'application bleue vont résoudre `database` à l'adresse IP de la base de données bleue

  - les conteneurs dans l'application verte vont résoudre `base de données` à l'adresse IP de la base de données verte

---

## Qu'est-ce qu'elle fait cette application?

--

- C'est un mineur de DockerCoin! .emoji[💰🐳📦🚢]

--

- Non, vous ne pouvez pas acheter de café avec DockerCoins

--

- Comment fonctionne DockerCoins:

  - `worker` demande à `rng` de générer quelques octets aléatoires

  - `worker` nourrit ces octets en `hasher`

  - et répète pour toujours!

  - chaque seconde, `worker` met à jour `redis` pour indiquer combien de boucles ont été faites

  - `webui` interroge `redis`, et calcule et expose la "vitesse de hachage" dans votre navigateur

---

## Notre application au travail

- Sur le côté gauche, la "rainbow strip" montre les noms des conteneurs

- Sur le côté droit, nous voyons la sortie de nos conteneurs

- Nous pouvons voir le service `worker` faire des requêtes à `rng` et `hasher`

- Pour `rng` et `hasher`, nous voyons les logs d'accès HTTP

---

## Connexion à l'interface Web

- Le conteneur `webui` expose un dashboard Web; Voyons voir

.exercise[

- Avec un navigateur Web, connectez-vous à `node1` sur le port 8000

- Rappel: les alias `nodeX` ne sont valables que sur les nœuds eux-mêmes

- Dans votre navigateur, vous devez entrer l'adresse IP de votre noeud

]

Une zone de dessin devrait apparaître, et après quelques secondes, un graphique bleu apparaîtra.

---

class: extra-details

## Pourquoi la vitesse semble-t-elle irrégulière?

- On *dirait que* la vitesse est d'environ 4 hashes/seconde

- Ou plus précisément: 4 hashes/seconde, avec des creux réguliers jusqu'à zéro

- Pourquoi?

--

class: extra-details

- L'application a en fait une vitesse constante et constante: 3,33 hachages / seconde
  <br/>
  (ce qui correspond à 1 hash toutes les 0.3 secondes)

- Oui et?

---

class: extra-details

## La raison pour laquelle ce graphique n'est *pas génial*

- Le "worker" ne met pas à jour le compteur après chaque boucle, mais jusqu'à une fois par seconde

- La vitesse est calculée par le navigateur, vérifiant le compteur environ une fois par seconde

- Entre deux mises à jour consécutives, le compteur augmentera de 4 ou de 0

- La vitesse perçue sera donc 4 - 4 - 4 - 0 - 4 - 4 - 0 etc.

---

## Arrêt de l'application

- Si nous interrompons Compose (avec `^C`), il demandera poliment au Docker Engine d'arrêter l'application

- Le moteur Docker enverra un signal `TERM` aux conteneurs

- Si les conteneurs ne sortent pas en temps voulu, le moteur envoie un signal "KILL"

.exercise[

- Arrêtez l'application en tapant `^C`

]

-

Certains conteneurs sortent immédiatement, d'autres prennent plus de temps.

Les conteneurs qui ne gèrent pas `SIGTERM` finissent par être détruits après un délai de 10s. Si nous sommes très impatients, nous pouvons frapper `^C` une seconde fois!
