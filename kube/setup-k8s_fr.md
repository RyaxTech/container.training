# Installation de Kubernetes

- Comment avons-nous mis en place ces clusters Kubernetes que nous utilisons?

--

- Nous avons utilisé `kubeadm` sur des instances VM fraîchement installées exécutant Ubuntu 16.04 LTS

    1. Installez Docker

    2. Installer les paquets Kubernetes

    3. Exécutez `kubeadm init` sur le noeud maître

    4. Configurer Weave (le réseau de superposition)
       <br/>
       (cette étape est juste une commande "kubectl apply", discutée plus tard)

    5. Exécutez `kubeadm join` sur les autres noeuds (avec le token produit par` kubeadm init`)

    6. Copiez le fichier de configuration généré par `kubeadm init`

- Vérifiez le [prepare VMs README](https://github.com/jpetazzo/container.training/blob/master/prepare-vms/README.md) pour plus de détails

---

## "kubeadm" inconvénients

- Ne configure pas Docker ou tout autre moteur de conteneur

- Ne configure pas le réseau d'overlay

- Ne configure pas multi-master (pas de haute disponibilité)

--

  (Au moins pas encore!)

--

- "Il reste deux fois plus d'étapes que la mise en place d'un cluster Docker Swarm" 

---

## Autres options de déploiement

- Si vous êtes sur Azure:
  [AKS](https://azure.microsoft.com/services/container-service/)

- Si vous êtes sur Google Cloud:
  [GKE](https://cloud.google.com/kubernetes-engine/)

- Si vous êtes sur AWS:
  [EKS](https://aws.amazon.com/eks/)
  ou
  [kops](https://github.com/kubernetes/kops)

- Sur une machine locale:
  [minikube](https://kubernetes.io/docs/getting-started-guides/minikube/),
  [kubespawn](https://github.com/kinvolk/kube-spawn),
  [Docker4Mac](https://docs.docker.com/docker-for-mac/kubernetes/)

- Si vous voulez quelque chose de personnalisable:
  [kubicorn](https://github.com/kubicorn/kubicorn)

  Probablement le plus proche d'une solution multi-cloud / hybride jusqu'à présent, mais en développement

---

## Encore plus d'options de déploiement

- Si vous aimez Ansible:
  [kubespray](https://github.com/kubernetes-incubator/kubespray)

- Si vous aimez Terraform:
  [typhon](https://github.com/poseidon/typhoon/)

- Vous pouvez également apprendre à installer chaque composant manuellement, avec
  l'excellent tutoriel [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

  *Kubernetes The Hard Way est optimisé pour l'apprentissage, ce qui signifie prendre le long chemin pour s'assurer que vous comprenez chaque tâche requise pour démarrer un cluster Kubernetes.*

- Il y a aussi beaucoup d'options commerciales disponibles!

- Pour une liste plus longue, consultez la documentation de Kubernetes:
  <br/>
  il a un excellent guide pour [choisir la bonne solution](https://kubernetes.io/docs/setup/pick-right-solution/) pour configurer Kubernetes.
