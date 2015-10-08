# docker-nessus
[![](https://badge.imagelayers.io/sometheycallme/docker-nessus.svg)](https://imagelayers.io/?images=cleanerbot/docker-nessus:latest 'View image size and layers')&nbsp;
[![Circle CI](https://circleci.com/gh/cleanerbot/docker-nessus.png?circle-token=5d84cd337864c33f062f57aafd2854771777759d)](https://circleci.com/gh/sometheycallme/docker-nessus/tree/master 'View CI builds')

Project URL: https://github.com/cleanerbot/docker-nessus
Docker registry: https://registry.hub.docker.com/u/sometheycallme/docker-nessus


## Procedures

<b>1) Pull the container from [hub.docker.com](https://hub.docker.com/r/sometheycallme/docker-nessus/)</b>

```docker pull sometheycallme/docker-nessus```

or git clone the [repo](https://github.com/cleanerbot/docker-nessus)

```git clone git@github.com:cleanerbot/docker-nessus.git```

If you clone the repo,  you must build the image (go into the repo directory and ```docker build .```

<b>2) Start the container running with static mac assigned - call it ```nessus-unlicensed```</b>

replace <spoofed> with your own uniquely assigned static unicast MAC

```docker run -d --name nessus-unlicensed --mac-address <spoofed> -p 8834:8834 sometheycallme:docker-nessus```

<b>3) Add the license to the running nessus-unlicensed container</b>

You can choose to use the command line (offline registration) or simply provide the unique key in the Web UI after Nessus starts - it will be the one Tenable sends you after you properly register the scanner

<b>4) Stop the container and commit the changes </b>

I name the new container ```nessus:licensed``` and use ```docker images``` command to confirm its creation.  This new container will not be pushed to a public repository.  It will be used in a private repository as our own properly licensed container.

```
docker ps
docker stop <container ID>
docker ps -a
docker commit <container ID> <image-name>
docker images
```

output example

```
[root@localhost docker-nessus]# docker commit 3716bc76dce8 nessus:licensed
d05e0a602768de6b26da76f3ad2dd503e8fd019fa8477d87fefb84be043cf341
[root@localhost docker-nessus]# 
[root@localhost docker-nessus]# docker images
REPOSITORY                    TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
nessus                        licensed            d05e0a602768        7 minutes ago       3.87 GB
```

<b>5) Run the newly created container</b>

Replace <spoofed> with a unique unicast mac-address

```docker run -d --name nessus-licensed --mac-address <spoofed> -p 8834:8834 nessus:licensed```

<b>6) Creating a production container</b>

Once this container is created it would need to be usable internally.  Export the container, import the container, and push to a private docker registry for internal use only.

obviously, name the tarball and ensure quay is setup.

```
docker export <tarball_name>
docker import <tarball_name>
docker push <quay.io>
```
