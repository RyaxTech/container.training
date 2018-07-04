# Logs centralisée

- L'utilisation de `kubectl` ou` stern` est simple; mais il a des inconvénients:

  - quand un nœud tombe en panne, ses logs ne sont plus disponibles

  - nous ne pouvons que vider ou diffuser des logs; nous voulons rechercher / indexer / compter ...

- Nous voulons envoyer tous nos logs à un seul endroit

- Nous voulons les analyser (par exemple pour les logs HTTP) et les indexer

- Nous voulons un bon dashboard web

--

- Nous allons déployer une stack EFK

---

## Qu'est-ce que EFK?

- EFK est trois composants:

  - ElasticSearch (pour stocker et indexer les entrées de log)

  - Fluentd (pour obtenir les logs de conteneur, les traiter et les placer dans ElasticSearch)

  - Kibana (pour voir/rechercher les entrées de log avec une belle interface)

- Le seul composant auquel nous devons accéder depuis l'extérieur du cluster sera Kibana

---

## Déploiement de EFK sur notre cluster

- Nous allons utiliser un fichier YAML décrivant toutes les ressources nécessaires

.exercise[

- Chargez le fichier YAML dans notre cluster:
  ```bash
  kubectl apply -f https://goo.gl/MUZhE4
  ```


]

Si nous [regardons le fichier YAML](https://goo.gl/MUZhE4), nous voyons que
il crée 1 daemon set, 2 deployments, 2 services,
et quelques roles et roles bindings (pour donner à fluentd les permissions requises).

---

## L'itinéraire d'une ligne de log (avant Fluentd)

- Un conteneur écrit une ligne sur stdout ou stderr

- Les deux sont généralement redirigés vers le moteur du conteneur (Docker ou autre)

- Le moteur de conteneur lit la ligne et l'envoie à un pilote de logs

- Le timestamp et le flux (stdout ou stderr) sont ajoutés à la ligne du log

- Avec la configuration par défaut pour Kubernetes, la ligne est écrite dans un fichier JSON

  (`/var/log/containers/pod-name_namespace_container-id.log`)  

- Ce fichier est lu lorsque nous invoquons `kubectl logs`; nous pouvons y accéder directement aussi

---

## L'itinéraire d'une ligne de log (avec Fluentd)

- Fluentd s'exécute sur chaque noeud (grâce à un daemon set)

- Il bind-mount `/var/log/containers` de l'hôte (pour accéder à ces fichiers)

- Il scanne en permanence ce répertoire pour les nouveaux fichiers; les lit; les analyse

- Chaque ligne de log devient un objet JSON, entièrement annoté avec des informations supplémentaires:
  <br/> container id, pod name, Kubernetes labels ...

- Ces objets JSON sont stockés dans ElasticSearch

- ElasticSearch indexe les objets JSON

- Nous pouvons accéder aux logs via Kibana (et effectuer des recherches, des comptes, etc.)

---

## Accès à Kibana

- Kibana offre une interface web relativement simple

- Regardons ça!

.exercise[

- Vérifiez quel `NodePort` a été alloué à Kibana:
  ```bash
  kubectl get svc kibana
  ```

- Avec notre navigateur Web, connectez-vous à Kibana

]

---

## Utiliser Kibana

* Remarque: ce n'est pas un atelier Kibana! Donc cette section est délibérément très laconique. *

- La première fois que vous vous connectez à Kibana, vous devez "configure an index pattern"

- Il suffit d'utiliser celui qui est suggéré, `@timestamp`

- Puis cliquez sur "Discover" (dans le coin supérieur gauche)

- Vous devriez voir les logs de conteneurs

- Conseil: dans la colonne de gauche, sélectionnez quelques champs à afficher, par exemple:

  `kubernetes.host`,` kubernetes.pod_name`, `stream`,` log`

---

## Caveat emptor

Nous utilisons EFK parce que c'est relativement simple
déployer sur Kubernetes, sans devoir redéployer ou reconfigurer
notre cluster. Mais cela ne signifie pas que ce sera toujours le meilleur
option pour votre cas d'utilisation. Si vous utilisez Kubernetes dans le
cloud, vous pouvez envisager d'utiliser la journalisation du fournisseur de cloud
infrastructure (si elle peut être intégrée avec Kubernetes).

La méthode de déploiement que nous allons utiliser ici a été simplifiée:
il n'y a qu'un seul noeud ElasticSearch. Dans un vrai déploiement, vous
pourrait utiliser un cluster, à la fois pour des raisons de performance et de fiabilité.
Mais ceci sort du cadre de ce chapitre.

Le fichier YAML que nous avons utilisé crée toutes les ressources dans le
espace de noms `default`, pour plus de simplicité. Dans un scénario réel, vous allez
créez les ressources dans l'espace de noms `kube-system` ou dans un espace de noms dédié.
