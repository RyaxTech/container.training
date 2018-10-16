
# Serverless

---
class: pic

![apigateway](images/serverless_apigateway.png)

---

## Exemple of a serverless function
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

## What can we do with that ?

1) Upload it in a on a serverless platform

2) Configure the API Gateway of that platorm so that the function is called when a particular event occurs.


---

## The advantages of serverless

- No administration (for the user)

- Auto-scaling

- Pay-per-use

- Deploy more often and faster

- Multi-language applications

- The developer should not bother for the scalability of his code

---

## The disadvantages of serverless

- The developer should not bother for the scalability of his code
    - the parallelization is situated within the underlying database (ex: dynamoDB)

- More independent elements to manage

- An error can be propagated through multiple functions before causing a problem

- Program *"pure"* functions can be difficult

- The sysadmins change the code (by upgrading python for example), without knowing the code that is using it => possibility for bugs!


---

## Possible Use Cases

- Gestion de contenu (ex: genérer des aperçus d'images)
- Treat events coming from SaaS (ex: when a message "pizza" is recieved on slack, order pizza)
- Auto-scaling of websites and APIs
- Hybrid-cloud Applications
- Data Pipeline such as Extract-Transform-Load
- Notifications
- Real time update
- Client access : a function to validate a token
- Live data migration
- CI/CD


---

## Example of a use case


- Example of a website for monthly delivery of chocolate boxes:

    - the frontend is managed by a wordpress service
    - the forms are managed by an external service (ex: formstack)
    - the payment is managed by an external service (ex: stripe, paypal)
    - the client Data Base is managed by an external service (ex: google sheet, firebase)
    - tha stock management is provided by an external service (ex: Odoo, SAP)
    - when a new user is subscribed, her information are added to the client DB
    - when a new user is entered in the DB, the command is added in the stock management
    - when a new mail appears in tha client DB, new marketing emails are automatically sent (to buy new "enhanced" boxes with more chocolates)
    - ...

---

## Serverless allows decoupling

- Application coded using serverless architecture allows to decouple services, data, intelligence, etc

- The developer just needs to connect the right services amongst them.

- The "API economy" is another tangible example.



---

class: pic
![Landscape](images/CloudNativeLandscape_Serverless_latest.png)
