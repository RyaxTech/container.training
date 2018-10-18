# Compose for development stacks

Dockerfiles are great to build container images.

But what if we work with a complex stack made of multiple containers?

Eventually, we will want to write some custom scripts and automation to build, run, and connect
our containers together.

There is a better way: using Docker Compose.

In this section, you will use Compose to bootstrap a development environment.

---

## What is Docker Compose?

Docker Compose (formerly known as `fig`) is an external tool.

Unlike the Docker Engine, it is written in Python. It's open source as well.

The general idea of Compose is to enable a very simple, powerful onboarding workflow:

1. Checkout your code.

2. Run `docker-compose up`.

3. Your app is up and running!

---

## Compose overview

This is how you work with Compose:

* You describe a set (or stack) of containers in a YAML file called `docker-compose.yml`.

* You run `docker-compose up`.

* Compose automatically pulls images, builds containers, and starts them.

* Compose can set up links, volumes, and other Docker options for you.

* Compose can run the containers in the background, or in the foreground.

* When containers are running in the foreground, their aggregated output is shown.

Before diving in, let's see a small example of Compose in action.

---

## Compose steps

- There are three steps to using Docker Compose:

1. Define each service in a Dockerfile.
2. Define the services and their relation to each other in the `docker-compose.yml` file.
3. Use `docker-compose up` to start the system.

---


## Compose in action

![composeup](images/composeup.gif)

---

## Checking if Compose is installed

If you are using the official training virtual machines, Compose has been
pre-installed.

If you are using Docker for Mac/Windows or the Docker Toolbox, Compose comes with them.

If you are on Linux (desktop or server environment), you will need to install Compose from its [release page](https://github.com/docker/compose/releases) or with `pip install docker-compose`.

You can always check that it is installed by running:

```bash
$ docker-compose --version
```

---

## Launching Our First Stack with Compose

First step: clone the source code for the app we will be working on.

```bash
$ cd
$ git clone git://github.com/jpetazzo/trainingwheels
...
$ cd trainingwheels
```


Second step: start your app.

```bash
$ docker-compose up
```

Watch Compose build and run your app with the correct parameters,
including linking the relevant containers together.

---

## Launching Our First Stack with Compose

Verify that the app is running at `http://<yourHostIP>:8000`.

![composeapp](images/composeapp.png)

---

## Stopping the app

When you hit `^C`, Compose tries to gracefully terminate all of the containers.

After ten seconds (or if you press `^C` again) it will forcibly kill
them.

---

## The `docker-compose.yml` file

Here is the file used in the demo:

.small[
```yaml
version: "2"

services:
  www:
    build: www
    ports:
      - 8000:5000
    user: nobody
    environment:
      DEBUG: 1
    command: python counter.py
    volumes:
      - ./www:/src

  redis:
    image: redis
```
]

---

## Compose file structure

A Compose file has multiple sections:

* `version` is mandatory. (We should use `"2"` or later; version 1 is deprecated.)

* `services` is mandatory. A service is one or more replicas of the same image running as containers.

* `networks` is optional and indicates to which networks containers should be connected.
  <br/>(By default, containers will be connected on a private, per-compose-file network.)

* `volumes` is optional and can define volumes to be used and/or shared by the containers.

---

## Compose file versions

* Version 1 is legacy and shouldn't be used.

  (If you see a Compose file without `version` and `services`, it's a legacy v1 file.)

* Version 2 added support for networks and volumes.

* Version 3 added support for deployment options (scaling, rolling updates, etc).

The [Docker documentation](https://docs.docker.com/compose/compose-file/)
has excellent information about the Compose file format if you need to know more about versions.

---

## Containers in `docker-compose.yml`

Each service in the YAML file must contain either `build`, or `image`.

* `build` indicates a path containing a Dockerfile.

* `image` indicates an image name (local, or on a registry).

* If both are specified, an image will be built from the `build` directory and named `image`.

The other parameters are optional.

They encode the parameters that you would typically add to `docker run`.

Sometimes they have several minor improvements.

---

## Container parameters

* `command` indicates what to run (like `CMD` in a Dockerfile).

* `ports` translates to one (or multiple) `-p` options to map ports.
  <br/>You can specify local ports (i.e. `x:y` to expose public port `x`).

* `volumes` translates to one (or multiple) `-v` options.
  <br/>You can use relative paths here.

For the full list, check: https://docs.docker.com/compose/compose-file/

---

## Compose commands

We already saw `docker-compose up`, but another one is `docker-compose build`.

It will execute `docker build` for all containers mentioning a `build` path.

It can also be invoked automatically when starting the application:

```bash
docker-compose up --build
```

Another common option is to start containers in the background:

```bash
docker-compose up -d
```

---

## Check container status

It can be tedious to check the status of your containers with `docker ps`,
especially when running multiple apps at the same time.

Compose makes it easier; with `docker-compose ps` you will see only the status of the
containers of the current stack:


```bash
$ docker-compose ps
Name                      Command             State           Ports          
----------------------------------------------------------------------------
trainingwheels_redis_1   /entrypoint.sh red   Up      6379/tcp               
trainingwheels_www_1     python counter.py    Up      0.0.0.0:8000->5000/tcp 
```

---

## Cleaning up (1)

If you have started your application in the background with Compose and
want to stop it easily, you can use the `kill` command:

```bash
$ docker-compose kill
```

Likewise, `docker-compose rm` will let you remove containers (after confirmation):

```bash
$ docker-compose rm
Going to remove trainingwheels_redis_1, trainingwheels_www_1
Are you sure? [yN] y
Removing trainingwheels_redis_1...
Removing trainingwheels_www_1...
```

---

## Cleaning up (2)

Alternatively, `docker-compose down` will stop and remove containers.

It will also remove other resources, like networks that were created for the application.

```bash
$ docker-compose down
Stopping trainingwheels_www_1 ... done
Stopping trainingwheels_redis_1 ... done
Removing trainingwheels_www_1 ... done
Removing trainingwheels_redis_1 ... done
```

Use `docker-compose down -v` to remove everything including volumes.

---

## Special handling of volumes

Compose is smart. If your container uses volumes, when you restart your
application, Compose will create a new container, but carefully re-use
the volumes it was using previously.

This makes it easy to upgrade a stateful service, by pulling its
new image and just restarting your stack with Compose.

---

## Compose project name

* When you run a Compose command, Compose infers the "project name" of your app.

* By default, the "project name" is the name of the current directory.

* For instance, if you are in `/home/zelda/src/ocarina`, the project name is `ocarina`.

* All resources created by Compose are tagged with this project name.

* The project name also appears as a prefix of the names of the resources.

  E.g. in the previous example, service `www` will create a container `ocarina_www_1`.

* The project name can be overridden with `docker-compose -p`.

---

## Running two copies of the same app

If you want to run two copies of the same app simultaneously, all you have to do is to
make sure that each copy has a different project name.

You can:

* copy your code in a directory with a different name

* start each copy with `docker-compose -p myprojname up`

Each copy will run in a different network, totally isolated from the other.

This is ideal to debug regressions, do side-by-side comparisons, etc.

---

## Exercise with Docker-compose, Volume and Database

.exercise[

- Download the ready docker-compose.yml that makes use of a Persistent Data Storage for Postgresql

```bash
curl -s https://raw.githubusercontent.com/RyaxTech/kube-tutorial/master/docker-compose.yml --output docker-compose.yml
```
]

- `external: true` tells Docker Compose to use a pre-existing external data volume. 
- If no volume named data is present, starting the application will cause an error. Create the volume:

```bash
docker volume create --name=data
```

- and then start your compose with
```bash
docker-compose up
```
]


---

## Exercise with Docker-compose, Volume and Database

- Create some content within the postgresql
- Start another app with docker-compose so that another postgresql is create that makes use of the same database
- Create data on one container and see if the data exist on the other
- Kill the applications and start one and see again if the data are available.


---

# Security and Docker Containers

The principal security vulnerabilities in Docker:

1. **Kernel exploits**: Unlike a virtual machine, the kernel is shared among all containers and the host. If a container causes a kernel to panic, it will take down the whole host.
2. **Poisoned images**: If an attacker can trick you into running their image, the host and data are at risk.
3. **Denial-of-Service (DoS) attacks**: Containers share kernel resources, so if one container is able to monopolise the access to certain resources, it can starve out other containers on the host. This results in a denial-of-service (DoS). Users are then unable to access part or all of the system.
4. **Container breakouts**: Be aware of potential privilege escalation attacks, where a user gains elevated privileges through a bug in application code that must run with extra privileges. While unlikely, breakouts are possible and should be considered when developing a continuity plan.
5. **Compromising secrets**: When a container accesses a database or service it will require a secret, like an API key or username and password. An attacker that gains access to the secret will also have access to the service.

---

## Security for Docker Containers best practices

- **1. Use trusted images** 

Make sure that the images that are running are up to date. Developers often assemble Docker images rather than build them from scratch. Be sure to set up a trusted registry of base images, which are the only image developers would be allowed to use.

- **2. Limit the Resource Utilization**

Since Docker containers are lightweight processes, you can run many more containers than virtual machines. This increased density is beneficial, as it increases host resource utilization and allows you to optimize total cost of ownership. It also implies that a far greater number of processes are competing for host resources. To reduce the threat of vulnerabilities such as denial-of-service attacks, and performance impacts due to noisy neighbors, you can put limits on the system resources that individual containers can consume, through container orchestration frameworks such as Kubernetes

---

## Security for Docker Containers best practices

- **3. Docker Host, Application Runtime, and Code-Level Security**

Keep the host operating system properly patched and updated. Processes running inside your container should have the latest security updates. Incorporate security best practices into your application code. As you build Docker container images, you need to know exactly what goes into each layer. Ensure that containers installed by third-party vendors do not download and run anything at runtime. Everything that a Docker container runs must be declared and included in the static container image.

- **4. Manage secrets** 

Putting secrets in the container image exposes it to many users and processes and puts it in jeopardy of being misused. You want to provide the container with access to the secrets it needs as it’s running, and not before. The secret should only be accessible to the relevant containers, and should not be stored on disk or be exposed at the host level. Once the container is stopped, the secret disappears.

- By taking a proactive approach, creating and implementing security policies throughout the entire container lifecycle, a containerized environment can be secured very effectively..

---


