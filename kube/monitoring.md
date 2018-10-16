# Monitoring with Prometheus and Grafana

- Prometheus, for monitoring

- Grafana, for displaying the metrics and play with them.

---

## Kube Prometheus

Kube Prometheus is a repository git that allows to install a monitoring stack Prometheus+Grafana for kubernetes.
It can configure also Grafana to integrate useful graphs.

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
- Open the grafana service externally, connect on it with your web browser

- To login you can use : admin/admin

- Click on "Home" at the top of the screen and choose the *"Pods"* dashboard.

- What is the memory usage of the registery pod ?

- What is the cost of prometheus daemonset pods ?

]


---

## Reset

  ```bash
kubectl delete -f manifests/
  ```

