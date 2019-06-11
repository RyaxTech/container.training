# Monitoring avec Prometheus et Grafana

- Prometheus, pour le monitoring

- Grafana, pour afficher les métriques et jouer avec.

---

## Kube Prometheus

Kube Prometheus est un dépot git qui permet d'installer une stack de monitoring Prometheus+Grafana pour kubernetes.
Il configure aussi Grafana pour intégrer des graphiques utiles.

.exercise[
  ```bash
git clone https://github.com/coreos/prometheus-operator.git

cd prometheus-operator/contrib/kube-prometheus/

kubectl create -f manifests/
  ```
]

---

## Grafana

.exercise[
- Ouvrez le service grafana à l'exterieur, connectez-vous y avec votre navigateur web

- Si vous avez besoin  de vous logguer : admin/admin

- Cliquez sur "Home" tout en haut de l'écran, choisissez le dashboard *Pods*.

- Quel est l'utilisation mémoire du pod registery ?

- Quel est le coût des pods du daemonset de prometheus ?

]


---

## reset

  ```bash
kubectl delete -f manifests/
  ```

