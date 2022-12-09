rosinit

startup_rvc;



[pub_q1,msg_q1] = rospublisher('/boat_robot/C1/command','std_msgs/Float64');
[pub_q2,msg_q2] = rospublisher('/boat_robot/C2/command','std_msgs/Float64');
[pub_q3,msg_q3] = rospublisher('/boat_robot/C3/command','std_msgs/Float64');
[pub_q4,msg_q4] = rospublisher('/boat_robot/C4/command','std_msgs/Float64');
[pub_q5,msg_q5] = rospublisher('/boat_robot/C5/command','std_msgs/Float64');
[pub_q6,msg_q6] = rospublisher('/boat_robot/C6/command','std_msgs/Float64');

%Define robot arm, series of link determined by DH-table

L1 = Revolute();
L1.a = 0.025;
L1.d = 0.025;
L1.alpha= pi/2;


L2 = Revolute();
L2.a = 0.3;
L2.d = 0.1;
L2.alpha= 0;


L3 = Revolute();
L3.a = 0.3;
L3.d = 0.2;
L3.alpha= pi/2;


L4 = Revolute();
L4.a = 0.15;
L4.d = 00.01;
L4.alpha= pi/2;

L5 = Revolute();
L5.alpha = pi/2;
L5.a = 0.05;
L5.d = 0;


L6 = Revolute;
L6.alpha = 0;
L6.a = 00.05;
L6.d = 0;





robot = SerialLink([L1 L2 L3 L4 L5 L6] );
robot.name = "Robot arm project";

%Home pose
HOME = robot.fkine([0 0 0 0 0 0]);
%Joint angles
q0 = robot.ikine(HOME);

%Plastic pose
%would be provided by sensor
%Intermidiate plastoc posistion
INTERMIDIATEP =[0.4 0 0.3];
TIP = SE3(INTERMIDIATEP);
qip = robot.ikine(TIP);
qjip = jtraj(q0,qip,60);

PLASTIC = [0.5 -0.0 -0.1];
Tp = SE3(PLASTIC);
TR = SE3.Ry(pi/5);
Tp = Tp*TR;
qp = robot.ikine(Tp);

%jtraj calculates trajectory
%Trajectory from home to plastic
qjp = jtraj(qip,qp,60);


%Get dropoff joint angles
DROPOFF = [-0.1 0.4 0.1];
Td = SE3(DROPOFF);
Td = SE3.Ry(pi/1.5)*Td;

qd = robot.ikine(Td);

%Need intermidiate point for motion to be smooth
%In this iteration the intermidiate position is locked
INTERMIDIATE = [-0.357 0.4 0.5];
TI = SE3(INTERMIDIATE);

qi = robot.ikine(TI);
%Trajectory from plastic to dropoff
qji = jtraj(qp,qi,60);
qdi = jtraj(qd,qi,60);
qjd = jtraj(qi, qd , 60);
qjhome = jtraj(qi, q0, 60);
%Create wait in motion in order to simulate gripping
%Wait at plastic
qwaitp = qjp(end,1:6);
for ii = 1:4
    qwaitp = [qwaitp;qwaitp];
end

%Dropoff
qwaitd = qjd(end,1:6);
for ii = 1:4
    qwaitd = [qwaitd;qwaitd];
end
%The final trajectory
qjfinal = [qjip;qjp;qwaitp;qji;qjd;qwaitd;qdi;qjhome;];

%Send at 30 hz
rate = robotics.Rate(10);


%Loop over the trajectory in order to control robot
points = size(qjfinal);
for ii = 1:points(1)
    msg_q1.Data = qjfinal(ii,1);
    msg_q2.Data = qjfinal(ii,2);
    msg_q3.Data = qjfinal(ii,3);
    msg_q4.Data = qjfinal(ii,4);
    msg_q5.Data = qjfinal(ii,5);
    msg_q6.Data = qjfinal(ii,6);

    send(pub_q1,msg_q1);
    send(pub_q2,msg_q2);
    send(pub_q3,msg_q3);
    send(pub_q4,msg_q4);
    send(pub_q5,msg_q5);
    send(pub_q6,msg_q6);
    waitfor(rate);
end



rosshutdown
