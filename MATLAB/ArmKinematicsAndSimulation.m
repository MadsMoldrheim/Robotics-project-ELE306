%Transformation mapping
syms q1 q2 q3 q4 q5 q6 PI
Params = [q1 0.025 0.025 pi/2;
          q2 0.1 0.5 0; 
          q3 0.1 0.5 pi/2;
          q4 0.01 0.2 pi/2;
          q5 0.2 0 pi/2;
          q6 0 0 0]; 
Transform = DH2T(Params(1,1),Params(1,2),Params(1,3),Params(1,4))
for ii = 2:6
   Transformn = DH2T(Params(ii,1),Params(ii,2),Params(ii,3),Params(ii,4));
   Transformn
   ii
   Transform = Transform*Transformn;
end
Transform


%%


syms q1 q2 q3 q4 q5 q6 PI
Params = [0 0.025 0.025 pi/2;
          pi/2 0.1 0.5 0; 
          0 0.1 0.5 pi/2;
          0 0.01 0.2 pi/2;
          0 0.2 0 pi/2;
          0 0 0 0]; 
Transform = DH2T(Params(1,1),Params(1,2),Params(1,3),Params(1,4))
for ii = 2:6
   Transformn = DH2T(Params(ii,1),Params(ii,2),Params(ii,3),Params(ii,4));
   Transformn
   ii
   Transform = Transform*Transformn;
end
Transform

%%

%Defie robot arm

L1 = Revolute();
L1.a = 0.025;
L1.d = 0.025;
L1.alpha= pi/2; 

L2 = Revolute();
L2.a = 0.5;
L2.d = 0.1;
L2.alpha= 0;

L3 = Revolute();
L3.a = 0.5;
L3.d = 0.1;
L3.alpha= pi/2; 

L4 = Revolute();
L4.a = 0.2;
L4.d = 00.01;
L4.alpha= pi/2;

L5 = Revolute();
L5.alpha = pi/2;
L5.a = 0;
L5.d = 0.2;

L6 = Revolute;
L6.alpha = 0;
L6.a = 00;
L6.d = 0;



% Add two joints for manipulator; 



robot = SerialLink([L1 L2 L3 L4 L5 L6] )
robot.name = "Robot arm project"
robot.qlim = [[-pi,pi];[0,pi];[-pi, pi];[-0.1,0.1];[-pi,pi];[-pi,pi]];


%%
%Forward kinematics eqviv suøution
q = [0,0,0,0,0,0];
robot.fkine(q)

%% 
%Diferential kinematics 
%Velocties of end effector
j = robot.jacobe(q);
%Could be used to find singularities. 
det(j);
rank(j);
%Also be used to compute angular or 








