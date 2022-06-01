# Task 2
Please provide a Dockerfile and supporting files to build a docker image.

* The image should contain a webserver to serve static files that will be hosted in /opt/html.

Internally, the container should run as a non-root user.

* Curl should also be installed in the container for testing purposes.

* The exposed port should be configurable and should be passed to the container at runtime.

* Extra points for providing a means of starting and stopping the container.

## Solution

The static website is deployed in a docker container using an NGINX webserver. All required files are placed in the `task2` directory. A non-root user, `www-tmh`, runs the container.

Before testing, make sure you have already installed `Docker Engine`, `Docker Compose`, and `Make` on your Linux system. 

The `web` service is defined in the `docker-compose.yml`. It uses an image that is built from the `Dockerfile` in the task directory. Then, it binds the container and the host machine to the exposed ports passed at runtime. You can change the host and container port in the `.env` file: 
```
#Container port 
CPORT=2022

#Host port
HPORT=8080
``` 
To simplify the interaction with the container, a `makefile` has been created with a set of basic commands.
* Build the container image using `make build`
* Creat and run the container in the detached mode using `make up`
* Stop the container using `make stop`
* Start a stopped container using `make start`
* List the running container using `make ps`
* Start a Shell session in the container using `make shell` and finish the Shell process in the container using `exit`
* Stop and remove the container using `make down`
* Stop and remove the container and the image using `make destroy` 

## Test

To start the system in detached mode use 
```console
task2$ make up
```

Then, enter `localhost:<HPORT>` in a browser to check the static web page or you could use the command-line tool `curl localhost:<HPORT>`. If you keep the default value for the published host port then  
```console 
task2$ curl localhost:8080
``` 
should return the following:
```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>The Mobility House</title>
</head>
<body>

  <h1>TMH Homework</h1>
  <h2> Task 2 </h2>

  <p>A static website is deployed in a Docker container using an NGINX webserver.</p>

</body>
</html>
``` 

Then, clean up using 
```console
task2$ make destroy
```

## Alternative ways to interact with the container

1. Using `docker-compose`
    * Create and start the container with `docker-compose up -d` 
    * Bring everything down, removing the container and the built image using `docker-compose down --rmi all`
    * Start a Shell process in the container  `docker-compose exec web /bin/sh`

2. Using `docker`
    * Build the container image `docker build -t web:v1 .`
    * Start the container and pass container port with the -e flag `docker run -d -e CPORT=2022 -p 8080:2022 --name webserver web:v1`
    * Start a Shell process in the container  `docker exec -it webserver /bin/sh`
    * Stop the container `docker stop webserver`
    * Start a stopped container `docker start webserver`
    * Remove a stopped container `docker rm webserver`
    * Remove the built image `docker rmi web:v1`
