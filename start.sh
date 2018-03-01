IMAGE_ID=hri/ros:kinetic-desktop-full
NAME_ID=hri_ros_kinetic_desktopfull
WORKDIR=/home/jschoi/work/HRI-20069


docker run -it --rm \
  --volume $WORKDIR:/root/work:rw \
  --name $NAME_ID \
  $IMAGE_ID \
  /bin/bash

