class: title

# Our training environment

![SSH terminal](images/title-our-training-environment.jpg)

---

# Pre-requirements

- Be comfortable with the UNIX command line

  - navigating directories

  - editing files

  - a little bit of bash (environment variables, loops)

---

class: title

*Tell me and I forget.*
<br/>
*Teach me and I remember.*
<br/>
*Involve me and I learn.*

Misattributed to Benjamin Franklin

[(Probably inspired by Chinese Confucian philosopher Xunzi)](https://www.barrypopik.com/index.php/new_york_city/entry/tell_me_and_i_forget_teach_me_and_i_may_remember_involve_me_and_i_will_lear/)

---

## Hands-on sections

- The whole workshop is hands-on

- We are going to build, ship, and run containers!

- You are invited to reproduce all the demos

- All hands-on sections are clearly identified, like the gray rectangle below

.exercise[

- This is the stuff you're supposed to do!

- Go to [kube.training](https://ryaxtech.github.io/kube.training/) to view these slides


]

---

class: in-person

## Where are we going to run our containers?

---

class: in-person, pic

![You get a cluster](images/you-get-a-cluster.jpg)

---

class: in-person

## You get a cluster of cloud VMs

- Each person (or team of 2 persons) gets a private cluster of cloud VMs

- They'll remain up for the duration of the workshop

- You can automatically SSH from one VM to another

- The nodes have aliases: `node1`, `node2`, etc.

- For now we will only use the first machine.

---

## Our Cluster of VMs

*Each student (or team of 2 students) is given a cluster of 3 VMs.*

- It will stay up during the whole training.

- It will be destroyed shortly after the training.

- It comes pre-loaded with Docker, Kubernetes and some other useful tools.

- Initially we will use Docker on 1 single VM.

---

## What *is* Docker?

- "Installing Docker" really means "Installing the Docker Engine and CLI".

- The Docker Engine is a daemon (a service running in the background).

- This daemon manages containers, the same way that an hypervisor manages VMs.

- We interact with the Docker Engine by using the Docker CLI.

- The Docker CLI and the Docker Engine communicate through an API.

- There are many other programs, and many client libraries, to use that API.

---

## Why don't we run Docker locally?

- We are going to download container images and distribution packages.

- This could put a bit of stress on the local WiFi and slow us down.

- Instead, we use a remote VM that has a good connectivity

- In some rare cases, installing Docker locally is challenging:

  - no administrator/root access (computer managed by strict corp IT)

  - 32-bit CPU or OS

  - old OS version (e.g. CentOS 6, OSX pre-Yosemite, Windows 7)

- It's better to spend time learning containers than fiddling with the installer!

---

## Connecting to your Virtual Machine

You need an SSH client.

* On OS X, Linux, and other UNIX systems, just use `ssh`:

```bash
$ ssh <login>@<ip-address>
```

* On Windows, if you don't have an SSH client, you can download and use:

  * Putty (www.putty.org)

---

## Checking your Virtual Machine

Once logged in, make sure that you can run a basic Docker command:

.small[
```bash
$ docker version
Client:
 Version:       18.03.0-ce
 API version:   1.37
 Go version:    go1.9.4
 Git commit:    0520e24
 Built:         Wed Mar 21 23:10:06 2018
 OS/Arch:       linux/amd64
 Experimental:  false
 Orchestrator:  swarm

Server:
 Engine:
  Version:      18.03.0-ce
  API version:  1.37 (minimum version 1.12)
  Go version:   go1.9.4
  Git commit:   0520e24
  Built:        Wed Mar 21 23:08:35 2018
  OS/Arch:      linux/amd64
  Experimental: false
```
]

If this doesn't work, raise your hand!
