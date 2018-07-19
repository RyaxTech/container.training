
# Serverless

---
class: pic

![apigateway](images/serverless_apigateway.png)

---

## Exemple d'une fonction serverless
```python
import json, logging, os, time, uuid
import boto3
dynamodb = boto3.resource('dynamodb')

def create(event, context):
    data = json.loads(event['body'])
    table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

    item = {
        'id': str(uuid.uuid1()),
        'text': data['text'],
        'createdAt': int(time.time() * 1000),
    }

    table.put_item(Item=item)
    return {
        "statusCode": 200,
        "body": json.dumps(item)
    }
```
---

## Que faire de ça ?

1) l'uploader sur une plateforme de serverless

2) configurer l'API Gateway de cette plateforme pour que la fonction soit appelé lors d'un evenement choisi.


---

## Les avantages du serverless

- Pas d'administration (pour l'utilisateur)

- Auto-scaling

- Pay-per-use

- déployer plus souvent et plus rapidement

- Applications multi-language

- Le développeur n'a pas à se soucier de la scalabilité de son code

---

## Les défauts du serverless

- Le développeur n'a pas à se soucier de la scalabilité de son code
    - la difficulté de parallélisation est dans la base de donnée sous jacente (ex: dynamoDB)

- Plus d'éléments indépendants à gérer

- Une erreur peut être propager à travers plusieurs fonctions avant de causer des problèmes

- Programmer des fonctions *"purs"* peut être difficile

- Les sysadmins changent du code (en mettant à jour par exemple python), sans connaitre le code qui l'utilise => possibilité de bugs!


---

## Les Use Cases

- Gestion de contenu (ex: genérer des aperçus d'images)
- Traiter des évenements venant de SaaS (ex: quand un msg "pizza" reçu sur slack, commander un pizza)
- Auto-scaling des sites webs et des APIs
- Hybrid-cloud Applications
- Data Pipeline, principalement du Extract-Transform-Load
- Notifications
- Real time update
- Client access : un fonction pour valider un token
- Live data migration
- CI/CD


---

## Exemple de use case


- Exemple avec un site web de livraison mensuel de box de chocolats:

    - le frontend est gérer par un service wordpress
    - les formulaires sont géré par un service externe (ex: formstack)
    - le paiement est géré par un service externe (ex: stripe, paypal)
    - la base de donnée client est géré par un service externe (ex: google sheet, firebase)
    - la gestion des stocks est faites via un service externe (ex: Odoo, SAP)
    - quand un nouvel utilisateur s'enregistre, ses informations sont rajouté dans la base client
    - quand un nouveau client est entrée dans la base, la commande est ajouter dans le gestionnaire de stock
    - quand un nouveau mail apparet dans la base client, des mails marketing sont envoyé (pour acheter des *super* boites, avec plus de chocolats)
    - ...

---

## Le serverless permet un découplage

- Une application coder avec du serverless permet de découpler les services, des données, de l'intéligence.

- Le developpeur a juste à connécter les bons services entre eux.

- Voir "API economy".



---

class: pic
![Landscape](images/CloudNativeLandscape_Serverless_latest.png)
