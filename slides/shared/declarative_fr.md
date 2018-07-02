# Déclaratif vs impératif

- Notre orchestrateur de conteneurs met un accent très fort sur être *déclaratif*

- Déclaratif:

  *Je voudrais une tasse de thé.*

- Impératif:

  *Faire bouillir de l'eau. Versez-le dans une théière. Ajouter les feuilles de thé. Raide pendant un moment. Servir dans une tasse. *

--

- Déclaratif semble plus simple au premier abord ...

--

- ... Tant qu'on sait comment faire du thé

---

## Déclaratif vs impératif

- Quel déclaratif serait vraiment:

  *Je veux une tasse de thé, obtenue en versant une infusion¹ de feuilles de thé dans une tasse.*

--

  *¹Une perfusion est obtenue en laissant l'objet tremper quelques minutes dans de l'eau chaude².*

--

  *²Le liquide chaud est obtenu en le versant dans un conten approprié³ et en le plaçant sur une cuisinière.*

--

  *³Ah, enfin, les conteneurs! Quelque chose que nous connaissons. Mettons-nous au travail, allons-nous?*

--

.footnote [Saviez-vous qu'il y avait une [norme ISO](https://en.wikipedia.org/wiki/ISO_3103) précisant comment brasser le thé?]

---

## Déclaratif vs impératif

- Systèmes impératifs:

  - plus simple

  - Si une tâche est interrompue, nous devons recommencer à zéro

- Systèmes déclaratifs:

  - si une tâche est interrompue (ou si nous nous montrons à mi-chemin),
    nous pouvons comprendre ce qui manque et ne faisons que ce qui est nécessaire

  - nous devons pouvoir *observer* le système

  - ... et calcule un "diff" entre *ce que nous avons* et *ce que nous voulons*
