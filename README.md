# ELE306-project

## Introduction

In the task we have chosen, the goal is to design and simulate a small boat robot with a robot
arm manipulator for picking plastic in the ocean. Plastic-picking robots using nets for collection
are already used in many parts of the world in similar or bigger proportions, making the ocean a
cleaner place. All members of the group are invested in this topic as a global challenge, making
it ideal as a task.

The task the robot will perform is to use a robot arm to pick up and remove plastic from the
ocean. It will do this by systematically covering an area while simultaneously using the camera
to detect plastic objects. When it detects something it will approach the object and pick it up
with the robot arm, then return to its path and continue to cover the area.

The requirements in the task are as follows:

Robot arm requirements:

1. Minimum 4-dof arm for lifting
2. Additional dof in gripper for picking objects
3. Min. reach with stationary mobile base is 60 cm in the horizontal plane
4. Capable of lifting the gripper (1 kg) and the payload (4 kg)

Mobile base requirements:

1. Boat is 1 m long, 40 cm wide, weight 30 kg, payload 30 kg
2. Capable of searching autonomously in a pattern covering 10 sqm
3. Have a turn radius less than 1 m
4. Two rear thrusters are used for steering - spaced 30 cm apart
5. No waves, but there is a current of 0.1 m/s

Sensor requirements:

1. Low-cost 3D camera for detecting object mounted on mobile base
The groups approach to this project started with defining the problem and the different challenges
surrounding the problem. Each challenge we planned to develop further each week, separately
and as a group. Together, we met up on several occasions to brainstorm to identify the best
solutions, as well as delegating work to each member to work on as we went. In the end, the
solutions were put into practice during simulations.

## TODO
~~**Anna**
Design~~

**Anna & Mads**
Transformasjonsmatrisen end-effector til base, skal det ikke brukes symbolske verdier for q1, q2? Skal brukes i transormasjonsmatrisen lenger nede i kapittelet

**The rest of the guys**
See notes in project requirements

## Project requirements
Most of the project design challenges are focused on a mobile manipulator. That is, a robotic system
with robot arm(s), a mobile robot platform, and a sensory system. Each project will be slightly
different, as the challenges are quite diverse, and as each group may choose a different way to
approach a given robot design challenge. However, all projects must include the following, which
should be documented in the report, or in appendices to the report:

**1. Develop the forward kinematics of your robotic solution, in Matlab (not Toolbox) or by
hand:**

- For the robot arm(s):

    ~~Develop the table of DH parameters~~
  
    ~~Develop the transformation mapping end-effector to base (for the first 4 joints only)~~

- For the mobile robot platform(s):

    ~~Draw a model of the mobile robot with the necessary variables defined (see Fig. 4.1 in Corke for inspiration)~~
    
    ~~Develop the kinematic equations of motion for the mobile robot~~
    
    ~~Discuss whether the mobile robot is holonomic or non-holonomic~~

- For the robotic system in general:
  1. Develop the transformation from the chosen sensor system to the relevant coordinate system on the robot (world, end-effector, mobile
robot, etc)
  > Mads

**2. Model your robot kinematics with Peter Corke's Robotics Toolbox in Matlab:**
- For the robot arm(s):

    ~~Demonstrate equivalence of the forward kinematic solution obtained previously in Matlab (not Toolbox) or by hand~~
    
    Develop the differential kinematics (i.e. relating joint and Cartesian velocities), and demonstrate how it could be used
    > Gunnar
    
    ~~Develop the inverse kinematics, and demonstrate how it could be used~~
    
    ~~Demonstrate example motion planning, on a task relevant to your robot design challenge (or similar)~~
    
- For the mobile robot platform(s):
    
    ~~Determine suitable controller(s) to control the mobile robot for your chosen challenge~~
    
  > Mads
    
    ~~Implement the kinematic model and the controller(s) in Matlab (/Simulink)~~
  > Mads

- For the robotic system in general:
  > Mads
  1. Demonstrate using the sensory system to command the robot,
according to the task chosen. That is, show the calculations necessary to
make the sensory data (e.g. an apple detected at an arbitrary location
from a static 3D camera) useful to the robot (e.g. calculate the joint
angles to put the tool point of the end-effector at the apple’s location).

**3. Simulate the kinematics of your robot in Matlab:**
- For the robot arm(s), depending on robot design challenge either:
    ~~Use motion planning to move the robot end-effector through the
required positions/orientations for the task chosen~~  , or
  2. Use differential kinematics to move the end-effector using velocity
commands according to the task chosen

- For the mobile robot platform(s):
  > Nora
  1. 
  2.   ~Simulate your chosen challenge, and discuss the simulation results in
terms of chosen control strategy and performance~
  2. 
  3. ~Discuss and implement a navigation strategy for the mobile robot for
your challenge~
  3. 
  4. ~Discuss how you would implement a localization strategy for the mobile
robot for your challenge~ 

**4. Connect the Matlab code to ROS and simulate the physical robot in Gazebo**
  > Elias
- For the complete system: Model your complete robot system using URDF and
visualize the robot in Gazebo, including:

  ~~1. Your robot arm(s) mounted on your mobile platform~~
  2. Your mobile platform, with wheels, sensors etc
  
  > Basically done men avhengig av en feil som eg ikkje får løst i 2 ^
  
- For the robot arm(s): Demonstrate controlling your robot arm(s) in Gazebo over
ROS from Matlab, by following along a trajectory calculated in Matlab, or
controlled using your differential kinematics implemented in Matlab.
- For the mobile robot(s): Demonstrate controlling your mobile robot platform in
Gazebo over ROS from Matlab.

