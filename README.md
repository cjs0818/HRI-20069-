# HRI-20069: Introduction to S/W developmental tools & perception technologies 

Linux Laptop required!!!

# Week 1: S/W Developmental Framework Setup

## [1] Docker

### [1-1] Install Docker CE (Community Edition)

Refer to https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce  

#### Set up the repository

  1. Update the apt package index:
```
    $ sudo apt-get update
```
    
  2. Install packages to allow apt to use a repository over HTTPS:
```
    $ sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
```

  3. Add Docker’s official GPG key:
```
    $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

  4. Use the following command to set up the stable repository. 
    * In case of x86_64/amd64 CPU,
```
    $ sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
```
   * For other CPU, refer to https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce

#### Install Docker CE

  1. Update the apt package index.
```
    $ sudo apt-get update
```

  2. Install the latest version of Docker CE, or go to the next step to install a specific version. Any existing installation of Docker is replaced.
```
    $ sudo apt-get install docker-ce
```

  3. Verify that Docker CE is installed correctly by running the hello-world image.
```
    $ sudo docker run hello-world
```

  4. The scripts require root or sudo privileges to run. So, for convenience, you'd better add $USER to the docker group and reboot.
```
    $ sudo groupadd docker  # Maybe already exist
    $ sudo usermod -aG docker $USER
```
  5. Configure Docker to start on boot
```
    $ sudo systemctl enable docker
```

  6. Sign up for Docker (https://cloud.docker.com/) and login.
```
    $ docker login
```

### [1-2] Practice Docker
#### Define a container with Dockerfile
Create an empty directory. Change directories (cd) into the new directory, create a file called Dockerfile, copy-and-paste the following content into that file, and save it. 
```
    # Use an official Python runtime as a parent image
    $ FROM python:2.7-slim

    # Set the working directory to /app
    $ WORKDIR /app

    # Copy the current directory contents into the container at /app
    $ ADD . /app

    # Install any needed packages specified in requirements.txt
    $ RUN pip install --trusted-host pypi.python.org -r requirements.txt

    # Make port 80 available to the world outside this container
    $ EXPOSE 80

    # Define environment variable
    $ ENV NAME World

    # Run app.py when the container launches
    $ CMD ["python", "app.py"]
```
#### The app itself
Create two more files, requirements.txt and app.py, and put them in the same folder with the Dockerfile.
    
  * requirements.txt
```
    Flask
    Redis
```
    
  * app.py
    
```
    from flask import Flask
    from redis import Redis, RedisError
    import os
    import socket

    # Connect to Redis
    redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

    app = Flask(__name__)

    @app.route("/")
    def hello():
        try:
            visits = redis.incr("counter")
        except RedisError:
            visits = "<i>cannot connect to Redis, counter disabled</i>"

        html = "<h3>Hello {name}!</h3>" \
               "<b>Hostname:</b> {hostname}<br/>" \
               "<b>Visits:</b> {visits}"
        return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

    if __name__ == "__main__":
        app.run(host='0.0.0.0', port=80)
``` 

#### Build the app

We are ready to build the app. Make sure you are still at the top level of your new directory. Here’s what ls should show:
```
    $ ls
    Dockerfile		app.py			requirements.txt
```

Now run the build command. This creates a Docker image, which we’re going to tag using -t so it has a friendly name.
```
    docker build -t friendlyhello .
```

Where is your built image? It’s in your machine’s local Docker image registry:
```
    $ docker images

    REPOSITORY            TAG                 IMAGE ID
    friendlyhello         latest              326387cea398
```

#### Run the app

Run the app, mapping your machine’s port 4000 to the container’s published port 80 using -p:
```
    docker run -p 4000:80 friendlyhello
```

You should see a message that Python is serving your app at http://0.0.0.0:80. But that message is coming from inside the container, which doesn’t know you mapped port 80 of that container to 4000, making the correct URL http://localhost:4000.

Go to that URL in a web browser to see the display content served up on a web page.

![pic001](./assets/images/app-in-browser.png)

Now let’s run the app in the background, in detached mode:
```
    docker run -d -p 4000:80 friendlyhello
```

You get the long container ID for your app and then are kicked back to your terminal. Your container is running in the background. You can also see the abbreviated container ID with docker container ls (and both work interchangeably when running commands):
```
    $ docker container ls
    CONTAINER ID        IMAGE               COMMAND             CREATED
    1fa4ab2cf395        friendlyhello       "python app.py"     28 seconds ago
```

#### Recap & further study
Here is a list of the basic Docker commands from this page, and some related ones if you’d like to explore a bit before moving on.
```
    $ docker build -t friendlyhello .  # Create image using this directory's Dockerfile
    $ docker run -p 4000:80 friendlyhello  # Run "friendlyname" mapping port 4000 to 80
    $ docker run -d -p 4000:80 friendlyhello         # Same thing, but in detached mode
    $ docker container ls                                # List all running containers
    $ docker container ls -a             # List all containers, even those not running
    $ docker container stop <hash>           # Gracefully stop the specified container
    $ docker container kill <hash>         # Force shutdown of the specified container
    $ docker container rm <hash>        # Remove specified container from this machine
    $ docker container rm $(docker container ls -a -q)         # Remove all containers
    $ docker images                                  # List all images on this machine
    $ docker image ls -a                             # List all images on this machine
    $ docker image rm <image id>            # Remove specified image from this machine
    $ docker image rm $(docker image ls -a -q)   # Remove all images from this machine
    $ docker login             # Log in this CLI session using your Docker credentials
    $ docker tag <image> username/repository:tag  # Tag <image> for upload to registry
    $ docker push username/repository:tag            # Upload tagged image to registry
    $ docker run username/repository:tag                   # Run image from a registry
```
## [2] RoS using Docker
Use "docker pull <image_file>" or build a container using Dockerfile

### [2-1] Pull a pre-built RoS image using "docker pull"
Official docker hub site for RoS
  * https://hub.docker.com/_/ros/

Docker pull
```
    $ docker pull ros
```

Then, you can see the docker ros image by 
```
    $ docker images
```
or by
```
    $ docker image ls -a   # List all images on this machine
```
like
```
  REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
  ros                 latest              a674644c9bd3        4 weeks ago         1.18GB
```

Docker run
```
    $ docker run -it --rm --name ros_latest ros:latest /bin/bash
```

### [2-2] Build your own RoS image using Dockerfile
```
    #--------------------
    FROM ubuntu:16.04
    #--------------------

    #-------------------
    #  RoS

    # install packages
    RUN apt-get update && apt-get install -y --no-install-recommends \
        dirmngr \
        gnupg2 \
        && rm -rf /var/lib/apt/lists/*

    # setup keys
    RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

    # setup sources.list
    RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

    # install bootstrap tools
    RUN apt-get update && apt-get install --no-install-recommends -y \
        python-rosdep \
        python-rosinstall \
        python-vcstools \
        && rm -rf /var/lib/apt/lists/*

    # setup environment
    ENV LANG C.UTF-8
    ENV LC_ALL C.UTF-8

    # bootstrap rosdep
    RUN rosdep init \
        && rosdep update

    # install ros packages
    ENV ROS_DISTRO kinetic
    RUN apt-get update && apt-get install -y \
        ros-kinetic-ros-core=1.3.1-0* \
        && rm -rf /var/lib/apt/lists/*

    # setup entrypoint
    COPY ./ros_entrypoint.sh /

    ENTRYPOINT ["/ros_entrypoint.sh"]
    CMD ["bash"]

    #FROM ros:kinetic-ros-core-xenial

    RUN apt-get update && apt-get install -y \
        ros-kinetic-ros-base=1.3.1-0* \
        ros-kinetic-robot=1.3.1-0* \
        ros-kinetic-desktop=1.3.1-0* \
        ros-kinetic-desktop-full=1.3.1-0* \
        && rm -rf /var/lib/apt/lists/*

    #-------------------

    # install utilities
    RUN apt-get update && apt-get install -y \
        terminator \
        && rm -rf /var/lib/apt/lists/*

    #RUN apt-get update && apt-get install -y \
    #    wget \
    #    x11-apps \
    #    && rm -rf /var/lib/apt/lists/*

    # generate /root/work directory
    WORKDIR /root/work
```

### [2-3] Shell files for docker build & docker run
Generate a file named install_build.sh 
```
    docker build -t hri/ros:kinetic-desktop-full .
```
You should not forget to do
```
    chmod 755 install_build.sh
```

Generate a file named start.sh fiel
```
    IMAGE_ID=hri/ros:kinetic-desktop-full
    NAME_ID=hri_ros_kinetic_desktopfull

    docker run -it --rm \
    --name $NAME_ID \
    $IMAGE_ID \
    /bin/bash
```

You should not forget to do
```
    chmod 755 start.sh
```

Then, execute
```
    $ ./install_build.sh
    $ ./start.sh
```

And check out ros-related commands such as roscore
```
    # roscore
```

### [2-4] Folder sharing
```
    IMAGE_ID=hri/ros:kinetic-desktop-full
    NAME_ID=hri_ros_kinetic_desktopfull
    WORKDIR=/home/jschoi/work/HRI-20069

    docker run -it --rm \
      --name $NAME_ID \
      $IMAGE_ID \
      /bin/bash
```

### [2-5] Enable X-window

The start.sh file needs to be modified as 
```
    IMAGE_ID=hri/ros:kinetic-desktop-full
    NAME_ID=hri_ros_kinetic_desktopfull
    WORKDIR=/home/jschoi/work/HRI-20069
    XSOCK=/tmp/.X11-unix

    xhost +

    docker run -it --rm \
      --env "DISPLAY" \
      --volume $XSOCK:$XSOCK:rw \
      --volume $WORKDIR:/root/work:rw \
      --name $NAME_ID \
      $IMAGE_ID \
      /bin/bash
```

Note that in OSX, --env "DISPLAY" should be changed like 
```
    EN0=en0    # It should be selected according your system (check with ifconfig)
    DISLAY_IP=$(ifconfig $EN0 | grep inet | awk '$1=="inet" {print $2}')
    
    ...
    --env DISPLAY=$DISPLAY_IP:0  # for OSX
    ...
```


## [3] Git
### Install git & sign up for github.com
In Ubuntu 16.04, git is already included, but for the other OS please refer to https://git-scm.com

* git configure

```
    $ git config --global user.email "you@example.com”  
    $ git config --global user.name "Your Name"
    
    $ git config --global push.default simple
    $ git config --global core.editor vi           # Using vi editor for git`
```
