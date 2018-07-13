# Introducing Volumes

- Kubernetes volumes are a component of a pod and are thus defined in the pod’s specification—much like containers. 

- They aren’t a standalone Kubernetes object and cannot be created or deleted on their own. 

- A volume is available to all containers in the pod, but it must be mounted in each container that needs to access it. 

- In each container, you can mount the volume in any location of its filesystem.

---

## Explaining volumes in an example 

- Containers no common storage

- Containers sharing 2 volumes mounted in different mount paths

---

class: pic

![haha seulement blague](images/volumes1.png)

---

class: pic

![haha seulement blague](images/volume2.png)

---


## Note

- The volume /var/logs is not mounted in the ContentAgent container. 

- The container cannot access its files, even though the container and the volume are part of the same pod. 

- It’s not enough to define a volume in the pod; you need to define a VolumeMount inside the container’s spec also, if you want the container to be able to access it.

---

## Volume Types

- A wide variety of volume types is available. Several are generic, while others are specific to the actual storage technologies used underneath. 

* `emptyDir`: A simple empty directory used for storing transient data.
* `hostPath`: Used for mounting directories from the worker node’s filesystem into the pod.
* `gitRepo`: A volume initialized by checking out the contents of a Git repository.
* `nfs`: An NFS share mounted into the pod.
* `gcePersistentDisk`, `awsElasticBlockStore`, `azureDisk`: Used for mounting cloud provider-specific storage.
* `cinder`, `cephfs`, ...: Used for mounting other types of network storage.
* `configMap`, `secret`, `downwardAPI`: Special types of volumes used to expose certain Kubernetes resources and cluster information to the pod.
* `persistentVolumeClaim`: A way to use a pre- or dynamically provisioned persistent storage. 

---

## Note

- A single pod can use multiple volumes of different types at the same time

- Each of the pod’s containers can either have the volume mounted or not.

---

## Example a pod using gitrepo volume

---

.exercise[
  ```bash
apiVersion: v1
kind: Pod
metadata:
  name: gitrepo-volume-pod
spec:
  containers:
  - image: nginx:alpine
    name: web-server
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
      readOnly: true
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:
  - name: html
    gitRepo:
      repository: https://github.com/luksa/kubia-website-example.git
      revision: master
      directory: .   
  ```
]

---

## Decoupling pods from the underlying storage technology

- Above case is  against the basic idea of Kubernetes, which aims to hide the actual infrastructure from both the application and its developer.

- When a developer needs a certain amount of persistent storage for their application, they should request it from Kubernetes. 

- The same way they request CPU, memory, and other resources when creating a pod. 

- The system administrator can configure the cluster so it can give the apps what they request.

---

# Introducing PersistentVolumes and PersistentVolumeClaims

- Instead of the developer adding a technology-specific volume to their pod, it’s the cluster administrator who sets up the underlying storage and then registers it in
Kubernetes by creating a PersistentVolume resource through the Kubernetes API server. 

- When creating the PersistentVolume, the admin specifies its size and the access
modes it supports.

---

## Introducing PersistentVolumes and PersistentVolumeClaims

- When a cluster user needs to use persistent storage in one of their pods, they first create a PersistentVolumeClaim manifest, specifying the minimum size and the access
mode they require. 

- The user then submits the PersistentVolumeClaim manifest to the Kubernetes API server, and Kubernetes finds the appropriate PersistentVolume and binds the volume to the claim.

- The PersistentVolumeClaim can then be used as one of the volumes inside a pod. Other users cannot use the same PersistentVolume until it has been released by deleting
the bound PersistentVolumeClaim.

---

## Example of PersistentVolumes and PersistentVolumeClaims

---

class: pic

![haha seulement blague](images/volumes3.png)

---

## PersistentVolumes and Namespaces

---

class: pic

![haha seulement blague](images/Volume4.png)

---

##  Lifespan of PersistentVolume and PersistentVolumeClaims

---

class: pic

![haha seulement blague](images/Volume5.png)

---
# Dynamic Provisioning of PersistentVolumes

- We have seen how using PersistentVolumes and PersistentVolumeClaims makes it easy to obtain persistent storage without the developer having to deal with the actual storage
technology used underneath. 

- But this still requires a cluster administrator to provision the actual storage up front. 

---

## Dynamic Provisioning of PersistentVolumes

- Luckily, Kubernetes can also perform this job automatically through dynamic provisioning of PersistentVolumes.

- The cluster admin, instead of creating PersistentVolumes, can deploy a PersistentVolume provisioner and define one or more StorageClass objects to let users choose what type of PersistentVolume they want. 

- The users can refer to the StorageClass in their PersistentVolumeClaims and the provisioner will take that into account when provisioning the persistent storage. 

---

class: pic

![haha seulement blague](images/volume6.png)

---

# Rook: orchestration of distributed storage

- Rook is an open source orchestrator for distributed storage systems.

- Rook turns distributed storage software into a self-managing, self-scaling, and self-healing storage services. 

- It does this by automating deployment, bootstrapping, configuration, provisioning, scaling, upgrading, migration, disaster recovery, monitoring, and resource management. 

---
## Rook: orchestration of distributed storage
- Rook is focused initially on orchestrating Ceph on-top of Kubernetes. Ceph is a distributed storage system that provides file, block and object storage and is deployed in large scale production clusters. 

- Rook is hosted by the Cloud Native Computing Foundation (CNCF) as an inception level project.

---

## Example of dynamic provisioning of PersistentVolumes using Rook

.exercise[
  ```bash
   git clone https://github.com/rook/rook.git
   cd rook/cluster/examples/kubernetes/ceph
   kubectl create -f operator.yaml
   kubect create -f cluster.yaml
  ```
- check to see everything is running as expected
 ```bash
   kubectl get pods -n rook-ceph
  ```

]

---

## Example of dynamic provisioning of PersistentVolumes using Rook

- Block storage allows you to mount storage to a single pod. 

- Let's see how to build a simple, multi-tier web application on Kubernetes using persistent volumes enabled by Rook.

--

- Before Rook can start provisioning storage, a StorageClass and its storage pool need to be created. 

- This is needed for Kubernetes to interoperate with Rook for provisioning persistent volumes.

---

## Example of dynamic provisioning of PersistentVolumes using Rook

.exercise[
- Save this storage class definition part as pool.yaml:
   ```bash
   apiVersion: ceph.rook.io/v1alpha1
   kind: Pool
   metadata:
     name: replicapool
     namespace: rook-ceph
   spec:
     replicated:
       size: 3
   ```
]

---


## Example of dynamic provisioning of PersistentVolumes using Rook

.exercise[
- Save this storage class definition part as storageclass.yaml:
   ```bash
   apiVersion: storage.k8s.io/v1
   kind: StorageClass
   metadata:
     name: rook-ceph-block
   provisioner: ceph.rook.io/block
   parameters:
      pool: replicapool
      #The value of "clusterNamespace" MUST be the same as the one in which your rook cluster exist
      clusterNamespace: rook-ceph
   ```
]

---

## Example of dynamic provisioning of PersistentVolumes using Rook

.exercise[
- Create the pool and storage class:
  ```bash
  kubectl create -f pool.yaml
  kubectl create -f storageclass.yaml
  ```
]
- Consume the storage with wordpress sample
- We create a sample app to consume the block storage provisioned by Rook with the classic wordpress and mysql apps. 
- Both of these apps will make use of block volumes provisioned by Rook.

---

## Example of dynamic provisioning of PersistentVolumes using Rook


.exercise[
- Start mysql and wordpress from the cluster/examples/kubernetes folder:
  ```bash
kubectl create -f mysql.yaml
kubectl create -f wordpress.yaml
```
- Both of these apps create a block volume and mount it to their respective pod. You can see the Kubernetes volume claims by running the following:

 ```bash
kubectl get pvc
```
- You should see something like this:
```bash
NAME             STATUS    VOLUME                                     CAPACITY   ACCESSMODES   AGE
mysql-pv-claim   Bound     pvc-95402dbc-efc0-11e6-bc9a-0cc47a3459ee   20Gi       RWO           1m
wp-pv-claim      Bound     pvc-39e43169-efc1-11e6-bc9a-0cc47a3459ee   20Gi       RWO           1m
```
]
---

## Example of dynamic provisioning of PersistentVolumes using Rook

.exercise[
- Once the wordpress and mysql pods are in the Running state, get the cluster IP of the wordpress app and enter it in your browser along with the port:

```bash
kubectl get svc wordpress
```
]
You should see the wordpress app running.

---

## Launch another example of dynamic provisioning

.exercise[

- Copy the file from here : https://github.com/zonca/jupyterhub-deploy-kubernetes-jetstream/blob/master/storage_rook/alpine-rook.yaml

- Modify it so that it fits the specification you have at your cluster and run it using:
  ```bash
  kubectl create -f alpine-rook.yaml
  ```

]

---

## Launch another example of dynamic provisioning (suite)

- It is a very small pod with Alpine Linux that creates a 2 GB volume from Rook and mounts it on /data.

- This creates a Pod with Alpine Linux that requests a Persistent Volume Claim to be mounted under /data. 

- The Persistent Volume Claim specified the type of storage and its size. 

- Once the Pod is created, it asks the Persistent Volume Claim to actually request Rook to prepare a Persistent Volume that is then mounted into the Pod.

---

## Launch another example of dynamic provisioning (suite)

- We can verify the Persistent Volumes are created and associated with the pod, check:

.exercise[
  ```bash
  kubectl get pv
  kubectl get pvc
  kubectl get logs alpine
  ```
- Get a shell in the pod with:
  ```bash
  kubectl exec -it alpine  -- /bin/sh
  ```
- Access /data/ and write some files.
- Exit the shell 
- Now delete the pod and see if you can retrieve the data you wrote.
]

---
## Launch another example of dynamic provisioning (suite)

.exercise[
- How could have we retrieved the data in the last case?
- Let's change the alpine-rook.yaml to `kind:deployment` write some files and kill again the pod to see what happens.
]




