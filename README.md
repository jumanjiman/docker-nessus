# docker-nessus
[![](https://badge.imagelayers.io/sometheycallme/docker-nessus.svg)](https://imagelayers.io/?images=cleanerbot/docker-nessus:latest 'View image size and layers')&nbsp;
[![Circle CI](https://circleci.com/gh/cleanerbot/docker-nessus.png?circle-token=5d84cd337864c33f062f57aafd2854771777759d)](https://circleci.com/gh/sometheycallme/docker-nessus/tree/master 'View CI builds')

Project URL: https://github.com/cleanerbot/docker-nessus

Docker registry: https://registry.hub.docker.com/u/sometheycallme/docker-nessus

# Docker Nessus

Here are a few things you need to know.

1) BYOL

You need to register your product.  Then you need to save the image after registration.

2) Image

As @Passe12345 pointed out, running everything in a single container works just fine.

3) Docker volumes

When separating nessusd from the licensing-data there it isn't quite working right.

Nessus likes to pull in a bunch of plugins after you register.  We haven't quite figured out how to get Nessus to like separating data volumes (licensing) from the UI/Daemon.   So unfortunatley, when using a separate docker data volume image, this hangs after registration.
https://github.com/cleanerbot/docker-nessus/issues/20

4) Mac-address

You have to use the same Mac address during run-time for license you apply to be respected by Nessus.


### Preserving and existing Nessus install

Another way to do it:

@jcwx has some great procedures written up on how to preserve your existing Nessus and build a docker image.

https://github.com/jcwx/docker-nessus


### Makefile

Create a Docker-Nessus Daemon, and Docker-Nessus-Licensed-Data Volume.

Note: This still does not get past the "download plugins" feature of Nessus startup.

### Make it simple

Thanks @seccubus !

### Step 1: simply run

```
make unlicensed
```
To create a running unlicensed container that you can then license to yourself


### Step 2: then run
```
make licensed
```
To turn this container into a licensed nessus container


### Step 3: lastly run

```
make
```
To run the newly created container

For details see the PROCEDURES.md that captures previous steps and ideas for building the image.
