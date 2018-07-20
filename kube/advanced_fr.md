# Autoscaling avec Kubernetes

Nous allons mettre en place un système d'autoscaling basé sur k8s-prom-hpa. Ce logicil à l'avantage d'être simple, fonctionel et extensible grâce à Prometheus.

.exercise[
- Récupérez le logiciel:

  ```bash
git clone https://github.com/stefanprodan/k8s-prom-hpa.git
cd k8s-prom-hpa/
  ```

]

---

## Récupérez les métriques

Déployons le *Metrics Server*, le server qui va récupérez les métriques sur les noeuds et les transmettre en utilisant l'API standard de kubernetes:

.exercise[
  ```bash
kubectl create -f ./metrics-server
  ```
]

(Avant k8s 1.8, Heapster permettait de faire cela. Ce projet a été fusionner avec Kubernetes pour faire *Metrics Server*.)

---

## HorizontalPodAutoscaler CRD

.exercise[
La prochaine commande définit un nouveau type d'objet (un Custorm Resource Definition (CRD)), et lance le controlleur de ce CRD.

On peut donc maintenant intéragir avec le type HorizontalPodAutoscaler comme tout les autres objets de kubernetes:

  ```bash
kubectl get hpa
  ```

]

---

## Déploiement d'une application

.exercise[
On deploie maintenant une application affichant sur une interface web des informations décrivant son pod:

  ```bash
kubectl create -f ./podinfo/podinfo-svc.yaml,./podinfo/podinfo-dep.yaml
  ```

Vous pouvez regarder ce que ces infos sont:
  ```bash
curl IP_PUBLIC:PORT_DU_SERVICE
  ```
]

---

## Mise en place des règles d'auto-scaling

.exercise[
On va maintenant créer les règles HorizontalPodAutoscaler:

  ```bash
kubectl create -f ./podinfo/podinfo-hpa.yaml
  ```

Regardez ce yaml pour voir ce que définissent ces règles !

On a donc maintenant une nouvelle hpa:
  ```bash
kubectl get hpa
  ```
]

---

## Stress de l'application

.exercise[
On va maintenant strésser le service pour que le scaling ce lance, dans un nouveau terminal :
  ```bash
cd ~/
mkdir golang
export GOPATH=~/golang/
export GOROOT=/usr/lib/go-1.10
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
go get -u github.com/rakyll/hey
hey -n 10000 -q 10 -c 5 http://IP_PUBLIC:PORT_DU_SERVICE/
  ```

]
---

## Stress de l'application 2

.exercise[

Observez ce qui se passe pour le hpa:
  ```bash
kubectl describe hpa
  ```

]

L'autoscaler ne réagit pas immédiatement au pics d'utilisation.
Par défaut, les métriques sont synchronisées toutes les 30s.
De plus, le scaling up/down peut seulement avoir lieu si il n'y pas déjà eu un scaling dans les 5 minutes.
Cela permet au HPA de prendre des décisions trop rapides et/ou contradictoires.

---

## En savoir plus

- The procedure is explained in detail and with more examples here: https://www.weave.works/blog/kubernetes-horizontal-pod-autoscaler-and-prometheus

- Pour reset:
  ```bash
kubectl delete -f ./podinfo/podinfo-hpa.yaml
kubectl delete -f ./podinfo/podinfo-svc.yaml,./podinfo/podinfo-dep.yaml
kubectl delete -f ./metrics-server
  ```








---
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

# Big Data analytics sur Kubernetes

.exercise[
- Nous suivrons la procédure fournie ici :
https://github.com/RyaxTech/kube-tutorial#3-execute-big-data-job-with-spark-on-the-kubernetes-cluster
]


