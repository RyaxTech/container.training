# Histoire des conteneurs ... et Docker

---

## Premières expérimentations

* [IBM VM/370 (1972)](https://en.wikipedia.org/wiki/VM_%28operating_system%29)

* [Linux VServers (2001)](http://www.solucorp.qc.ca/changes.hc?projet=vserver)

* [Solaris Containers (2004)](https://en.wikipedia.org/wiki/Solaris_Containers)

* [FreeBSD jails (1999)](https://www.freebsd.org/cgi/man.cgi?query=jail&sektion=8&manpath=FreeBSD+4.0-RELEASE)

Les conteneurs existent depuis *très longtemps* en effet.

---

class: pic

## L'âge du VPS (jusqu'en 2007-2008)

![lightcont](images/containers-as-lightweight-vms.png)

---

## Containers = moins cher que les VM

* Utilisateurs: fournisseurs d'hébergement.

* Audience hautement spécialisée avec une forte culture d'opérations.

---

class: pic

## La période PAAS (2008-2013)

![heroku 2007](images/heroku-first-homepage.png)

---

## Containers = plus facile que les VM

* Je ne peux pas parler pour Heroku, mais les conteneurs étaient (l'une des) arme secrète de dotCloud

* dotCloud utilisait un PaaS, en utilisant un moteur de conteneur personnalisé.

* Ce moteur était basé sur OpenVZ (et plus tard, LXC) et AUFS.

* Il a commencé (vers 2008) comme un seul script Python.

* En 2012, le moteur avait plusieurs (10) composants Python.
  <br/> (et ~ 100 autres micro-services!)

* Fin 2012, dotCloud refactorise ce moteur de conteneur.

* Le nom de code de ce projet est "Docker".

---

## Première version publique de Docker

* Mars 2013, PyCon, Santa Clara:
  <br/> "Docker" est présenté au public pour la première fois.

* Il est publié avec une licence open source.

* Réactions et retours très positifs!

* L'équipe dotCloud passe progressivement au développement de Docker.

* La même année, dotCloud change de nom pour Docker.

* En 2014, l'activité PaaS est vendue.

---

## Docker premiers jours (2013-2014)

---

## Premiers utilisateurs de Docker

* Constructeurs PAAS (Flynn, Dokku, Tsuru, Deis ...)

* Utilisateurs de PAAS (ceux qui sont assez grands pour justifier la construction de leurs propres)

* Plates-formes CI

* développeurs, développeurs, développeurs, développeurs

---

## Boucle de rétroaction positive

* En 2013, la technologie sous conteneurs (cgroups, namespaces, stockage copy-on-write ...)
  avait beaucoup de taches aveugles.

* La popularité croissante de Docker et des conteneurs a révélé de nombreux bugs.

* En conséquence, ces bugs ont été corrigés, ce qui a permis d'améliorer la stabilité des conteneurs.

* Tout hébergeur / fournisseur de cloud décent peut exécuter des conteneurs aujourd'hui.

* Les conteneurs deviennent un excellent outil pour déployer / déplacer des charges de travail de / sur le site / cloud.

---

## Maturité (2015-2016)

---

## Docker devient un standard de l'industrie

* Docker atteint le jalon symbolique 1.0.

* Les systèmes existants tels que Mesos et Cloud Foundry ajoutent un support Docker.

* Normalisation autour de l'OCI (Open Containers Initiative).

* D'autres moteurs de conteneurs sont développés.

* Création de la CNCF (Cloud Native Computing Foundation).

---

## Docker devient une plateforme

* Le moteur de conteneur initial est maintenant connu sous le nom de "Moteur Docker".

* D'autres outils sont ajoutés:
  * Docker Compose (anciennement "Fig")
  * Machine Docker
  * Docker Swarm
  * Kitematic
  * Docker Cloud (anciennement "Tutum")
  * Datacenter Docker
  * etc.

* Docker Inc. lance des offres commerciales.
