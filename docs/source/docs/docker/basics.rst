.. _flytsim_basics:

Basics
======

Directory Structure
-------------------

The repository is divided into 3 directories depending upon the host OS you choose to use. *Linux* is further divided into 2 depending upon the GPU driver running on your machine.
 
Eventually, all the directories have the following scripts:
 
**setup** : This script as the name suggests sets up your machine to run FlytSim.

**start** : This script launches a FlytSim docker container for you. It also opens up a tab in your browser connecting to http://localhost/flytconsole. Try waiting for around 30 seconds after triggering this script, before manually opening up the link to FlytConsole.
 
**stop** : As its clear from the name, it stops the FlytSim app and shuts down the docker container, but preserving its environment, which means executing the *start* script again, would start FlytSim app and resume the container session for you.
 
**openshell** : This script would launch a bash shell inside the FlytSim container. You can execute this script in parallel, to launch multiple shells inside the FlytSim container.
 
**reset** : This script resets FlytSim container to factory default settings.
 
**docker-compose.yml** : This is a yml specification of the docker container. **Please refrain from editing this file, unless you are an expert on Docker.**
 
.. _flytsim_launch:

Launch FlytSim
--------------

Linux/MacOS
^^^^^^^^^^^

Open a new terminal, and go to the directory where this project was unzipped by you.
**Get inside corresponding directory according to your OS (as you might have chosen while FlytSim setup).**
Run this command in your terminal:

.. code-block:: bash
    
   $ sudo ./start.sh      

Windows
^^^^^^^

Go to the directory where this project was unzipped by you. **Get inside Windows directory.** Start your FlytSim session by opening **start.ps1** script with Windows Powershell application.


Stop FlytSim
------------

Linux/MacOS
^^^^^^^^^^^

Open a new terminal, and go to the directory where this project was unzipped by you.
**Get inside corresponding directory according to your OS (as you might have chosen while FlytSim setup).**
Run this command in your terminal:

.. code-block:: bash
    
   $ sudo ./stop.sh 

Windows
^^^^^^^

Go to the directory where this project was unzipped by you. **Get inside Windows directory.** Start your FlytSim session by opening **stop.ps1** script with Windows Powershell application.

.. _flytsim_shell:

Shell Access
------------

Linux/MacOS
^^^^^^^^^^^

Open a new terminal, and go to the directory where this project was unzipped by you.
**Get inside corresponding directory according to your OS (as you might have chosen while FlytSim setup).**
Run this command in the terminal:

.. code-block:: bash
    
   $ ./openshell.sh  

Windows
^^^^^^^

Go to the directory where this project was unzipped by you. **Get inside Windows directory.** Start your FlytSim session by opening **openshell.ps1** script with Windows Powershell application.