.. _flytsim_troubleshooting:

Troubleshooting
===============

.. .. _flytsim_errors:

.. Errors
.. ------

.. _flytsim_faqs:
 
FAQs
----

How to get my FlytSIM version?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:ref:`Launch FlytSim <flytsim_launch>` if it is not already running. Open `FlytConsole <http://localhost/flytconsole>`_ and wait for it to get connected to Flytsim instance. Once connected, look out for FlytSim version in the top right corner.

.. figure:: /_static/Images/FlytOSVersion.png
	:align: center

|br|

For docker running on Windows/Mac, how much CPU and RAM should I allocate to Docker?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

FlytSim with its **default configuration(APM-SITL)** is very light weight and allocating 2GB RAM and 4 CPUs should be just fine.
 
FlytSim if configured to use **PX4-SITL** is quite computationally heavy. You can allocate 2GB RAM for Docker. For CPU, you could begin with allocating 4CPUs, but since it depends on your device's CPU power, the number may vary for different machines. FlytSim is a very power intensive application, and it won't function correctly if not allotted enough resources. To know whether FlytSim is not getting deprived of resources, try opening a shell inside the container using *openshell* script. Once inside run this command:
 
.. code-block:: bash
    
   $ gz stats 

This should start printing Gazebo statistics on your shell. A typical output would be:

.. code-block:: bash
    
   $ Factor[1.00] SimTime[2.23] RealTime[2.26] Paused[F]
   $ Factor[1.00] SimTime[2.44] RealTime[2.46] Paused[F]

Make sure the value of your *Factor* is above 0.70 all the time, for smooth functioning of FlytSim. In case it is lower than that try increasing CPU allocation.
 
|br|
 
Why does my drone crash after takeoff?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Typically, this happens when your CPU is not powerful enough to handle FlytSim's computational requirements. If you are running Docker for Windows/Mac, increase CPU and RAM allocated to docker. If you have configured FlytSim to run **PX4-SITL**, open a shell inside the container using *openshell* script. Once inside run this command:
 
.. code-block:: bash
    
   $ gz stats

This should start printing Gazebo statistics on your shell. A typical output would be:
 
.. code-block:: bash
    
   $ Factor[1.00] SimTime[2.23] RealTime[2.26] Paused[F]
   $ Factor[1.00] SimTime[2.44] RealTime[2.46] Paused[F]

Make sure the value of your *Factor* is above 0.70 all the time, for smooth functioning of FlytSim. A value lower than that, would result in poor and unreliable performance of FlytSim.
 
|br|
 
I use PX4 firmware on my drone, and would like to use its simulator. How to configure FlytSim to run PX4-SITL instead of its default(APM-SITL)?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To configure FlytSim to launch PX4 simulator, start the FlytSim simulator. Open **flytconsole**, and click top-right corner setup button. It would open a config window, go to Sim Settings tab, and select PX4 as *sim pilot*. You could configure other FlytSim settings as well.
 
|br|

I have a Linux device installed with Nvidia GPU switchable with Intel GPU. How do I know, which graphics card is being used?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you want APM-SITL, you don't need to worry about it, and go ahead with Intel GPU steps. For PX4-SITL, there are many ways to find this out. If you are using Ubuntu, go to System Settings -> Details look for Graphics Card details. You can also install `glxinfo` and run the command: `glxinfo | grep OpenGL` to view the GPU being used.
 
|br|
 
My Linux device is installed with open source nouveau driver for Nvidia. How do I install Nvidia proprietary drivers?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
If you are on Ubuntu, follow this `nvidia gpu install guide <https://help.ubuntu.com/community/BinaryDriverHowto/Nvidia>`_ by Ubuntu.

|br|

How to get FlytSim startup logs?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

|br|

How to get FlytSim run logs?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

|br|

FlytSim is not responding to my Api calls. Why??
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

(look in FlytConsole message window messages)

|br|

Why don’t I see Gazebo GUI when I launch FlytSim?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

|br|


How to check whether PX4-SITL or APM-SITL is being run by FlytSim?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
|br|
 
.. |br| raw:: html

   <br />
