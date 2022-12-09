%%Forward kinematics
close all
clc
clear
import ETS3.*

l1 = 0.4;
l2 = 0.3;
l3 = 0.5;
l4 = 0.3;


L1 = Revolute();
L1.a = 0; 
L1.d = l1;
L1.alpha = -pi/2; 

L2 = Revolute();
L2.a = 0;
L2.d = l2; 
L2.alpha = pi/2; 

L3 = Revolute();
L3.a = 0;
L3.d = l3;
L3.alpha = -pi/2; 

L4 = Revolute(); 
L4.alpha = pi; 
L4.a = 0;
L4.a = -l4; 

robot = SerialLink([L1,L2,L3,L4]);
robot.plot([0,0,0,0]);

T_robot_1 = robot.fkine([0, pi/2, pi/2, 0]);

%% Inverse kinematics

T_robot_2 = SE3(0.385, 0, -0.186) * SE3.rpy(00,0,90,'deg');

%%

qi = robot.ikine(T_robot_1, 'mask', [1 1 1 0 0 0]);
robot.plot(qi)



%%
rosshutdown
rosinit
global odom

sub_odom = rossubscriber("/odom",@odom_callback);

[pub_q1,msg_q1] = rospublisher('/mobile_manipulator/arm_base_controller/command','std_msgs/Float64');
[pub_q2,msg_q2] = rospublisher('/mobile_manipulator/link_1_controller/command','std_msgs/Float64');
[pub_q3,msg_q3] = rospublisher('/mobile_manipulatorlink_2_controller/command','std_msgs/Float64');
[pub_q4,msg_q4] = rospublisher('/mobile_manipulator/link_3_controller/command','std_msgs/Float64');
[pub_vel,msg_vel] = rospublisher('/cmd_vel','geometry_msgs/Twist');

%scandata = rosmessage("std_msgs/Float64")
q_temp = [0,0,0,0];

msg_vel.Linear.X = 1;
%msg_vel.Angular.Z = -0.5;

rate = robotics.Rate(1);

while rate.TotalElapsedTime < 10
    odom.Pose.Pose.Position
    
    if q_temp(2) == qi(2)
        q_temp = [0,0,0,0];
    else
        q_temp = qi;
    end
    
    msg_q1.Data = q_temp(1);
    msg_q2.Data = q_temp(2);
    msg_q3.Data = q_temp(3);
    msg_q4.Data = q_temp(4);
    
    send(pub_q1,msg_q1)
    send(pub_q2,msg_q2)
    send(pub_q3,msg_q3)
    send(pub_q4,msg_q4) 
    
    send(pub_vel,msg_vel)
    
    waitfor(rate);
end

%msg_vel.Linear.X = 0.0;
%msg_vel.Angular.Z = 0.0;
send(pub_vel,msg_vel)

rosshutdown

function odom_callback(src,msg)
    global odom
    odom = msg; 
end