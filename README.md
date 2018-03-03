# docker-nessus
[![](https://badge.imagelayers.io/sometheycallme/docker-nessus.svg)](https://imagelayers.io/?images=cleanerbot/docker-nessus:latest 'View image size and layers')&nbsp;
[![Circle CI](https://circleci.com/gh/cleanerbot/docker-nessus.png?circle-token=5d84cd337864c33f062f57aafd2854771777759d)](https://circleci.com/gh/sometheycallme/docker-nessus/tree/master 'View CI builds')

Nessus 7.0.2 in a Centos based docker container

Project URL: https://github.com/cleanerbot/docker-nessus

Docker registry: https://registry.hub.docker.com/u/sometheycallme/docker-nessus

# Nessus Registration
https://www.tenable.com/products/nessus/activation-code

# Docker Nessus

Here are a few useful things to know.

1) <b>BYOL:</b> Register your product.  Save the image after registration.

2) <b>Image:</b> Cleanerbot/docker-nessus installs Nessus in a single image, then copies the data over after a proper installation to a  data image.

3) <b>Docker volumes:</b> When separating nessusd from the licensing-data you need to copy data over from the licensed image ```/sbin /var and /etc```  Nessus likes to pull in a bunch of plugins after you register, on the order of 5GB

4) <b>Mac-address:</b> Use the same Mac address during run-time for license you apply to be respected by Nessus.


### Makefile

Create a Docker-Nessus Daemon, and Docker-Nessus-Licensed-Data Volume.

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


### Preserving an existing Nessus install

Another way to do it:
@jcwx has some nice procedures written up on how to preserve your existing Nessus and build a docker image.

https://github.com/jcwx/docker-nessus

There are other images out there too:
https://hub.docker.com/r/treadie/nessus/


