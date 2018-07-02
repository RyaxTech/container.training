# Namespaces

- Nous ne pouvons pas avoir deux ressources avec le même nom

  (Ou pouvons-nous ...?)

--

- Nous ne pouvons pas avoir deux ressources *du même type* avec le même nom

  (Mais c'est bien d'avoir un service `rng`, un deploiement `rng`, et un daemon set `rng`!)

--

- Nous ne pouvons pas avoir deux ressources du même type avec le même nom *dans le même namespace*

  (Mais c'est OK d'avoir par exemple deux services `rng` dans différents namespaces!)

--

- En d'autres termes: **le tuple *(type, name, namespace)* doit être unique**

  (Dans la ressource YAML, le type s'appelle `Kind`)

---

## Namespaces préexistants

- Si nous déployons un cluster avec `kubeadm`, nous avons trois namespaces:

  - `default` (pour nos applications)

  - `kube-system` (pour le control plane)

  - `kube-public` (contient un secret utilisé pour la découverte du cluster)

- Si nous déployons différemment, nous pouvons avoir différents namespaces

---

## Création des namespaces

- Nous pouvons créer des namespaces avec un YAML très minime, par exemple:
  ```bash
    kubectl apply -f- <<EOF
    apiVersion: v1
    kind: Namespace
    metadata:
      name: blue
    EOF
  ```

- Si nous utilisons un outil comme Helm, il créera automatiquement des namespaces

---

## Utiliser les namespaces

- Nous pouvons passer un flag `-n` ou `--namespace` à la plupart des commandes `kubectl`:
  ```bash
  kubectl -n blue get svc
  ```

- Nous pouvons également utiliser *contexts*

- Un context est un tuple *(user, cluster, namespace)* 

- Nous pouvons manipuler les contexts avec la commande `kubectl config`

---

## Créer un context

- Nous allons créer un context pour le namespace `blue`

.exercise[

- Afficher les contexts existants pour voir le nom du cluster et l'utilisateur actuel:
  ```bash
  kubectl config get-contexts
  ```

- Créer un nouveau context:
  ```bash
  kubectl config set-context blue --namespace=blue \
      --cluster=kubernetes --user=kubernetes-admin
  ```

]

Nous avons créé un context; mais c'est juste quelques valeurs de configuration.

Le namespace n'existe pas encore.

---

## Utiliser un contexte

- Passons à notre nouveau context et déployons le graphique DockerCoins

.exercise[

- Utilisez le context `blue`:
  ```bash
  kubectl config use-context blue
  ```

- Déployer DockerCoins:
  ```bash
  helm install dockercoins
  ```

]

Dans la dernière ligne de commande, `dockercoins` est juste le chemin local où
nous avons créé notre Helm chart avant.

---

## Affichage de l'application déployée

- Voyons voir si notre carte Helm a fonctionné correctement!

.exercise[

- Récupérer le numéro de port attribué au service `webui`:
  ```bash
  kubectl get svc webui
  ```

- Pointez notre navigateur sur http://X.X.X.X:8080

]

Remarque: l'application peut prendre une minute ou deux pour être opérationnelle.

---

## Namespaces et isolation

- Les namespaces *ne fournissent pas* d'isolation

- Un pod dans le namespace `green` peut communiquer avec un pod dans le namespace `blue`

- Un pod dans le namespace `default` peut communiquer avec un pod dans le namespace `kube-system`

- `kube-dns` utilise un sous-domaine différent pour chaque namespace

- Exemple: depuis n'importe quel pod du cluster, vous pouvez vous connecter à l'API Kubernetes avec:

  `https://kubernetes.default.svc.cluster.local:443/`

---

## Isolation de Pods

- L'isolation réelle est implémentée avec les *network policies* (politiques de réseau)

- Les network policies sont des ressources (comme des deployments, services, namespaces ...)

- Les network policies spécifient les flux autorisés:

  - entre les pods

  - des pods au monde extérieur

  - et vice versa

---

## Présentation des network policies

- Nous pouvons créer autant de politiques de réseau *network policies* que nous voulons

- Chaque network policy a:

  - un *pod selector*: "quels pods sont ciblés par la politique?"

  - des listes de règles d'entrée (ingress) et/ou de sortie (egress): "quels peers et quels ports sont autorisés ou bloqués?"

- Si un pod n'est pas ciblé par aucune politique, le trafic est autorisé par défaut

- Si un pod est ciblé par au moins une politique, le trafic doit être autorisé explicitement

---

## En savoir plus sur les network policies

- Cela reste un aperçu de haut niveau des network policies

- Pour plus de détails regardez:

  - la [documentation de Kubernetes sur les network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

  - ceci [presentation de network policies chez KubeCon 2017 US](https://www.youtube.com/watch?v=3gGpMmYeEO8) par [@ahmetb](https://twitter.com/ahmetb)
