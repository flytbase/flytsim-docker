.. _flytsim basics:

How to Launch?
==============

.. _launch flytsim:

Launch FlytSim
--------------

Once you have installed **FlytSim**, you are ready to build your own apps and run it out on the simulation software.
To launch FlytSim, run this command in the **new** terminal.

.. code-block:: bash

	$ launch_flytSim

.. caution:: If you get this error: ``bash: launch_flytSim: command not found``, try to launch FlytSim in a new terminal.

.. note:: For first time Gazebo users, Gazebo might take some time to launch. Be Patient!

The above command would launch ROS and Gazebo. A hexrotor model-typhoon-h480 will be automatically spawned for you to start executing your app. You can use FlytAPIs in your command line to do some simple maneuvers. For example,

.. code-block:: bash

	#To make the vehicle take off at its spot, execute this command in your terminal. 
	$ rosservice call /flytsim/navigation/take_off "takeoff_alt: 2.0"

.. code-block:: bash

	#To send a position setpoint to the vehicle in NED frame, execute this command in your terminal.
	rosservice call /flytsim/navigation/position_set "twist:
	 header:
	   seq: 0
	   stamp: {secs: 0, nsecs: 0}
	   frame_id: ''
	 twist:
	   linear: {x: 3.0, y: 1.0, z: -2.0}
	   angular: {x: 0.0, y: 0.0, z: 0.0}
	tolerance: 0.0
	async: false
	relative: false
	yaw_valid: false
	body_frame: false"
	#This sends the vehicle to location (3,1,-2) in NED Frame.

.. caution:: Gazebo runs in ENU frame, hence the above setpoints given in NED Frame would be transformed to ENU Frame by Gazebo.

To know more about such commands, please refer to `FlytAPIs <http://api.flytbase.com>`_ for more details.	

Stop FlytSim
------------

To stop this instance of FlytSim, run this command in your terminal.

.. code-block:: bash

	$ stop_flytSim



