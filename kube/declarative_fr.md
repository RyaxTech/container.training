## Déclaratif vs impératif dans Kubernetes

- Pratiquement tout ce que nous créons dans Kubernetes est créé à partir d'un *spec*

- Surveillez les champs `spec` dans les fichiers YAML plus tard!

- Le *spec* décrit *comment nous voulons que la chose soit*

- Kubernetes va *réconcilier* l'état actuel avec les spécifications
  <br/> (techniquement, cela est fait par un certain nombre de *contrôleurs*)

- Quand on veut changer de ressource, on met à jour la *spec*

- Kubernetes va ensuite *converger* cette ressource
