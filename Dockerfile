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
RUN usermod -aG dialout frostlab
RUN groupadd custom
RUN chown :custom /dev
RUN usermod -aG custom root
RUN usermod -aG custom frostlab
RUN echo 'frostlab:frostlab' | chpasswd
USER frostlab
WORKDIR /home/frostlab

# Build and install gtsam (from source)
USER root
RUN apt install -y libboost-all-dev python3-pip
USER frostlab

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

# Install the micro-ROS agent
RUN mkdir microros_ws

WORKDIR /home/frostlab/microros_ws
RUN git clone -b humble https://github.com/micro-ROS/micro_ros_setup.git src/micro_ros_setup
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -y
RUN colcon build
RUN source install/local_setup.bash
RUN ros2 run micro_ros_setup build_agent.sh
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
RUN apt install -y vim psmisc nmcli systemd libgps-dev python3-libgpiod
USER frostlab

# Update and upgrade
USER root
RUN apt update
RUN apt upgrade -y
USER frostlab
