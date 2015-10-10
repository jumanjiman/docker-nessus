# docker-nessus
[![](https://badge.imagelayers.io/sometheycallme/docker-nessus.svg)](https://imagelayers.io/?images=cleanerbot/docker-nessus:latest 'View image size and layers')&nbsp;
[![Circle CI](https://circleci.com/gh/cleanerbot/docker-nessus.png?circle-token=5d84cd337864c33f062f57aafd2854771777759d)](https://circleci.com/gh/sometheycallme/docker-nessus/tree/master 'View CI builds')

Project URL: https://github.com/cleanerbot/docker-nessus
Docker registry: https://registry.hub.docker.com/u/sometheycallme/docker-nessus


# Procedures

<i>updated 20151009</i>

### Intro

Docker Nessus runs with the Nessus daemon as an image, and Nessus data ```/opt/nessus``` in a separate data image.

It is entirely possible to change the docker build commands to run everything in a single image / container.  The preference for our build purposes was to create a data image / container such that rules, templates, policies, user information, and licensing can be preserved between upgrades.

### Steps

<b>1) Pull the [data container]((https://hub.docker.com/r/sometheycallme/docker-nessus-data/), and [nessusd container](https://hub.docker.com/r/sometheycallme/docker-nessus/) </b>

```docker pull sometheycallme/docker-nessus-data```

```docker pull sometheycallme/docker-nessus```


Or if you prefer build the images from the git repo

git clone the [repo](https://github.com/cleanerbot/docker-nessus)

```git clone git@github.com:cleanerbot/docker-nessus.git```

Create the data volume image and build the nessusd image

```shell
# in the nessus-data folder of the repository
cd /docker-nessus/nessus-data
docker create .

# in the root of the repository

cd ..
docker build .
```

<b>2) Start the container running with static mac assigned ```nessus-unlicensed```</b>

if you build the image from the repo - use the tags you created (or hash)

IMPORTANT: provide a unique static unicast MAC

Name the image ```nessus-unlicensed```


```docker run -d --name nessus-unlicensed -p 8834:8834 --mac-address 02:42:ac:11:00:01 --volumes-from nessus-data sometheycallme/docker-nessus```


<b>3) Add the license to the running nessus-unlicensed container</b>

You can use the [Nessus CLI](http://static.tenable.com/documentation/nessus_v6_command_line_reference.pdf) for offline registration or simply provide the unique key in the Web UI after Nessus starts.  Either way you will need to register.


<b>4) Stop the container and commit the changes </b>

Name the newly licensed container ```nessus:licensed``` and use ```docker images``` command to confirm its creation.  This new container will not be pushed to a public repository.  It will be used in a private repository as our own properly licensed container.

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

Replace <spoofed> with a unique unicast mac-address for your organization

```docker run -d --name nessus-licensed --mac-address <spoofed> -p 8834:8834 nessus:licensed```

<b>6) Creating a production container</b>

Once this container is created it would need to be usable internally.  Export the container, import the container, and push to a private docker registry for internal use only.

obviously, name the tarball and ensure quay is setup.

```
docker export <tarball_name>
docker import <tarball_name>
docker push <quay.io>
```



# Migrating Nessus Configs

In order to preserve pre-existing enterprise configurations, export the required data from an already running (not containerized) Nessus scanner implementations.


### Backup


To backup your existing Nessus (not containerized) please do the following: 

1. As root #service nessusd stop
2. You will need to backup /opt/nessus (this is done as a precaution).
3. As root #service nessusd start


### Important configuration files you need

In order to get the data you need into you Docker image for the Nessus data volume, the following ocnfiguration files need to be put into a tarball for import.

1) Remember to stop the nessus service

a. In /opt/nessus/var/nessus, tarball the following:

1. /users folder
2. policies.db
3. Master.key
4. Global.db
5. global.db-wal
6. global.db-shm

b. In /opt/nessus/etc/nessus tarball the following (these may be the only files in this directory):

1. nessus-fetch.db
2. nessusd.db
3. nessusd.conf.imported
4. nessusd.rules

c. In /opt/nessus/sbin tarball the following (these may be the only files in the directory):

1. nessuscli
2. nessusd
3. nessus-service
4. nessus-check-signature

You can also refer to below guides for Nessus 6.4.X :

[Nessus User Guide](https://static.tenable.com/documentation/nessus_6.4_user_guide.pd)

[Nessus CLI Reference](https://static.tenable.com/documentation/nessus_6.4_command_line_reference.pdf)

### Docker data volume

Untar the files (preserving the file paths) into the sometheycallme/docker-nessus/nessus-data folder.


Then Add the following to the Dockerfile in the sometheycallme/docker-nessus/nessus-data folder

ONBUILD COPY . /
