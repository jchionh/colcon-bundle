FROM ros:kinetic

SHELL ["/bin/bash", "-c"]

RUN echo "yaml https://s3-us-west-2.amazonaws.com/rosdep/base.yaml" > /etc/ros/rosdep/sources.list.d/19-aws-sdk.list

COPY . /opt/package
WORKDIR /opt/package

RUN apt-get update && \
	apt-get install -y python3-pip python3-apt python-pip

RUN	rosdep update && \
	rosdep install --from-paths integration/test_workspace --ignore-src -r -y

RUN pip3 install --upgrade pip setuptools
RUN pip3 install -U colcon-common-extensions
RUN pip3 install .
RUN pip3 install colcon-ros-bundle

WORKDIR /opt/package/integration/test_workspace
RUN source /opt/ros/kinetic/setup.sh; colcon build
RUN source /opt/ros/kinetic/setup.sh; colcon bundle --bundle-version 1 --bundle-base v1
RUN source /opt/ros/kinetic/setup.sh; colcon bundle --bundle-version 2 --bundle-base v2


