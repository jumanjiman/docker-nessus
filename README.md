# docker-nessus
[![](https://badge.imagelayers.io/sometheycallme/docker-nessus.svg)](https://imagelayers.io/?images=cleanerbot/docker-nessus:latest 'View image size and layers')&nbsp;
[![Circle CI](https://circleci.com/gh/cleanerbot/docker-nessus.png?circle-token=5d84cd337864c33f062f57aafd2854771777759d)](https://circleci.com/gh/sometheycallme/docker-nessus/tree/master 'View CI builds')

Project URL: https://github.com/cleanerbot/docker-nessus

Docker registry: https://registry.hub.docker.com/u/sometheycallme/docker-nessus


# Procedures

<i>updated 20151014</i>

### Intro

Docker Nessus runs with the Nessus daemon as an image, and Nessus data ```/opt/nessus``` in a separate data image.

In order to preserve the certificate chaining in the data-volume, you need to build the nessus-data file locally.

### Build Steps

<b>1) Clone the [docker-nessus](https://github.com/cleanerbot/docker-nessus) from github locally</b>

```git clone git@github.com:cleanerbot/docker-nessus.git```

<b>2) Pull the [docker-nessus](https://hub.docker.com/r/sometheycallme/docker-nessus) image</b>

```docker pull sometheycallme/docker-nessus```

Check that the image is there:

```docker images```

Create the image, but don't run it - the data is needed locally.

```docker create --name nessus-unlicensed sometheycallme/docker-nessus:latest true```

Check it.  You should see something like this:

```shell
[root@localhost docker-nessus]# docker create --name nessus-unlicensed sometheycallme/docker-nessus:latest true
5843be44065dcd0bb8f295a8dc19e1fb94c2989ad8d8c27c4912f6cbf9449a20


[root@localhost docker-nessus]# docker ps -a
CONTAINER ID        IMAGE                                      COMMAND             CREATED             STATUS              PORTS               NAMES
5843be44065d        sometheycallme/docker-nessus:latest   "true"              23 seconds ago                                              nessus-unlicensed   
[root@localhost docker-nessus]#
```

<b>3) Copy the needed configuration items and create the volume</b>

```shell

# go into the local repo
cd docker-nessus

# go into the nessus data volume
cd nessus-data

# copy over needed CI's from the created image
# provide the container ID from docker ps -a output

docker cp 5843be44065d:/opt/nessus/sbin .
docker cp 5843be44065d:/opt/nessus/var .
docker cp 5843be44065d:/opt/nessus/etc .

# build the docker data image locally (preserving the cert chain)
docker build -t nessus-unlicensed-data .

# you will see "Sending build context to Docker daemon <snip>" 
# and other build artifacts
# check the images

docker images

# find and remove the docker container ID created to copy data

docker ps -a
docker rm 5843be44065d

# create the new image with data copied over from nessusd.

docker create --name nessus-unlicensed-data nessus-unlicensed-data true
```

<b>4)Build Nessus Unlicensed - with a separate volume</b>

```shell

# provide a unique unicast mac-address and remember it

docker run -d --name nessus-unlicensed -p 8834:8834 --mac-address 02:42:ac:11:00:01 --volumes-from nessus-unlicensed-data sometheycallme/docker-nessus

# check to see it's running

[root@localhost docker-nessus]# docker ps
CONTAINER ID        IMAGE                                 COMMAND                CREATED             STATUS              PORTS                    NAMES
26dd094c2228        sometheycallme/docker-nessus:latest   "/opt/nessus/sbin/ne   12 minutes ago      Up 12 minutes       0.0.0.0:8834->8834/tcp   nessus-unlicensed 

```


### Licensing Steps and saving the build

<b>5) Add the license to the running nessus-unlicensed container</b>

You can use the [Nessus CLI](http://static.tenable.com/documentation/nessus_v6_command_line_reference.pdf) for offline registration or simply provide the unique key in the Web UI after Nessus starts.  

We used the Web UI.  (https://<yournessushost>:8834)

Either way you will need to register.


<b>6) Stop the container and commit the changes </b>

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

<b>7) Run the newly created container</b>

Suppliy the SAME unique unicast mac-address for that you supplied in step 2.  For example, we used ```02:42:ac:11:00:01``` for our procedures.

```docker run -d --name nessus-unlicensed -p 8834:8834 --mac-address 02:42:ac:11:00:01 --volumes-from nessus-data sometheycallme/docker-nessus```



## Existing Nessus installations

These procedures cover the data necessary to migrate existing nessus configurations into the data volume, similar to the procedures outlined above.


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



