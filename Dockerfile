FROM flytsim:v5

# install GLX-Gears
RUN sudo apt-get update && sudo apt-get install -y \
    mesa-utils && \
    sudo rm -rf /var/lib/apt/lists/*

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
#ENV PATH /usr/local/nvidia/bin:${PATH}
#ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
