# Passage à l'échelle (scaling) d'un déploiement

- Nous allons commencer par un facile: le déploiement du `worker`

.exercise[

- Ouvrez deux nouveaux terminaux pour vérifier ce qui se passe avec les pods et les déploiements:
  ```bash
  kubectl get pods -w
  kubectl get deployments -w
  ```


- Maintenant, créez plus de replicas `worker`:
  ```bash
  kubectl scale deploy/worker --replicas=10
  ```

]

Après quelques secondes, le graphique dans l'interface utilisateur Web devrait apparaître.
<br/>
(Et aller jusqu'à 10 hashes/seconde)


