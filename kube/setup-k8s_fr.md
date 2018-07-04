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

- Vérifiez le [prepare VMs README](https://github.com/RyaxTech/kube.training/blob/master/prepare-vms/README.md) pour plus de détails

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

---

## Installation avec Kubeadm


.exercise[

- Installation de paquets Docker si ils ne sont pas installé sur chaque noeud du cluster:
  ```bash
    sudo su
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
    apt-get update && apt-get install -y docker-ce docker-compose
    exit
    sudo groupadd docker
    sudo usermod -aG docker $USER
  ```
]

---

## Installation avec Kubeadm suite


.exercise[

- Installation de paquets Kubernetes si ils ne sont pas installé sur chaque noeud du cluster:
  ```bash
    sudo apt-get update && sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo su
    cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
    deb http://apt.kubernetes.io/ kubernetes-xenial main
    EOF
    exit
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm kubectl
   ```
]

---

## Installation avec Kubeadm suite

.exercise[

- Configuration de Kubernetes avec Kubeadm au premier noeud du cluster:
  ```bash
    sudo kubeadm init 
    sudo mkdir -p $HOME/.kube /home/docker/.kube
    sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo cp /etc/kubernetes/admin.conf /home/docker/.kube/config
    sudo chown -R $(id -u) $HOME/.kube
    kubever=$(kubectl version | base64 | tr -d '\n')
    kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=$kubever
  ```

- Configuration de Kubernetes avec Kubeadm aux autres noeuds du cluster:
- Appliquez la commande retourné par `kubeadm init` sur le master
- Testez si les noeuds sont bien configurés avec:
  ```bash
  kubectl get nodes
  ```
]




