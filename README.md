# Robotics project ELE306

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

**ROS Video**\
https://youtu.be/ic8_mcGDgFw
