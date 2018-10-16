# Kubernetes ecosystem


- Initially developed by Google

- It is currently maintained by the Cloud Native Computing Foundation (CNCF).

- The CNCF is a project of the Linux Fundation (but kubernetes can function on Windows and Mac!)

- Some representative members of the CNCF: Google, Twitter, Huawei, Intel, Cisco, IBM, Docker, Univa, VMware, Alibaba, jd.com, SAP, redhat, AT&T...

- CNCF delivers certifications, organises the "Kubecon" events, synchronizes developements, but mainly develops Kubernetes ecosystem


---

## The different projects around Kubernetes

- Kubernetes is composed by a number of plugins and connected projects such as:
    - **Container Network Interface (CNI)**, defines a standard to manage the network.
    - **coreDNS**, server DNS for micro-services
    - **envoy**, a plugin CNI
    - **linkerd**, "service mesh" (load balancing, CNI, DNS, security, policy...)
    - **Vitess**, server SQL following a micro-services architecture

- CNCF tries to maintain a list of all the surrounding projects in *[landscape](https://landscape.cncf.io/)*

---

class: pic
![Landscape](images/CloudNativeLandscape_latest.png)

