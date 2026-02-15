# PPA

## Changelog

- 2026/02/15 : gtsam_points(1.2.1). GLIM(1.2.1). Auto topic and IMU configuration. IMU validation.
- 2026/01/24 : Iridescence(1.0.1). GLIM(1.2.0). **We changed the GPG key for the PPA. Please re-setup the PPA by following the instructions below.**

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
sudo apt update

# Manually setup PPA for Ubuntu 22.04
curl -s --compressed "https://koide3.github.io/ppa/ubuntu2204/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/ubuntu2204 ./" | sudo tee /etc/apt/sources.list.d/koide3_ppa.list
sudo apt update
```

## Install packages

### Iridescence

```bash
sudo apt install -y libiridescence-dev
```

### GTSAM

- GTSAM tag : 4.3a0
- GTSAM_WITH_TBB=OFF
- GTSAM_BUILD_WITH_MARCH_NATIVE=OFF
- GTSAM_USE_SYSTEM_EIGEN=ON
- GTSAM_USE_SYSTEM_METIS=ON

```bash
sudo apt install -y libgtsam-notbb-dev
```

### gtsam_points

```bash
sudo apt install -y libgtsam-points-dev           # No CUDA
sudo apt install -y libgtsam-points-cuda12.2-dev  # CUDA12.2 (only for Ubuntu 22.04)
sudo apt install -y libgtsam-points-cuda12.6-dev  # CUDA12.6
sudo apt install -y libgtsam-points-cuda13.1-dev  # CUDA13.1
```

### glim_ros2

```bash
sudo apt update

# ROS2 jazzy
sudo apt install -y ros-jazzy-glim-ros            # No CUDA
sudo apt install -y ros-jazzy-glim-ros-cuda12.6   # CUDA12.6
sudo apt install -y ros-jazzy-glim-ros-cuda13.1   # CUDA13.1

# ROS2 humble
sudo apt install -y ros-humble-glim-ros           # No CUDA
sudo apt install -y ros-humble-glim-ros-cuda12.2  # CUDA12.2
sudo apt install -y ros-humble-glim-ros-cuda12.6  # CUDA12.6
sudo apt install -y ros-humble-glim-ros-cuda13.1  # CUDA13.1
```

