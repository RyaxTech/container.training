# Découplage de configuration avec un ConfigMap

- Le but de la configuration d'une application est de garder les options de configuration qui varient d'un environnement à l'autre, ou de changer fréquemment, séparément de la source de l'application
code.

- Si vous considérez un descripteur de pod comme un code source pour votre application (il définit comment composer les composants individuels dans un système fonctionnel), il est clair que vous devez supprimer la configuration de la description du pod.

---

## Introduction de ConfigMap

- Kubernetes permet de séparer les options de configuration en un objet distinct appelé ConfigMap, qui est une carte contenant des paires clé / valeur avec des valeurs allant de
des littéraux courts aux fichiers de configuration complets.

- Une application n'a pas besoin de lire directement le ConfigMap ou même de savoir qu'il existe. Le contenu de la carte est plutôt transmis aux conteneurs comme environnement
variables ou en tant que fichiers dans un volume.

---

## Introduction de ConfigMap

- Vous pouvez définir les entrées de la carte en transmettant des littéraux à la commande kubectl ou vous pouvez créer ConfigMap à partir de fichiers stockés sur votre disque.

- Utilisez un littéral simple en premier:

.exercise[
  ```bash
  kubectl create configmap fortune-config --from-literal=sleep-interval=25
  ```

- REMARQUE Les clés ConfigMap doivent être un sous-domaine DNS valide (elles ne peuvent contenir que des caractères alphanumériques, des tirets, des traits de soulignement et des points). Ils peuvent éventuellement inclure un point leader.
]

---

## Explication de Configmaps dans un exemple

- Exécutez l'exemple décrit ici: https://kubernetes.io/docs/tutorials/configuration/configure-redis-using-configmap/


---

# Introduction des secrets

- Kubernetes fournit un objet séparé appelé Secret. Les secrets ressemblent beaucoup à ConfigMaps

- Ce sont aussi des cartes qui contiennent des paires clé-valeur. Ils peuvent être utilisés de la même manière qu'un ConfigMap.

- Vous pouvez passer des entrées secrètes au conteneur en tant que variables d'environnement

- Expose les entrées secrètes en tant que fichiers dans un volume

---

## Introduction des secrets

- Kubernetes aide à garder vos secrets en toute sécurité en s'assurant que chaque secret est seulement distribué
aux nœuds qui exécutent les pods qui ont besoin d'accéder au secret.

- De plus, sur les nœuds eux-mêmes, les Secrets sont toujours stockés en mémoire et jamais écrits dans le stockage physique,
ce qui nécessiterait de nettoyer les disques après avoir supprimé les secrets d'eux.

---
## Introduction des secrets

- Sur le nœud maître proprement dit, etcd stocke les secrets sous forme cryptée, ce qui rend le système beaucoup plus sécurisé. Pour cette raison, il est impératif que vous choisissez correctement quand utiliser un Secret ou un ConfigMap. Choisir entre eux est simple:

 * Utilisez un fichier ConfigMap pour stocker des données de configuration non sensibles et simples.
--

 * Utilisez un secret pour stocker toutes les données sensibles et doivent être conservées sous clé. Si un fichier de configuration contient des données sensibles mais aussi non sensibles, vous
devrez stocker le fichier dans un secret.

---

## Exercices utilisant des secrets

- Quelques exercices initiaux utilisant Secrets peuvent être trouvés ici: https://kubernetes.io/docs/concepts/configuration/secret/
