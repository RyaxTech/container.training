# TP Wordpress

Wordpress est un moteur de site web écrit en PHP. Il est utilisé par plus de 60 millions de sites webs dans le monde.

Nous allons déployer une instance wordpress sur notre cluster

Wordpress necessite une base de donnée pour fonctionner (généralement MySQL).

Mais aussi d'un dossier de cache.

Et un dossier permettant de stocker les fichiers uploadés.


---

## Question 1

.exercise[

De quels "objets" Kubernetes avons-nous besoin ?

]


---

## Question 1

.exercise[

De quels "objets" Kubernetes avons-nous besoin ?

]

- 2 pods : 1 pour Kubernetes, 1 pour Mysql

- 2 deployments : pour gérer les pods

- 1 service "ClusterIP" mysql, pour n'éxposer la BdD en interne uniquement

- 1 service "NodePort" (ou "LoadBalancer") wordpress, pour exposer le service au monde exterieur

- 3 persistentVolume pour stocker les données.

- 1 secret pour partager entre les pods le mot de passe d'accès à MySQL.

---
## persistentVolume

Sur le cluster est installé rook.
Rook est un fournisseur de persistentVolume basé sur Ceph.

Il nous suffira de créer des PersistentVolumeClaim avec comme classe "rook-ceph-block" pour obtenir dynamiquent de nouveaux volumes.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
  labels:
    app: wordpress
spec:
  storageClassName: rook-ceph-block
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
```

---
## persistentVolume

Et pour utiliser ce PersistentVolumeClaim, on ajoutera un volume au pod, et on montera se volume dans le bon dossier:


```yaml
    ...
    spec:
      containers:
        ...
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pv-claim
```

---
## Secrets

.exercise[
- Créer, depuis la ligne de commande, un ssecret contenant le mot de passe MySQL.
```bash
kubectl create secret generic mysql-pass --from-literal=password=superpassword```

]

On pourra ensutie utiliser cette valeure au moment de définir les variables d'environement de l'image:

```yaml
env:
- name: MYSQL_ROOT_PASSWORD
    valueFrom:
    secretKeyRef:
        name: mysql-pass
        key: password
```

---
## Deployments

Nous utiliserons des deployments pour gérer nos pods.

```yaml
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql
      ...
```

---
## Service

Enfin nous auront des services pour éxposer en interne ou externe les déployments wordpress et mysql.

Exemple:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  ports:
    - port: 3306
  selector:
    app: wordpress
    tier: mysql
  clusterIP: None
```

---
## Let's go!

.exercise[
Récupérer les yamls et déployez-les!

```bash
wget https://gist.githubusercontent.com/glesserd/24310a37f464d6d7569c358bcec3213d/raw/f3d0ad463659b002d2d7a047ccae9dea7fe6a60f/mysql.yaml

wget https://gist.githubusercontent.com/glesserd/e89d765ee9cfa99bd274350c3fbdb12b/raw/66e26359f5b81d7be3b58f043500428db7fe78ea/wordpress.yaml

kubectl apply -f mysql.yaml
kubectl apply -f wordpress.yaml

```

]








