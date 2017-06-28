.. FlytSim documentation master file
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. _flytsim:

FlytSim
=======

**FlytSim** offers a **SITL(Software In The Loop)** simulation environment for testing user apps without the drone hardware. In FlytSim's environment, the drone and its world are simulated, programmatically generating the state variables, while the control algorithms applied are same as onboard the drone (PX4/APM). The **FlytAPIs** are also available in FlytSim and thus the user apps built with these APIs can be tested on a computer supporting a native Linux environment using FlytSim. FlytSim is based on APM-SITL/PX4-SITL customised to work with FlytAPIs. 

With the latest addition of **FlytSim as a Docker app**, we bring the power of Docker to our FlytSim developers. With docker, we now support Windows, Linux and MacOS environments, which removes the requirement to install any specific flavour of linux natively in your machine. 

.. This documentation gives all the inputs to get you started with FlytSim. |api_link| gives detailed reference for all supported APIs.

.. .. |api_link| raw:: html

..    <a href="http://api.flytbase.com" target="_blank">FlytAPIs</a> 

.. You can participate in our `forums`_ or `facebook`_ group discussions to interact with other drone developers and share your use cases to get valuable feedback or get help in development. You can always reach out to us for any issues at support@flytbase.com. 


|br|

.. _documentation:  

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: FlytSim Docker

   docs/docker/gettingstarted.rst
   docs/docker/setup.rst
   docs/docker/basics.rst
   docs/docker/activation.rst
   docs/docker/demoapps.rst
   docs/docker/troubleshooting.rst

.. toctree::
   :maxdepth: 2
   :hidden:
   :caption: FlytSim Native (deprecated)

   docs/native/install.rst
   docs/native/launch.rst
   docs/native/troubleshooting.rst

.. |br| raw:: html

   <br />

.. _forums: http://forums.flytbase.com

.. _facebook: https://www.facebook.com/groups/flytos/

.. Indices and tables
.. ==================

.. * :ref:`genindex`
.. * :ref:`modindex`
.. * :ref:`search`

