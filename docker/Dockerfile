FROM ros:humble-ros-base

# Check architecture
ARG TARGETARCH

# Update and upgrade
RUN apt update && apt upgrade -y

# Add tytools (as root)
RUN mkdir -p -m0755 /etc/apt/keyrings
RUN apt update && apt install -y curl \
    wget \
    unzip
RUN curl https://download.koromix.dev/debian/koromix-archive-keyring.gpg -o /etc/apt/keyrings/koromix-archive-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/koromix-archive-keyring.gpg] https://download.koromix.dev/debian stable main" > /etc/apt/sources.list.d/koromix.dev-stable.list
RUN apt update && install -y tytools

# Set up a new user
RUN useradd -ms /bin/bash frostlab
RUN usermod -aG sudo frostlab
RUN usermod -aG dialout frostlab
RUN echo 'frostlab:frostlab' | chpasswd
USER frostlab
WORKDIR /home/frostlab

# Build and install gtsam (from source)
USER root
RUN apt update && apt install -y \
    libboost-all-dev \
    python3-pip
USER frostlab

RUN git clone --depth 1 --branch 4.2 https://github.com/borglab/gtsam.git
RUN mkdir /home/frostlab/gtsam/build

WORKDIR /home/frostlab/gtsam/build
RUN cmake .. -DGTSAM_BUILD_PYTHON=ON -DGTSAM_PYTHON_VERSION=3.10.12
RUN make python-install
WORKDIR /home/frostlab

RUN rm -r gtsam

# Install Eigen
RUN wget -O Eigen.zip https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip
RUN unzip Eigen.zip

USER root
RUN cp -r eigen-3.4.0/Eigen /usr/local/include
RUN rm -r eigen-3.4.0
USER frostlab

RUN rm Eigen.zip

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
RUN apt install -y cmake \
    xterm \
    subversion \
    libfltk1.3-dev \
    libtiff5-dev
USER frostlab

RUN svn co https://oceanai.mit.edu/svn/moos-ivp-aro/trunk moos-ivp

WORKDIR /home/frostlab/moos-ivp
RUN ./build-moos.sh
RUN ./build-ivp.sh
WORKDIR /home/frostlab

RUN echo "export PATH=$PATH:/home/frostlab/moos-ivp/bin" >> /home/frostlab/.bashrc

# Set up GUI visibility (matplotlib, rqt) if building the development image
USER root
RUN if [ "$TARGETARCH" = "amd64" ]; then \
    apt update && apt install -y \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxrandr-dev \
    qtbase5-dev \
    libqt5x11extras5 \
    python3-gi \
    gir1.2-gtk-3.0 \
    x11-apps \
    ros-humble-rqt* \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*; \
    fi
USER frostlab

RUN if [ "$TARGETARCH" = "amd64" ]; then \
    pip3 install --no-cache-dir PyQt5; \
    fi

# Install general dependencies
USER root
RUN apt update && apt install -y \
    vim \
    psmisc \
    network-manager \
    systemd \
    libgps-dev \
    python3-libgpiod \
    ros-humble-rosbag2-storage-mcap \
    netcat-openbsd
USER frostlab

RUN pip3 install numpy==1.26.0 \
    scipy \
    matplotlib \
    pyproj
RUN echo "export PATH=$PATH:/home/frostlab/.local/bin" >> /home/frostlab/.bashrc

# Update and upgrade
USER root
RUN apt update && apt upgrade -y
USER frostlab

# Add the GPIO init script to the ros entrypoint
USER root
RUN echo "bash /home/frostlab/teensy_ws/init.sh" >> /ros_entrypoint.sh
USER frostlab
