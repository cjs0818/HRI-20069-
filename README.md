# HRI-20069-

## [1] Prepare Linux Laptop

## [2] Install Docker CE (Community Edition)

Refer to https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce  

### Set up the repository

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

### Install Docker CE

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

## [3] Practice Docker
### Dockerfile 
```
    
```
