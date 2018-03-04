Step by step procedures for building and testing out a Nessus.

### step 1

Clone project down locally

```
git clone git@github.com:cleanerbot/docker-nessus.git

docker pull sometheycallme/docker-nessus 
```

<img width="875" alt="screen shot 2018-03-04 at 1 27 54 pm" src="https://user-images.githubusercontent.com/630113/36948962-339c4d6a-1fb0-11e8-9219-8944428a63f7.png">


### step 2

Run the image locally and name it nessus-unlicensed.

```
docker run -d --name nessus-unlicensed -p 8834:8834 --mac-address 02:42:ac:11:00:01 sometheycallme/docker-nessus
```

### step 3

Go to https://127.0.0.1:8834 and license it.

<img width="763" alt="screen shot 2018-03-01 at 8 23 46 am" src="https://user-images.githubusercontent.com/630113/36878577-9a5384c6-1d8d-11e8-9cca-e54d678f33b4.png">

<img width="455" alt="screen shot 2018-03-01 at 8 24 03 am" src="https://user-images.githubusercontent.com/630113/36878574-96e1235c-1d8d-11e8-9f65-bfe20c402ae1.png">

<img width="520" alt="screen shot 2018-03-01 at 8 25 38 am" src="https://user-images.githubusercontent.com/630113/36878619-d508bc08-1d8d-11e8-95d3-c7499ffcd6ab.png">

### step 4

preserve the image data and now that it is licensed properly in /nessus-data

```
docker stop nessus-unlicensed

docker commit nessus-unlicensed nessus-licensed
```

Notice licensed image size is much larger.

<img width="384" alt="screen shot 2018-03-04 at 1 26 32 pm" src="https://user-images.githubusercontent.com/630113/36948971-5172ff5a-1fb0-11e8-9894-e82662191542.png">


### step 5

copy data from the newly created ```nessus-licensed``` for the ```nessus-licensed-data image```


```
cd nessus-data
docker cp nessus-licensed:/opt/nessus/sbin .
docker cp nessus-licensed:/opt/nessus/var .
docker cp nessus-licensed:/opt/nessus/etc .
```

### step 6

now that we have the data, create the nessus-licensed-data image

```
docker build -t nessus-licensed-data .
```

### step 7

Run the newly created image with ```--volumes-from nessus-licensed-data```


```
docker create --name nessus-licensed-data nessus-licensed-data true
docker run -d --name nessus702 -p 8834:8834 --mac-address 02:42:ac:11:00:01  --volumes-from nessus-licensed-data sometheycallme/docker-nessus
```
	
Works to preserve the data needed for ```--volumes-from nessus-licensed-data```

<img width="444" alt="screen shot 2018-03-01 at 8 32 11 pm" src="https://user-images.githubusercontent.com/630113/36879015-aa5f1be4-1d8f-11e8-9058-4471d92a17ed.png">


<img width="1427" alt="screen shot 2018-03-01 at 8 32 56 am" src="https://user-images.githubusercontent.com/630113/36879004-972a59a8-1d8f-11e8-8ce0-1d3e90f2beed.png">
