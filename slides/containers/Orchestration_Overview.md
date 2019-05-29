# Orchestration, an overview

In this chapter, we will:

* Explain what is orchestration and why we would need it.

* Present (from a high-level perspective) some orchestrators.

---

class: pic

## What's orchestration?

![Joana Carneiro (orchestra conductor)](images/conductor.jpg)

---

## What's orchestration?

According to Wikipedia:

*Orchestration describes the __automated__ arrangement,
coordination, and management of complex computer systems,
middleware, and services.*

What does that really mean?

- Application scheduling (where to put them)
- Application life-cycle management

---

## What is scheduling?

According to Wikipedia (again):

*In computing, scheduling is the method by which threads, 
processes or data flows are given access to system resources.*

The scheduler is concerned mainly with:

- maximize resources utilization (don't use two machines when one is enough)
- throughput (total amount of work done per time unit);
- turnaround time (between submission and completion);
- fairness (appropriate times according to priorities).

In practice, these goals often conflict.

**"Scheduling" = decide which resources to use.**

---

class: pic

## Scheduling with one resource

.center[![Not-so-good bin packing](images/binpacking-1d-1.gif)]

## We can't fit a job of size 6 :(

---

class: pic

## Scheduling with one resource

.center[![Better bin packing](images/binpacking-1d-2.gif)]

## ... Now we can!

---

class: pic

## Scheduling with two resources

.center[![2D bin packing](images/binpacking-2d.gif)]

---

class: pic

## Scheduling with three resources

.center[![3D bin packing](images/binpacking-3d.gif)]

---

class: pic

## You need to be good at this

.center[![Tangram](images/tangram.gif)]

---

class: pic

## But also, you must be quick!

.center[![Tetris](images/tetris-1.png)]

---

class: pic

## And be web scale!

.center[![Big tetris](images/tetris-2.gif)]

---

class: pic

## And think outside (?) of the box!

.center[![3D tetris](images/tetris-3.png)]

---

class: pic

## Good luck!

.center[![FUUUUUU face](images/fu-face.jpg)]

---

## TL,DR

* Scheduling with multiple resources (dimensions) is hard.

* Don't expect to solve the problem with a Tiny Shell Script.

* There are literally tons of research papers written on this.

---

## But our orchestrator also needs to manage applications life-cycles

* Network connectivity (or filtering) between containers.

* Load balancing (external and internal).

* Failure recovery (if a node or a whole datacenter fails).

* Rolling out new versions of our applications.

  (Canary deployments, blue/green deployments...)


---

## Some orchestrators

We are going to present briefly a few orchestrators.

There is no "absolute best" orchestrator.

It depends on:

- your applications,

- your requirements,

- your pre-existing skills...

---

## Nomad

- Open Source project by Hashicorp.

- Arbitrary scheduler (not just for containers).

- Great if you want to schedule mixed workloads.

  (VMs, containers, processes...)

- Less integration with the rest of the container ecosystem.

---

## Mesos

- Open Source project in the Apache Foundation.

- Arbitrary scheduler (not just for containers).

- Two-level scheduler.

- Top-level scheduler acts as a resource broker.

- Second-level schedulers (aka "frameworks") obtain resources from top-level.

- Frameworks implement various strategies.

  (Marathon = long running processes; Chronos = run at intervals; ...)

- Commercial offering through DC/OS by Mesosphere.

---

## Swarm

- Tightly integrated with the Docker Engine.

- Extremely simple to deploy and setup, even in multi-manager (HA) mode.

- Secure by default.

- Strongly opinionated:

  - smaller set of features,

  - easier to operate.

---

## Kubernetes

- Open Source project initiated by Google.

- Contributions from many other actors.

- *De facto* standard for container orchestration.

- Many deployment options; some of them very complex.

- Reputation: steep learning curve.

- Reality:

  - true, if we try to understand *everything*;

  - false, if we focus on what matters.

---
## Orchestration platforms

- Nice web UI and API on to abstract ochestrators

### Rancher

- Rancher 1 offered a simple interface for Docker hosts.

- Rancher 2 is a complete management platform for Docker and Kubernetes.

- Lightweight

### OpenShift

- RedHat enterprise distribution of Kubernetes

- Featureful
