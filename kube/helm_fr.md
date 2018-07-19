# Gestion des stacks avec Helm

- Nous avons créé nos premières ressources avec `kubectl run`,` kubectl expose` ...

- Nous avons également créé des ressources en chargeant les fichiers YAML avec `kubectl apply -f`

- Pour les plus grosses stacks, gérer des milliers de lignes de YAML est déraisonnable

- Ces bundles YAML doivent être personnalisés avec des paramètres variables

  (Par exemple: nombre de replicas, version de l'image à utiliser ...)

- Ce serait bien d'avoir une collection de bundles (paquets) organisée et versionnée

- Ce serait bien de pouvoir upgrade/rollback ces bundles avec soin

- [Helm](https://helm.sh/) est un projet open source offrant toutes ces choses!

---

## Concepts de Helm

- `helm` est un outil CLI

- `tiller` est son composant côté serveur

- Un "chart" est une archive contenant des paquets YAML modélisés

- Les charts sont versionnés

- Les charts peuvent être stockés sur des repositories privés ou publics

---

## Installation de Helm

- Nous devons installer la CLI `helm`; puis utilisez-le pour déployer  `tiller`

.exercise[

- Installez la CLI `helm`:
  ```bash
  curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
  chmod 700 get_helm.sh
  ./get_helm.sh
  ```

- Déployer `tiller`:
  ```bash
  helm init
  ```

- Ajouter l'auto-complétion `helm`:
  ```bash
  . <(helm completion $(basename $SHELL))
  ```

]

---

## Réparer les "account permissions"

- Le modèle d'autorisation Helm nous oblige à modifier les autorisations (permissions)

- Dans un déploiement plus réaliste, vous pouvez créer par utilisateur ou par équipe
  comptes de service (service accounts), roles, et liaisons de rôles (role bindings)

.exercise[

- Accorder le rôle `cluster-admin` au compte de service `kube-system: default`:
  ```bash
    kubectl create clusterrolebinding add-on-cluster-admin \
      --clusterrole=cluster-admin --serviceaccount=kube-system:default
  ```

]

(Définir les rôles et les autorisations exacts sur votre cluster nécessite
une connaissance plus approfondie du modèle RBAC de Kubernetes. La commande ci-dessus est
adaptée pour les clusters personnels et de développement.)

---

## Voir les charts disponibles

- Un dépôt public est préconfiguré lors de l'installation de Helm

- Nous pouvons voir les charts disponibles avec `helm search` (et un mot-clé optionnel)

.exercise[

- Voir tous les charts disponibles:
  ```bash
  helm search
  ```

- Voir les charts liés à `prometheus`:
  ```bash
  helm search prometheus
  ```

]

---

## Installation d'un chart

- La plupart des charts utilisent les types de service `LoadBalancer` par défaut

- La plupart des charts nécessitent des volumes persistants pour stocker les données

- Nous devons détendre ces exigences un peu

.exercise[

- Installez le collecteur de mesures Prometheus sur notre cluster:
  ```bash
    helm install stable/prometheus \
         --set server.service.type=NodePort \
         --set server.persistentVolume.enabled=false
  ```

]

D'où viennent ces options `--set`?

---

## Inspection d'un chart

- `helm inspect` montre des détails sur un chart (y compris les options disponibles)

.exercise[

- Voir les métadonnées et toutes les options disponibles pour `stable/prometheus`:
  ```bash
  helm inspect stable/prometheus
  ```

]

Les métadonnées du chart incluent une URL vers la page d'accueil du projet.

(Parfois, il pointe simplement vers la documentation du chart.)

---

## Création d'un chart

- Nous allons montrer un moyen de créer un chart *très simplifié*

- Dans un vrai chart, *beaucoup de choses* seraient templacées

  (Noms de ressources, types de services, nombre de replicas ...)

.exercise[

- Créer un exemple de chart:
  ```bash
  helm create dockercoins
  ```

- Éloignez les exemples de templates et créez un répertoire de template vide:
  ```bash
  mv dockercoins/templates dockercoins/default-templates
  mkdir dockercoins/templates
  ```

]

---

## Exportation du YAML pour notre application

- La section suivante suppose que DockerCoins est en cours d'exécution

.exercise[

- Créez un fichier YAML pour chaque ressource dont nous avons besoin:
  .small[
  ```bash

    while read kind name; do
      kubectl get -o yaml --export $kind $name > dockercoins/templates/$name-$kind.yaml
    done <<EOF
    deployment worker
    deployment hasher
    daemonset rng
    deployment webui
    deployment redis
    service hasher
    service rng
    service webui
    service redis
    EOF
  ```
  ]

]

---

## Test de notre chart

.exercise[

- Installons notre helm chart! (`dockercoins` est le chemin vers le chart)
  ```bash
  helm install dockercoins
  ```
]

-

- Puisque l'application est déjà déployée, cela échouera: <br>
`Error: release loitering-otter failed: services "hasher" already exists`

- Pour éviter les conflits de noms, nous allons déployer l'application dans un autre *namespace*


---

## Pour aller plus loin

- Le [quickstart](https://docs.helm.sh/using_helm/#quickstart) de helm.

- Le dépot public de [charts helm](https://hub.kubeapps.com/)