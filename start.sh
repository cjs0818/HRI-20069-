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


#EN0=enp0s5
#DISPLAY_IP=$(ifconfig $EN0 | grep inet | awk '$1=="inet" {print $2}')
#  --env="QT_X11_NO_MITSHM=1" \
#  --env LIBGL_ALWAYS_INDIRECT=1 \
