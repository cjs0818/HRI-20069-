IMAGE_ID=hri/ros:ros-tutorials
NAME_ID=master


XSOCK=/tmp/.X11-unix

xhost +

docker run -it --rm \
  --env "DISPLAY" \
  --volume $XSOCK:$XSOCK:rw \
  --net foo \
  --name $NAME_ID \
  $IMAGE_ID \
  roscore


#EN0=enp0s5
#DISPLAY_IP=$(ifconfig $EN0 | grep inet | awk '$1=="inet" {print $2}')
#  --env="QT_X11_NO_MITSHM=1" \
#  --env LIBGL_ALWAYS_INDIRECT=1 \

#  --volume $WORKDIR:/root/work:rw \
