Procedures for Nessus 7.0.2

First, I downloaded the latest RPM, created a new folder to hold the rpm in the repo.

### step 1

<img width="284" alt="screen shot 2018-03-01 at 8 11 24 pm" src="https://user-images.githubusercontent.com/630113/36878401-d22806f2-1d8c-11e8-8a1b-c0efe47f9c3c.png">

adjusted the dockerfile to point to the new image.
```
COPY Nessus-7.0.2/Nessus-7.0.2-es5.x86_64.rpm /tmp/
# run the yum install twice as workaround for rpmdb checksum error with overlayfs
RUN (yum -y --nogpgcheck localinstall /tmp/Nessus-7.0.2-es5.x86_64.rpm || \
    yum -y --nogpgcheck localinstall /tmp/Nessus-7.0.2-es5.x86_64.rpm) && \
    yum clean all
```

### step 2

 I build the image locally.

```
cd ~/docker-nessus
docker build -t nessus-unlicensed .

### after it does it's build, check
docker images
nessus-unlicensed              latest              cc7c533368c4        12 hours ago        730MB
```

### step 3

 I run the image and license it via the GUI.

```
docker run -d --name nessus7 -p 8834:8834 --mac-address 02:42:ac:11:00:01  nessus-unlicensed
```
go to https://127.0.0.1:8834

### step 4

Put in your license key and create an account

<img width="763" alt="screen shot 2018-03-01 at 8 23 46 am" src="https://user-images.githubusercontent.com/630113/36878577-9a5384c6-1d8d-11e8-9cca-e54d678f33b4.png">

<img width="455" alt="screen shot 2018-03-01 at 8 24 03 am" src="https://user-images.githubusercontent.com/630113/36878574-96e1235c-1d8d-11e8-9f65-bfe20c402ae1.png">

<img width="520" alt="screen shot 2018-03-01 at 8 25 38 am" src="https://user-images.githubusercontent.com/630113/36878619-d508bc08-1d8d-11e8-95d3-c7499ffcd6ab.png">

### step 5

preserve the image data and now that it is licensed properly in /nessus-data

```
docker stop nessus7
docker commit nessus7 nessus-licensed
```

Notice unlicensed vs. licensed image sizes.

<img width="819" alt="screen shot 2018-03-02 at 6 37 15 pm" src="https://user-images.githubusercontent.com/630113/36927020-df49070c-1e48-11e8-9712-9e28041e5365.png">

In this procedure, we call it nessus-unlicensed.  In my local images I just called it nessus.


```
cd nessus-data
docker cp nessus-licensed:/opt/nessus/sbin .
docker cp nessus-licensed:/opt/nessus/sbin .
```

### step 6

now that we have the data, create the nessus-licensed-data image

```
docker build -t nessus-licensed-data .
```

### step 7

Run the newly created nessus7 image with ```--volumes-from nessus-licensed-data```


```
docker create --name nessus-licensed-data nessus-licensed-data true
docker run -d --name nessus72 -p 8834:8834 --mac-address 02:42:ac:11:00:01  --volumes-from nessus-licensed-data nessus7
```
	
Works to preserve the data needed for ```--volumes-from nessus-licensed-data```

<img width="444" alt="screen shot 2018-03-01 at 8 32 11 pm" src="https://user-images.githubusercontent.com/630113/36879015-aa5f1be4-1d8f-11e8-9058-4471d92a17ed.png">


<img width="1427" alt="screen shot 2018-03-01 at 8 32 56 am" src="https://user-images.githubusercontent.com/630113/36879004-972a59a8-1d8f-11e8-8ce0-1d3e90f2beed.png">
