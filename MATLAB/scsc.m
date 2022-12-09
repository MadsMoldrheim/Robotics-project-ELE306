close all
clear
import ETS3.*

L1=0;
L2=0.2;
L3=0.385;
L4=0.270;
L5=0.115;

robot_normal = Tz(L1) * Rz('q1') * Tz(L2) * Ry('q2') * Tz(L3) * Ry('q3') * Tz(L4) * Ry('q4') * Tz(L5);
robot_normal.plot([0,0,0,0])

j1 = Revolute('d', L2, 'a', 0, 'alpha', -pi/2, 'offset', 0);
j2 = Revolute('d', 0, 'a', -L3, 'alpha', 0, 'offset', pi/2);
j3 = Revolute('d', 0, 'a', -L4, 'alpha', 0, 'offset', 0);
j4 = Revolute('d', 0, 'a', -L5, 'alpha', 0, 'offset', 0);

robot = SerialLink([j1 j2 j3 j4],'name', 'my robot');
figure(1)
robot.plot([0,0,0,0])

T_robot_1 = robot.fkine([pi/2,0,0,pi/2])
T_robot_2 = SE3(0.385,0,-0.185) * SE3.rpy(0,0,90, 'deg')
qi = robot.ikine(T_robot_1,'mask',[1 1 1 0 0 0])
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

scandata = rosmessage("std_msgs/Float64")
q_temp = [0,0,0,0];

msg_vel.Linear.X = 0.5;
msg_vel.Angular.Z = -1;

rate = robotics.Rate(1);
while rate.TotalElapsedTime < 20
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

msg_vel.Linear.X = 0.0;
msg_vel.Angular.Z = 0.0;

rosshutdown

function odom_callback(src,msg)
    global odom
    odom = msg; 
end

