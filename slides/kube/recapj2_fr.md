
# Recap Jour 2


L'équipe marketing à determiner que la vA du serveurweb était la meilleure.

Vous aller donc lancer un service qui exposera un **pod**.

Cependant, ils veulent aussi que vous rajoutiez un dossier `bonus` dans /tmp/ qui contiendra un fichier `bonus.txt`. Ce fichier aura juste le texte "bonus" dedans.

Lors de la réunion vous sentez que ce fichier va surement changer souvent... Vous décidez qu'au lieu de changer l'image docker, vous aller monter un volume persitant qui vous permettera de changer rapidement le contenu de ce dossier.

- Conseil: ne foncez pas tête baisser. Faites un plan, puis éxecutez le.

- Conseil 2: la slide suivante contient de l'aide... A vous de voir...

---

## Aide

- Repartez de https://raw.githubusercontent.com/zonca/jupyterhub-deploy-kubernetes-jetstream/master/storage_rook/alpine-rook.yaml

- l'image du serveur A s'appelle `127.0.0.1:32092/serverweb:vA`

- Pour écrire le fichier bonus, connéctez-vous au pod:
  ```bash
kubectl exec -ti alpine -- sh
  ```



