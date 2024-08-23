FROM ros:humble-ros-base

# Update and upgrade
RUN apt update
RUN apt upgrade -y

# Add tytools repository (as root)
RUN mkdir -p -m0755 /etc/apt/keyrings
RUN apt install -y curl wget unzip
RUN curl https://download.koromix.dev/debian/koromix-archive-keyring.gpg -o /etc/apt/keyrings/koromix-archive-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/koromix-archive-keyring.gpg] https://download.koromix.dev/debian stable main" > sudo /etc/apt/sources.list.d/koromix.dev-stable.list

# Set up a new user
RUN useradd -ms /bin/bash frostlab
RUN usermod -aG sudo frostlab
RUN echo 'frostlab:frostlab' | chpasswd
USER frostlab
WORKDIR /home/frostlab

# Set up ROS environment
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Install general dependencies
USER root
RUN apt install -y tytools vim libgps-dev libboost-all-dev python3-pip
USER frostlab

RUN pip install gpiod

# Install PlatformIO
USER root
RUN apt install -y python3-venv
USER frostlab

RUN curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
RUN python3 get-platformio.py

# Set up PlatformIO shell commands
RUN mkdir -p /usr/local/bin

USER root
RUN ln -s /home/frostlab/.platformio/penv/bin/platformio /usr/local/bin/platformio
RUN ln -s /home/frostlab/.platformio/penv/bin/pio /usr/local/bin/pio
RUN ln -s /home/frostlab/.platformio/penv/bin/piodebuggdb /usr/local/bin/piodebuggdb
USER frostlab

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

# Install Eigen
RUN wget -O Eigen.zip https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip
RUN unzip Eigen.zip

USER root
RUN cp -r eigen-3.4.0/Eigen /usr/local/include
USER frostlab

# Build and install gtsam (from source)
RUN git clone https://github.com/borglab/gtsam.git
RUN mkdir /home/frostlab/gtsam/build

WORKDIR /home/frostlab/gtsam/build
RUN cmake .. -DGTSAM_BUILD_PYTHON=1 -DGTSAM_PYTHON_VERSION=3.10.12
RUN make python-install
WORKDIR /home/frostlab
