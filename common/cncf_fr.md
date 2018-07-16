# L'écosystème de Kubernetes


- A l'origine développé par Google

- Il est maintenu par la Cloud Native Computing Foundation (CNCF).

- La CNCF est un projet de la Linux Fundation (mais kubernetes peut tout de même fonctionner sur Windows et Mac!)

- Exemples de membres de la CNCF: Google, Twitter, Huawei, Intel, Cisco, IBM, Docker, Univa, VMware, Alibaba, jd.com, SAP, redhat, AT&T...

- Délivre des certifications, organise les évenements "Kubecon", synchronise les developements, mais surtout développe l'écosystème de Kubernetes


---

## Le paysage des projets Kubernetes

- Kubernetes est composé d'un certains nombres de plugins et projets connexes. Par exemple:
    - **Container Network Interface (CNI)**, définit un standard pour gérer le réseau.
    - **coreDNS**, serveur DNS pour les micro-services
    - **envoy**, un plugin CNI
    - **linkerd**, "service mesh" (load balancing, CNI, DNS, security, policy...)
    - **Vitess**, serveur SQL suivant une architecture micro-service

- La CNCF essaye de tenir une liste de tous les projets dans leur *[landscape](https://landscape.cncf.io/)*

---

class: pic
![Landscape](images/CloudNativeLandscape_latest.png)


