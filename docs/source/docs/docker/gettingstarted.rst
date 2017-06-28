.. _flytsim_getting_started: 

Getting Started
===============

**FlytSim** offers **SITL(Software In The Loop)** simulation environment for testing user apps without the drone hardware. FlytSim simulates the drone and its world, programmatically generating the state variables, while the control algorithms applied are same as onboard the drone. The **FlytAPIs** are also available in FlytSim and thus the user apps built with these APIs can be tested on any computer running FlytSim.
 
With **FlytSim as a Docker app**, we bring the power of Docker to our FlytSim developers. This eases FlytSim’s deployment procedure in any docker supported Linux, Windows and Mac environments. 
 
Prerequisites
-------------

Linux
^^^^^

Follow the `Docker installation guide <https://docs.docker.com/engine/installation/#supported-platforms>`_ and make sure your flavour of Linux is supported by Docker. If you are running anything apart from Ubuntu, please follow the above guide and install docker in your machine. For Ubuntu users, we have an installation script which would take care of it, details of which are in :ref:`setup <flytsim_setup_linux>` section. It is preferable if you use Ubuntu 14.04 or above.
 
Windows
^^^^^^^

Visit installation guide for `Docker-for-Windows <https://docs.docker.com/docker-for-windows/install/>`_ and install it if it is supported by your Windows OS. Typically 64bit Windows 10 Pro, Enterprise and Education support the newer *Docker-for-Windows*. To know more about it, click `here <https://docs.docker.com/docker-for-windows/install/#what-to-know-before-you-install>`__. Currently we DO NOT support `Docker Toolbox (legacy) <https://docs.docker.com/toolbox/toolbox_install_windows/>`__ and have no plan to do it in near future.
 
MacOS
^^^^^

Visit installation guide for `Docker-for-Mac <https://docs.docker.com/docker-for-mac/install/>`_ and install it if it is supported by your Mac OS. Typically OS X El Capitan 10.11 and newer macOS releases support the newer *Docker-for-Mac*. To know more about it, click `here <https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install>`__. Currently we DO NOT support `Docker Toolbox (legacy) <https://docs.docker.com/toolbox/toolbox_install_mac/>`__ and have no plan to do it in near future.
 
.. warning:: In MacOS we could not enable GUI support from within Docker, which means if you are keen on having 3D GUI Gazebo based environment, then please use Linux or Windows.
