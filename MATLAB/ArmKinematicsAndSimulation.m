
%%
%Define robot arm, series of link determined by DH-table

L1 = Revolute();
L1.a = 0.025;
L1.d = 0.025;
L1.alpha= pi/2; 


L2 = Revolute();
L2.a = 0.3;
L2.d = 0.1;
L2.alpha= 0;
L2.offset = 0.6981;

L3 = Revolute();
L3.a = 0.4;
L3.d = 0.2;
L3.alpha= pi/2; 
L3.offset = 2.36;

L4 = Revolute();
L4.a = 0.3;
L4.d = 00.01;
L4.alpha= pi/2;
L4.offset = -0.46;

L5 = Revolute();
L5.alpha = pi/2;
L5.a = 0;
L5.d = 0.2;
L5.offset = 1.5481;

L6 = Revolute;
L6.alpha = 0;
L6.a = 00;
L6.d = 0;



% Add two joints for manipulator; 



robot = SerialLink([L1 L2 L3 L4 L5 L6] )
robot.name = "Robot arm project";


%%
%Forward kinematics eqviv sulution
q = [0,pi/4,pi/4,0,0,0];
robot.fkine(q)


%%
%Differential kinematics. Fiding rotational velocities from desired end
%effector movement. 
p = [0 1.5045 -1.3718 0.00 0 0];
ve = transpose([0.0 0.2 0 0 0 0]);
J = robot.jacobe(p);

qq = transpose(inv(J)*ve); 
%%
%Computing the incese kinematics of a random point with Cartesian pose. Ie.
%the robot arm coordinates required to reach the point

Tp = SE3(-0.697,-0.20,-0.25); 
TR = SE3.Ry(pi); 
TR = Tp*TR;
q1 = robot.ikine(TR);


%%
%Example motion planning
%q0 inital joint rotation, q1 joint coordinates found using inverse
%kinematics.

%Robot home pose
HOME = robot.fkine([0 0 0 0 0 0]);
%Joint angles
q0 = robot.ikine(HOME);

%XYZ of plastic
PLASTIC = [-0.697,-0.20,-0.25]; 
%THe pose of plastic for simulation purposes. In application this pose
%would be provided by sensor
Tp = SE3(PLASTIC);
TR = SE3.Ry(pi);
Tp = Tp*TR; 
qp = robot.ikine(Tp);

%Trajectory from home to plastic
qjp = jtraj(q0,qp,60);
robot.plot(qjp);

% Dropoff pose
%%
%Simulation of relevant task. With pickup and dropoff of plastic
DROPOFF = [0 -0.4 0.1]; 
Td = SE3(DROPOFF); 
Td = SE3.Ry(pi)*Td;

qd = robot.ikine(Td); 

%Need intermidiate point for motion to be smooth
INTERMIDIATE = [-0.357 0.4 0.8];
TI = SE3(INTERMIDIATE);

qi = robot.ikine(TI);



qji = jtraj(qp,qi,60);
qjd = jtraj(qi, qd , 60);
qjhome = jtraj(qd, q0, 60);


%Create wait in motion in order to simulate gripping
%Pickup plastic
qwaitp = qjp(end,1:6);
for ii = 1:4
    qwaitp = [qwaitp;qwaitp]; 
end

%Dropoff
qwaitd = qjd(end,1:6);

for ii = 1:4
    qwaitd = [qwaitd;qwaitd]; 
end
%%

qjfinal = [qjp;qwaitp;qji;qjd;qwaitd;qjhome;];
robot.plot(qjfinal);


















