FROM ros:humble-ros-base

# Update and upgrade
RUN apt update
RUN apt upgrade -y

# Add tytools (as root)
RUN mkdir -p -m0755 /etc/apt/keyrings
RUN apt install -y curl wget unzip
RUN curl https://download.koromix.dev/debian/koromix-archive-keyring.gpg -o /etc/apt/keyrings/koromix-archive-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/koromix-archive-keyring.gpg] https://download.koromix.dev/debian stable main" > /etc/apt/sources.list.d/koromix.dev-stable.list
RUN apt update
RUN apt install -y tytools

# Set up a new user
RUN useradd -ms /bin/bash frostlab
RUN usermod -aG sudo frostlab
RUN echo 'frostlab:frostlab' | chpasswd
USER frostlab
WORKDIR /home/frostlab

# Install Eigen
RUN wget -O Eigen.zip https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip
RUN unzip Eigen.zip

USER root
RUN cp -r eigen-3.4.0/Eigen /usr/local/include
USER frostlab

RUN rm Eigen.zip

# Build and install gtsam (from source)
USER root
RUN apt install -y libboost-all-dev python3-pip
USER frostlab

RUN python3 -m pip install -U mypy
RUN git clone https://github.com/borglab/gtsam.git
RUN mkdir /home/frostlab/gtsam/build

WORKDIR /home/frostlab/gtsam/build
RUN cmake .. -DGTSAM_BUILD_PYTHON=1 -DGTSAM_PYTHON_VERSION=3.10.12
RUN make python-install
WORKDIR /home/frostlab

# Install PlatformIO
USER root
RUN apt install -y python3-venv
USER frostlab

RUN curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
RUN python3 get-platformio.py
RUN rm get-platformio.py

# Set up PlatformIO shell commands
RUN mkdir -p /usr/local/bin

USER root
RUN ln -s /home/frostlab/.platformio/penv/bin/platformio /usr/local/bin/platformio
RUN ln -s /home/frostlab/.platformio/penv/bin/pio /usr/local/bin/pio
RUN ln -s /home/frostlab/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb
USER frostlab

# Set up ROS sourcing
RUN echo "source /opt/ros/humble/setup.bash" >> /home/frostlab/.bashrc

# Install the micro-ROS agent
RUN mkdir microros_ws

WORKDIR /home/frostlab/microros_ws
RUN git clone -b humble https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup
RUN rosdep update

USER root
RUN rosdep install --from-paths src --ignore-src -y
USER frostlab

SHELL ["/bin/bash", "-c"] 
RUN source /opt/ros/humble/setup.bash && colcon build
RUN source /opt/ros/humble/setup.bash && source install/setup.bash && ros2 run micro_ros_setup create_agent_ws.sh
RUN source /opt/ros/humble/setup.bash && source install/setup.bash && ros2 run micro_ros_setup build_agent.sh
SHELL ["/bin/sh", "-c"]

WORKDIR /home/frostlab

# Install MOOS-IvP
USER root
RUN apt install -y cmake xterm subversion libfltk1.3-dev libtiff5-dev
USER frostlab

RUN svn co https://oceanai.mit.edu/svn/moos-ivp-aro/trunk moos-ivp

WORKDIR /home/frostlab/moos-ivp
RUN ./build-moos.sh
RUN ./build-ivp.sh
WORKDIR /home/frostlab

RUN export PATH=$PATH:/home/frostlab/moos-ivp/bin

# Install general dependencies
USER root
RUN apt install -y vim psmisc network-manager systemd libgps-dev python3-libgpiod
USER frostlab

# Update and upgrade
USER root
RUN apt update
RUN apt upgrade -y
USER frostlab

# Initialize the GPIO pins on start
CMD ["bash","/home/frostlab/teensy_ws/init.sh"]
