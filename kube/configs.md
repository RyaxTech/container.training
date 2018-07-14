# Decoupling configuration with a ConfigMap

- The whole point of an app’s configuration is to keep the config options that vary between environments, or change frequently, separate from the application’s source
code. 

- If you think of a pod descriptor as source code for your app (it defines how to compose the individual components into a functioning system), it’s clear you should move the configuration out of the pod description.

---

## Introducing ConfigMap

- Kubernetes allows separating configuration options into a separate object called a ConfigMap, which is a map containing key/value pairs with the values ranging from
short literals to full config files.

- An application doesn’t need to read the ConfigMap directly or even know that it exists. The contents of the map are instead passed to containers as either environment
variables or as files in a volume. 

---

## Introducing ConfigMap

- You can define the map’s entries by passing literals to the kubectl command or you can create the ConfigMap from files stored on your disk. 

- Use a simple literal first:

.exercise[
  ```bash
  kubectl create configmap fortune-config --from-literal=sleep-interval=25
  ```

- NOTE ConfigMap keys must be a valid DNS subdomain (they may only contain alphanumeric characters, dashes, underscores, and dots). They may optionally include a leading dot.
]

---

## Explaining Configmaps in an example

- Execute the example described here: https://kubernetes.io/docs/tutorials/configuration/configure-redis-using-configmap/


---

# Introducing Secrets

- Kubernetes provides a separate object called Secret. Secrets are much like ConfigMaps 

- They’re also maps that hold key-value pairs. They can be used the same way as a ConfigMap. 

- You can Pass Secret entries to the container as environment variables

- Expose Secret entries as files in a volume

---

## Introducing Secrets

- Kubernetes helps keep your Secrets safe by making sure each Secret is only distributed
to the nodes that run the pods that need access to the Secret. 

- Also, on the nodes themselves, Secrets are always stored in memory and never written to physical storage,
which would require wiping the disks after deleting the Secrets from them.

---
## Introducing Secrets

- On the master node itself etcd stores Secrets in encrypted form, making the system much more secure. Because of this, it’s imperative you properly
choose when to use a Secret or a ConfigMap. Choosing between them is simple:

 * Use a ConfigMap to store non-sensitive, plain configuration data.
--

 * Use a Secret to store any data that is sensitive in nature and needs to be kept under key. If a config file includes both sensitive and not-sensitive data, you
should store the file in a Secret.

---

## Exercises using Secrets

- Some initial exercises using Secrets can be found here: https://kubernetes.io/docs/concepts/configuration/secret/

---








