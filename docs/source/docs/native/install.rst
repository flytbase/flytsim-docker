.. _FlytSim Installation Guide: 

Installation Guide
==================

1. Please ensure you are running Linux - Ubuntu 16.04 before proceeding with installation.

.. warning:: Please make sure you have a stable internet connection. Save and close all open applications before executing the script as your system shall reboot on installation.

2. Open terminal and run the following command

   .. code-block:: bash

       $ sudo bash -c 'curl -sSL http://docs.flytbase.com/_static/Downloads/flytSim_installation.sh | bash -e'

   In case you get an error saying curl: command not found, please run the following command

   .. code-block:: bash

       $ sudo bash -c 'wget -O - http://docs.flytbase.com/_static/Downloads/flytSim_installation.sh | bash -e'

3. Please enter your system password when prompted

4. On successful installation you will get the message **Congratulations! FlytOS installation completed** and your system shall reboot.

.. caution:: You must :ref:`activate your device<activate_flytsim>`, without which critical APIs will not function.


Troubleshooting
---------------

* If the installation script throws an error, please reboot and try again.

* If you get the error "Connection Timed Out":
  Please check your internet connection and run the script again.

* If the script is interrupted during execution, try running the following command before you execute the script again

  .. code-block:: bash

      $ sudo dpkg --configure -a

* If the above command does not work, run the following to fix your packages before running the installation script

  .. code-block:: bash

      $ sudo apt-get upgrade --fix-broken



.. _activate_flytsim:

Activate FlytSim
----------------

.. note:: This step requires you to have a registered FlytBase Account. In case you don't have an account, `create a FlytBase Account <http://docs.flytbase.com/docs/FlytOS/GettingStarted/SignUp.html>`_ before you proceed.

You have to activate installed FlytSim, without which critical APIs will not function.

1. Make sure your machine has internet access before proceeding.
2. :ref:`Launch FlytSim <launch flytsim>` and ignore warnings thrown in the terminal for license not being activated.
3. `Launch FlytConsole <http://localhost/flytconsole>`_. You can launch FlytConsole in your browser using the URL ``http://localhost/flytconsole`` or on some other PC's browser using the URL ``http://ip-address-of-device/flytconsole``. In FlytConsole click on **Activate Now tag** under **License tab** at bottom right corner. A pop-up will appear which will direct you to the device registration page. If you are not logged in, enter your FlytBase Account credentials to log in.
4. Choose a device nick-name and select your compute engine. 
5. In the license drop-down list, select existing license if available or select ‘Issue a new license’. You can also provide a nick-name for your license.  
6. Click on Save Changes to register device and generate a license key.
7. Copy the generated license key and enter it in FlytConsole to complete the activation process of your device. The Activate Now tag at bottom right corner of FlytConsole should now turn green.


Update FlytSim
--------------

FlytSim comes with automatic over-the-air update feature whenever it detects an updated version of FlytSim in our servers. To know more about automatic updates, click `here <http://docs.flytbase.com/docs/FlytOS/GettingStarted/FlytOSUpdate.html>`__.

