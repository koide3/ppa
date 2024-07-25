# PPA

## Precaution

You have to be aware of the risk of installing software from PPA that implies trusting the author.

## Setup PPA

### Prerequiresite

```bash
sudo apt install curl gpg
```

### Setup PPA

```bash
# Choose one of the follows

# Automatically select ubuntu version via online script
curl -s https://koide3.github.io/ppa/setup_ppa.sh | sudo bash

# Manually setup PPA for Ubuntu 24.04
curl -s --compressed "https://koide3.github.io/ppa/ubuntu2404/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/ubuntu2404 ./" | sudo tee /etc/apt/sources.list.d/koide3_ppa.list

# Manually setup PPA for Ubuntu 22.04
curl -s --compressed "https://koide3.github.io/ppa/ubuntu2204/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/ubuntu2204 ./" | sudo tee /etc/apt/sources.list.d/koide3_ppa.list

# Manually setup PPA for Ubuntu 20.04
curl -s --compressed "https://koide3.github.io/ppa/ubuntu2004/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/ubuntu2004 ./" | sudo tee /etc/apt/sources.list.d/koide3_ppa.list
```

## Install packages

### Iridescence

```bash
sudo apt update
sudo apt install -y libiridescence-dev
```

### GTSAM

- GTSAM tag : 4.2a9
- GTSAM_WITH_TBB=OFF
- GTSAM_BUILD_WITH_MARCH_NATIVE=OFF
- GTSAM_USE_SYSTEM_EIGEN=ON
- GTSAM_USE_SYSTEM_METIS=ON

```bash
sudo apt update
sudo apt install -y libgtsam-notbb-dev
```

### gtsam_points

```bash
sudo apt update
sudo apt install -y libgtsam-points-dev           # No CUDA
sudo apt install -y libgtsam-points-cuda12.2-dev  # CUDA12.2
sudo apt install -y libgtsam-points-cuda12.5-dev  # CUDA12.5
```

### glim_ros2

```bash
sudo apt update

# ROS2 jazzy
sudo apt install -y ros-jazzy-glim-ros            # No CUDA
sudo apt install -y ros-jazzy-glim-ros-cuda12.5   # CUDA12.5

# ROS2 humble
sudo apt install -y ros-humble-glim-ros           # No CUDA
sudo apt install -y ros-humble-glim-ros-cuda12.5  # CUDA12.5
```

