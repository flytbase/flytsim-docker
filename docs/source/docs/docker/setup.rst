.. _flytsim_setup:

Setup
=====

These instructions will get FlytSim up and running on your local machine for development and testing of your apps.
 
Before moving ahead with FlytSim setup, download(.zip file) the latest stable release from our `release page <https://github.com/flytbase/flytsim-docker/releases/latest>`_ and unzip it to your preferable location.

.. _flytsim_setup_linux:

Linux
----- 

**FlytSim in its default configuration runs a headless(no-GUI) APM-SITL.** It is computationally light weight and should suit most of your simulation requirements. If your use-case doesn’t need a 3D Gazebo based GUI, please continue to Intel GPU section and don’t pay heed to any warning.
 
**FlytSim when configured as PX4-SITL, runs on top of Gazebo, which means it not only simulates the drone but also provides a GUI** of the drone along with its environment. For this, docker container running FlytSim needs access to your machine's GPU libraries. For now we only support Intel and Nvidia graphics card powered devices. In future we may add support for AMD too. AMD users could try going through the steps provided for Intel users, in case they have switchable graphics with Intel.
 
Intel GPU
^^^^^^^^^

.. Warning:: Follow this section only if your device is running on Intel GPU, failure to do so may lead to error while GUI rendering, **unless you want to run FlytSim in its default headless mode (APM-SITL)**.
 
1. Open a new terminal, and go to the directory where you have unzipped our latest release. If you haven’t yet downloaded it then please do it from our `release page <https://github.com/flytbase/flytsim-docker/releases/latest>`_.
2. Get to intelgraphics directory inside linux directory.

   .. code-block:: bash
    
       $ cd linux/intelgraphics

3. If you are running Ubuntu, execute the **setup.sh** script with **sudo** permission which would install `docker <https://docs.docker.com/engine/installation/>`_ and `docker-compose <https://docs.docker.com/compose/install/>`_ on your machine. In case you are using any *other flavour of Linux*, please install them manually by following their individual guides from `Docker installation guide <https://docs.docker.com/engine/installation/#supported-platforms>`_

   .. code-block:: bash
    
       $ sudo ./setup.sh

4. Once setup is completed (or you have manually installed docker and docker-compose), start a sample docker example to make sure it is indeed setup correctly.

   .. code-block:: bash
    
       $ sudo docker run hello-world

   If everything is working fine, you should get the following output.

   .. image:: /_static/Images/intel_test.png

|br|

5. Start your FlytSim session by executing **start.sh** script, with **sudo** permission. This script would start a docker container running FlytSim app and also open a tab in browser pointing to http://localhost/flytconsole, once it detects a successful launch.
 
   .. code-block:: bash
    
       $ sudo ./start.sh

.. Note:: Since, FlytSim is running in its default configuration, **you won’t get to see any Gazebo environment**. To shift it to Gazebo based PX4-SITL mode, visit our <rework> :ref: FAQ section.
 
6. Wait for around 30-40secs after triggering the above script, for Flytconsole to open up in your browser and if it still doesn’t then try `opening it manually <http://localhost/flytconsole>`_. Check for a valid **Connected** status in FlytConsole. **If you don’t get a positive Connected status, check your terminal for any critical error.** If yes, then look at our <rework>:ref:Troubleshooting guide for a possible solution or post your query on our `Forum <http://forums.flytbase.com/>`_ or `Gitter Channel <https://gitter.im/FlytBASE/FlytOS>`_.

Nvidia GPU
^^^^^^^^^^

.. Warning:: Follow this section only if your device is running on Nvidia GPU, failure to do so may lead to error while GUI rendering, **unless you want to run FlytSim in its default headless mode (APM-SITL)**.
 
1.Open a new terminal, and go to the directory where you have unzipped our latest release. If you haven’t yet downloaded it then please do it from our `release page <https://github.com/flytbase/flytsim-docker/releases/latest>`_.
 
2. Get to nvidiagraphics directory inside linux directory.

   .. code-block:: bash
    
       $ cd linux/nvidiagraphics

3. Make sure you have installed proprietary Nvidia driver > 340.29. Visit our <rework>:ref:FAQ section to find how to install Nvidia driver.
4. If you are running Ubuntu, execute the **setup.sh** script with **sudo** permission, which would install `docker <https://docs.docker.com/engine/installation/>`_, `docker-compose <https://docs.docker.com/compose/install/>`_, `nvidia-docker <https://github.com/NVIDIA/nvidia-docker>`_ and `nvidia-docker-compose <https://github.com/eywalker/nvidia-docker-compose>`_ on your machine. In case you are using any *other flavour of Linux*, please install them manually by following their individual guides from `Docker installation guide <https://docs.docker.com/engine/installation/#supported-platforms>`_.
 
   .. code-block:: bash
    
       $ sudo ./setup.sh

4. Once setup is completed (or you have manually installed docker, docker-compose, nvidia-docker and nvidia-docker-compose), start a sample docker example to make sure it is indeed setup correctly.
 
   .. code-block:: bash
    
       $ sudo nvidia-docker run hello-world

   If everything is working fine, you should get the following output.

   .. image:: /_static/Images/intel_test.png

|br|

5. Start your FlytSim session by executing **start.sh** script, with **sudo** permission,  This script would start a docker container running FlytSim app and also open a tab in browser pointing to http://localhost/flytconsole, once it detects a successful launch.
 
   .. code-block:: bash
    
       $ sudo ./start.sh

.. Note:: Since, FlytSim is running in its default configuration, **you won’t get to see any Gazebo environment**. To shift it to Gazebo based PX4-SITL mode, visit our <rework> :ref: FAQ section. 
 
6. Wait for around 30-40secs after triggering the above script, for Flytconsole to open up in your browser and if it still doesn’t then try `opening it manually <http://localhost/flytconsole>`_. Check for a valid **Connected** status in FlytConsole. **If you don’t get a positive Connected status, check your terminal for any critical error**. If yes, then look at our <rework>:ref:Troubleshooting guide for a possible solution or post your query on our `Forum <http://forums.flytbase.com/>`_ or `Gitter Channel <https://gitter.im/FlytBASE/FlytOS>`_.

Windows
-------

Docker-for-Windows
^^^^^^^^^^^^^^^^^^

1. Make sure you have installed Docker and it is running. (It would be visible in your system's tray icon). An easy test for that would be to start a sample docker app. Run the following command in command prompt or powershell.

   .. code-block:: bash
    
       $ docker run hello-world

   If everything is working fine, you should get the following output.

   .. image:: /_static/Images/intel_test.png

|br|

2. Open up the folder where you earlier unzipped our latest release. If you haven’t yet downloaded it then please download from our `release page <https://github.com/flytbase/flytsim-docker/releases/latest>`_.
 
3. Get inside *Windows* directory, and open **setup.ps1** with Windows PowerShell application. You might have to unblock the file, by opening up its properties. This setup would install `Xming x-server <http://www.straightrunning.com/XmingNotes/>`_ for rendering FlytSim's GUI.
 
3. Start your FlytSim session by opening **start.ps1** script with Windows Powershell application. This script would start a docker container running FlytSim app and also open a tab in your browser pointing to http://localhost/flytconsole, once it detects a successful launch.
 
.. Note:: Since, FlytSim is running in its default configuration, **you won’t get to see any Gazebo environment**. To shift it to Gazebo based PX4-SITL mode, visit our <rework> :ref: FAQ section. 
 
5. Wait for around 30-40secs after triggering the above script, for Flytconsole to open up in your browser and if it still doesn’t then try `opening it manually <http://localhost/flytconsole>`_. Check for a valid **Connected** status in FlytConsole. **If you don’t get a positive Connected status, check your terminal for any critical error**. If yes, then look at our <rework>:ref:Troubleshooting guide for a possible solution or post your query on our `Forum <http://forums.flytbase.com/>`_ or `Gitter Channel <https://gitter.im/FlytBASE/FlytOS>`_.
 
 
Docker Toolbox for Windows [Unsupported]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Currently unsupported, and no plan yet to support it. Kindly install Docker for Windows if your OS supports it. Otherwise, install Linux natively.
 
MacOS
-----

Docker-for-Mac
^^^^^^^^^^^^^^

1. Make sure you have installed Docker and it is running. An easy test for that would be to start a sample docker app. Run the following command in shell/terminal.
 
   .. code-block:: bash
    
       $ docker run hello-world

2. Open a new terminal, and go to the directory where you have unzipped our latest release. If you haven’t yet downloaded it then please download from our `release page <https://github.com/flytbase/flytsim-docker/releases/latest>`_.
 
3. In the above terminal, get inside folder named *mac*.

   .. code-block:: bash
    
       $ cd mac
 
4. Start your FlytSim session by executing **start.sh** script with **sudo** permission. This script would start a docker container running FlytSim app and also open a tab in browser pointing to http://localhost/flytconsole, once it detects a successful launch.
 
   .. code-block:: bash
    
       $ sudo ./start.sh

.. Warning:: As mentioned before, in MacOS, you won’t get to see any 3D GUI Gazebo environment. If you are keen on having 3D GUI Gazebo based environment, then please use Linux or Windows.
 
5. Wait for around 30-40secs after triggering the above script, for Flytconsole to open up in your browser and if it still doesn’t then try `opening it manually <http://localhost/flytconsole>`_. Check for a valid **Connected** status in FlytConsole. **If you don’t get a positive Connected status, check your terminal for any critical error**. If yes, then look at our <rework>:ref:Troubleshooting guide for a possible solution or post your query on our `Forum <http://forums.flytbase.com/>`_ or `Gitter Channel <https://gitter.im/FlytBASE/FlytOS>`_.

Docker Toolbox for Mac [Unsupported]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Currently unsupported, and no plan yet to support it. Kindly install Docker for Mac if your OS supports it. Otherwise, install Linux natively.
 

.. |br| raw:: html

   <br />
