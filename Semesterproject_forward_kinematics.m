
%Parameters found analyzing each Link

alpha = [-pi/2, 0,-pi/2,0]; 
a = [0 0.2 0.45 0.05];
d = [0.05 0 0.05 0.05]; 



syms q1 q2 q3 q4 q5 q6

theta = [q1,q2,q3,q4]; 
matrix = []; 
%Find Transfer matrices for each link.
for i = 1:length(a)
    matrix = [cos(theta(i)) sin(theta(i))*cos(alpha(i)) sin(theta(i))*sin(alpha(i)) a(i)*cos(theta(i));
               sin(theta(i)) cos(theta(i))*cos(alpha(i)) -cos(theta(i))*sin(alpha(i)) alpha(i)*sin(theta(i));
               0 sin(alpha(i)) cos(alpha(i)) d(i); 0 0 0 1]
end

%%
%Transfer matrices, cleaned up. Finds the base -> end effector mapping

t1 = [cos(q1) 0 -sin(q1) 0;
       sin(q1) 0 cos(q1) -pi/2*sin(q1);
        0 -1 0 1/20;
        0 0 0 1]; 
t2 = [cos(q2) sin(q2) 0 cos(q2)/5;
        sin(q2) cos(q2) 0 0; 
        0 0 1 0; 
        0 0 0 1]; 
t3 = [cos(q3) 0 -sin(q1) 0.45*cos(q3);
       sin(q3) 0 cos(q3) -pi/2*sin(q3);
        0 -1 0 1/20;
        0 0 0 1]; 

t4 =   [cos(q4) sin(q4) 0 cos(q2)/20;
        sin(q4) cos(q4) 0 0; 
        0 0 1 1/20; 
        0 0 0 1];   

%Final transformation matrices.
Tfinal = t1*t2*t3*t4;

%%

L1 = Revolute();
L1.a = 0;
L1.d = 0.05;
L1.alpha= -pi/2; 

L2 = Revolute();
L2.a = 0.2;
L2.d = 0.0;
L2.alpha= 0;

L3 = Revolute();
L3.a = 0.45;
L3.d = 0.05;
L3.alpha= -pi/2; 

L4 = Revolute();
L4.a = 0.05;
L4.d = 0.05;
L4.alpha= -pi/2; 

% Add two joints for manipulator; 



robot = SerialLink([L1 L2 L3 L4] )
robot.name = "My first robot arm";
robot.teach()

%%
% Forward kinematics using toolbox. The arythmetics of matlab is not
% entirely presice, Therefore looks messy. 
robot.fkine([q1,q2,q3,q4,q5,q6])

%%
%Ready posisiton
q1 = [0,-pi/2,0,-pi/2]; %Joint angles

T1 = robot.fkine(q1); 
robot.tool = SE3.Rz(pi/2) * SE3.Ry(-pi/2);
robot.teach()


%%
%Feil, får se på senere
T2 = SE3(0.2, 0.4, 0.5);
q2 = robot.ikine(T2, "mask", [0,1,0,1,1,1]);




