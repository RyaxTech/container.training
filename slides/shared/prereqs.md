# Pre-requirements

- Be comfortable with the UNIX command line

  - navigating directories

  - editing files

  - a little bit of bash (environment variables, loops)

- Some Docker knowledge

  - `docker run`, `docker ps`, `docker build`

  - ideally, you know how to write a Dockerfile and build it
    <br/>
    (even if it's a `FROM` line and a couple of `RUN` commands)

- It's totally OK if you are not a Docker expert!

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

- Go to @@SLIDES@@ to view these slides

- Join the chat room: @@CHAT@@

<!-- ```open @@SLIDES@@``` -->

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

- Each person gets a private cluster of cloud VMs (not shared with anybody else)

- They'll remain up for the duration of the workshop

- You should have a little card with login+password+IP addresses

- You can automatically SSH from one VM to another

- The nodes have aliases: `node1`, `node2`, etc.

---

class: in-person

## Connecting to our lab environment

.exercise[

- Log into the first VM (`node1`) with your SSH client

- Check that you can SSH (without password) to `node2`:
  ```bash
  ssh node2
  ```
- Type `exit` or `^D` to come back to `node1`

]

If anything goes wrong — ask for help!

---

## We will (mostly) interact with node1 only

*These remarks apply only when using multiple nodes, of course.*

- Unless instructed, **all commands must be run from the first VM, `node1`**

- We will only checkout/copy the code on `node1`

- During normal operations, we do not need access to the other nodes

- If we had to troubleshoot issues, we would use a combination of:

  - SSH (to access system logs, daemon status...)
  
  - Docker API (to check running containers and container engine status)

---

