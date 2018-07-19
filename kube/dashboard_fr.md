# Le dashboard de Kubernetes

- Les ressources de Kubernetes peuvent également être visualisées avec un dashboard web

- Nous allons déployer ce dashboard avec *trois commandes:*

  1) plutot *exécuter* le dashboard

  2) contourner SSL pour le dashboard

  3) Ignorer l'authentification pour le dashboard

--

Il y a une étape supplémentaire pour rendre le dashboard disponible de l'extérieur (nous y reviendrons)

--

.footnote[.warning[Oui, cela ouvrira notre cluster à toutes sortes de manigances. Ne fais pas ça à la maison.]]

---

## 1) Exécution du dashboard

- Nous devons créer un * déploiement * et un * service * pour le dashboard

- Mais aussi un * secret *, un * compte de service *, un * rôle * et un * rôle contraignant *

- Toutes ces choses peuvent être définies dans un fichier YAML et créées avec `kubectl apply -f`

.exercise[

- Créer toutes les ressources du dashboard, avec la commande suivante:
  ```bash
  kubectl apply -f https://goo.gl/Qamqab
  ```

]

L'URL de goo.gl se développe pour:
<br/>
.small[https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml]

---


## 2) Contournement SSL pour le dashboard

- Le dashboard Kubernetes utilise HTTPS, mais nous n'avons pas de certificat

- Les versions récentes de Chrome (63 et versions ultérieures) et Edge refusent de se connecter

  (Vous n'aurez même pas l'option d'ignorer un avertissement de sécurité!)

- Nous pourrions (et devrions!) Obtenir un certificat, par ex. avec [Let's Encrypt](https://letsencrypt.org/)

- ... Mais pour plus de commodité, pour cet atelier, nous transmettrons HTTP à HTTPS

.warning[Ne le faites pas à la maison, ou pire, au travail!]

---

## Exécution du déballeur SSL

- Nous allons lancer [`socat`](http://www.dest-unreach.org/socat/doc/socat.html), en lui disant d'accepter les connexions TCP et de les relayer via SSL

- Ensuite, nous allons exposer cette instance `socat` avec un service `NodePort`

- Pour plus de commodité, ces étapes sont soigneusement encapsulées dans un autre fichier YAML

.exercise[

- Appliquez le fichier YAML pratique et annulez la protection SSL:
  ```bash
  kubectl apply -f https://goo.gl/tA7GLz
  ```

]

L'URL goo.gl se développe pour:
<br/>
.small[.small[https://gist.githubusercontent.com/jpetazzo/c53a28b5b7fdae88bc3c5f0945552c04/raw/da13ef1bdd38cc0e90b7a4074be8d6a0215e1a65/socat.yaml]]

.warning[Tout notre trafic de dashboard est maintenant en texte clair, y compris les mots de passe!]

---

## Connexion au dashboard

.exercise[

- Vérifiez quel port est le dashboard:
  ```bash
  kubectl -n kube-system get svc socat
  ```

]

Vous aurez besoin du port `8080`.


.exercise[

- Connectez-vous à http://oneofournodes:3xxxx/

]

Le dashboard vous demandera ensuite l'authentification que vous souhaitez utiliser.

---

## Authentification de dashboard

- Nous avons trois options d'authentification à ce stade:

  - token (associé à un role disposant des autorisations appropriées)

  - kubeconfig (par exemple en utilisant le fichier `~/.kube/config` de `node1`)

  - "skip" (utilisez le dashboard "service account")

- Utilisons "skip": nous recevons un tas d'avertissements et ne voyons pas grand-chose

---

## 3) Ignorer l'authentification pour le dashboard

- La documentation du dashboard [explique comment procéder](https://github.com/kubernetes/dashboard/wiki/Access-control#admin-privileges)

- Nous avons juste besoin de charger un autre fichier YAML!

.exercise[

- Accorder des privilèges d'administrateur au dashboard afin que nous puissions voir nos ressources:
  ```bash
  kubectl apply -f https://goo.gl/CHsLTA
  ```

- Rechargez le dashboard et profitez-en!

]

--

.warning[Au fait, nous venons d'ajouter une porte dérobée à notre cluster Kubernetes!]

---

## Exposer le dashboard sur HTTPS

- Nous avons pris un raccourci en transférant HTTP à HTTPS dans le cluster

- Exposons le dashboard sur HTTPS!

- Le dashboard est exposé via un service `ClusterIP` (trafic interne uniquement)

- Nous allons changer cela en un service `NodePort` (acceptant le trafic extérieur)

.exercise[

- Modifier le service:
  ```bash
  kubectl edit service kubernetes-dashboard
  ```

]

--

`NotFound`?!? Pourquoi ca ne marche pas?!?

---

## Modification du service `kubernetes-dashboard`

- Si nous regardons le [YAML](https://goo.gl/Qamqab) que nous avons chargé avant, nous aurons un indice

--

- Le dashboard a été créé dans le namespace `kube-system`

--

.exercise[

- Modifier le service:
  ```bash
  kubectl -n kube-system edit service kubernetes-dashboard
  ```

- Changez `type: ClusterIP` en `type: NodePort`, sauvegardez et quittez

- Vérifiez le port qui a été assigné avec `kubectl -n kube-system get services`

- Connectez-vous à https://oneofournodes:3xxxx/ (oui, https)

]

---

## Exécution sécurisée du dashboard Kubernetes

- Les étapes que nous venons de vous montrer sont *avec des buts éducatives seulement!*

- Si vous faites cela sur votre cluster de production, les gens [peuvent et vont en abuser](https://blog.redlock.io/cryptojacking-tesla)

- Pour une discussion approfondie sur la sécurisation du dashboard,
  <br/>
  vérifier [cet excellent post sur le blog de Heptio](https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca)

---

# Les implications de sécurité de `kubectl apply`

- Quand nous faisons `kubectl apply -f <URL>`, nous créons des ressources arbitraires

- Les ressources peuvent être mauvaises; Imaginez un `deployment` ...

--

   - démarre des mineurs bitcoin sur l'ensemble du cluster

--

   - cache dans un espace de noms autre que le "default"

--

   - bind-mounts le système de fichiers de nos nœuds

--

   - insère les clés SSH dans le compte root (sur le noeud)

--

   - crypte nos données et les garde en rancon

--

   - ☠️☠️☠️

---

## `kubectl apply` est le nouveau `curl | sh`

- `curl | sh` est pratique

- Il est sûr si vous utilisez des URL HTTPS provenant de sources fiables

--

- `kubectl apply -f` est pratique

- Il est sûr si vous utilisez des URL HTTPS provenant de sources fiables

- Exemple: les instructions d'installation officielles pour la plupart des réseaux de pod

--

- Il introduit de nouveaux modes de défaillance (comme si vous essayez d'appliquer yaml à partir d'un lien qui n'est plus valide)


---

## Pour aller plus loin


.exercise[
- Relancez l'exemple préçédent
  ```bash
  kubectl run pingpong --image alpine ping 1.1.1.1
  ```
- Observez le deployment et son pod. Trouvez-vous les logs du pod?

- Arrétez le deployment.

]

Vous pouvez stopper le dashboard ou le laisser. Comme le dashboard n'est pas sécurisé, nous conseillons de l'arréter.
```bash
  kubectl delete -f https://goo.gl/CHsLTA
  ```


