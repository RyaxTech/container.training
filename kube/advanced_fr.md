# Isolation et politiques de réseau

- Les Namespaces *ne fournissent pas* de l'isolation

- Un pod dans un namespace vert peut communiquer avec un pod dans le namespace bleu.

- Un pod dans le namespace `default` peut communiquer avec un pod dans le namespace `kube-system`.

- kube-dns utilise un sous-domaine différent pour chaque espace de nommage

- Exemple : à partir de n'importe quel pod du cluster, vous pouvez vous connecter à l'API Kubernetes avec :

  `https://kubernetes.default.svc.cluster.local:443/`

---

## Isolation de pods

- L'isolement réel est mis en œuvre avec des *politiques de réseau* (network policies).

- Les politiques réseau sont des ressources (comme les déploiements, les services, les namespaces....).

- Les politiques de réseau spécifient les flux autorisés :

  - entre les pods

  - du pod au monde extérieur

  - et vice-versa

---

## Network policies

- Nous pouvons créer autant de politiques de réseau que nous le voulons.

- Chaque politique de réseau a :

  - un *pod selector* : "Quelles sont les pods visées par la politique ?"

  - des listes de règles d'entrée (ingress) et/ou de sortie (egress) : "Quels pairs et ports sont autorisés ou bloqués ?"

- Si un pod n'est pas visé par une politique, le trafic est autorisé par défaut.

- Si un pod est visé par au moins une politique, le trafic doit être explicitement autorisé.

---

## Plus d'infos sur Network policies 

- Pour plus de détails, vérifiez :

  - la documentation de Kubernetes sur les politiques de réseau](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

  - ce [talk sur network policies fait au KubeCon 2017 US](https://www.youtube.com/watch?v=3gGpMmYeEO8) par [@ahmetb](https://twitter.com/ahmetb)

---

## Exercices sur les Network policies

.exercise[
- Pour exécuter quelques exercices sur les politiques de réseau, nous allons suivre quelques exemples ici : 
  https://github.com/ahmetb/kubernetes-network-policy-recipes
]

---

# Déploiement de Jupiter sur Kubernetes

.exercise[
- Nous suivrons la procédure fournie ici : 
  https://zonca.github.io/2017/12/scalable-jupyterhub-kubernetes-jetstream.html
]

---
--- 

# Scheduling avancée avec Kubernetes

.exercise[
- Nous suivrons la procédure fournie ici : 
   https://github.com/RyaxTech/kube-tutorial#4-activate-an-advanced-scheduling-policy-and-test-its-usage
]
---
---
# Autoscaling avec Kubernetes

.exercise[
- Nous suivrons la procédure fournie ici : 
  https://github.com/RyaxTech/kube-tutorial#6-enable-and-use-pod-autoscaling
]
---
---
# Big Data analytics sur Kubernetes

.exercise[
- Nous suivrons la procédure fournie ici :
https://github.com/RyaxTech/kube-tutorial#3-execute-big-data-job-with-spark-on-the-kubernetes-cluster
]


