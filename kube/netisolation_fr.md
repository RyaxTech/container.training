# Isolation de Pods

- L'isolation réelle est implémentée avec les *network policies* (politiques de réseau)

- Les network policies sont des ressources (comme des deployments, services, namespaces ...)

- Les network policies spécifient les flux autorisés:

  - entre les pods

  - des pods au monde extérieur

  - et vice versa

(le plugin CNI doit supporter les *NetworkPolicy*)
---

## Présentation des network policies

- Nous pouvons créer autant de politiques de réseau *NetworkPolicy* que nous voulons

- Chaque network policy a:

  - un *pod selector*: "quels pods sont ciblés par la politique?"

  - des listes de règles d'entrée (ingress) et/ou de sortie (egress): "quels peers et quels ports sont autorisés ou bloqués?"

- Si un pod n'est pas ciblé par aucune politique, le trafic est autorisé par défaut

- Si un pod est ciblé par au moins une politique, le trafic doit être autorisé explicitement

- Si un pod match plusieurs *NetworkPolicy*, l'union des règles est utilisé (policyA *ou* poliyB)

---

## Mise en place de l'exemple

.exercise[

- Déployons un nginx.
  ```bash
kubectl run nginx --image=nginx --replicas=2
kubectl expose deployment nginx --port=80
  ```

- Regardons que tout s'est bien passé
  ```bash
kubectl get svc,pod | grep nginx
  ```

]

---

## Mise en place de l'exemple

.exercise[

- Testons le service depuis un pod
  ```bash
kubectl run -i --tty interactivetest --image=alpine --restart=Never --rm -- sh
  ```
(ceci va démarrer une session interractive où les entrés clavier et sorties terminal sont redirigées un pod appelé *hackerz*, qui contient un container *alpine*, qui ne sera jamais redémarré, supprimé une fois la commande finie, et qui lance la commande *sh*)

- On vérifie l'accès à nginx:
  ```bash
wget -qO- nginx
  ```

]

---

## Interdir tout le trafic

.exercise[

- Créez un fichier yaml contenant:
```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: access-nginx
spec:
  podSelector:
    matchLabels:
      run: nginx
  ingress:
  - from:
    - podSelector:
        matchLabels:
            iamnice: yeah
```
et déployez-le.

]

---

## Interdir tout le trafic, vraiment ?

.exercise[

- ré-éssayons de nous connecter au nginx:

  ```bash
wget -qO- nginx
```

- le traffic est bloqué !

]
---

## Interdir tout le trafic sauf à *iamnice*

.exercise[

- Redémarrons notre pod de test avec les bons labels (ctrl+d ou exit pour quitter l'ancien):

  ```bash
kubectl run -i --tty interactivetest --image=alpine --labels="iamnice=yeah" --restart=Never --rm -- sh
```

Depuis ce pod, l'accès  devrait fonctionner...
  ```bash
wget -qO- nginx
```

]

---

## Reset

Supprimez le service, le deployement et le network policy de cet exemple.



---

## En savoir plus sur les network policies

- On peut aussi faire des *selectors* sur les namespaces
    - très utile pour interdire aux containeurs d'accèder à l'API kubernetes!

- On peut interdire/autoriser les communications vers/depuis des ports particuliers

- Idem avec des IPs et blocs d'IPs.


- Pour plus de détails regardez:

  - la [documentation de Kubernetes sur les network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

  - ceci [presentation de network policies chez KubeCon 2017 US](https://www.youtube.com/watch?v=3gGpMmYeEO8) par [@ahmetb](https://twitter.com/ahmetb)

  - et des [exercices](https://github.com/ahmetb/kubernetes-network-policy-recipes)
