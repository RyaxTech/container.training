# The container ecosystem

In this chapter, we will talk about a few actors of the container ecosystem.

We have (arbitrarily) decided to focus on two groups:

- the Docker ecosystem,

- the Cloud Native Computing Foundation (CNCF) and its projects.

---

class: pic

## The Docker ecosystem

![The Docker ecosystem in 2015](images/docker-ecosystem-2015.png)

---

## Moby vs. Docker

- Docker Inc. (the company) started Docker (the open source project).

- At some point, it became necessary to differentiate between:

  - the open source project (code base, contributors...),

  - the product that we use to run containers (the engine),

  - the platform that we use to manage containerized applications,

  - the brand.

---

## Docker CE vs Docker EE

- Docker CE = Community Edition.

- Available on most Linux distros, Mac, Windows.

- Optimized for developers and ease of use.

- Docker EE = Enterprise Edition.

- Available only on a subset of Linux distros + Windows servers.

  (Only available when there is a strong partnership to offer enterprise-class support.)

- Optimized for production use.

- Comes with additional components: security scanning, RBAC ...

---

## The CNCF

- Non-profit, part of the Linux Foundation; founded in December 2015. 

  *The Cloud Native Computing Foundation builds sustainable ecosystems and fosters
  a community around a constellation of high-quality projects that orchestrate
  containers as part of a microservices architecture.*

  *CNCF is an open source software foundation dedicated to making cloud-native computing universal and sustainable.*

- Home of Kubernetes (and many other projects now).

- Funded by corporate memberships.

---

class: pic

![Cloud Native Landscape](https://landscape.cncf.io/images/landscape.png)

