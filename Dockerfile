# This is a Dockerfile for ros:ros-tutorials
FROM ros:indigo-ros-base

ENV ROS_DISTRO indigo

# install ros tutorials packages
RUN apt-get update && apt-get install -y \
    ros-indigo-ros-tutorials \
    ros-indigo-common-tutorials \
    && rm -rf /var/lib/apt/lists/*
