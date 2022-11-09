
import ETS2.*
syms q1 q2 q3 real
L1 = Revolute();
L1.a = 0.5;
L1.d = 0.25;
L1.alpha = -pi/2; 
 
L2 = Revolute();
L2.a = 0.7;
L2.d = 0.5;
L2.alpha = 0;



L3 = Revolute(); 
L3.alpha = -pi/2; 
L3.d = 0.6; 
L3.a = 0.6;

L4 = Revolute(); 
L4.alpha = pi/2; 
L4.d = 0.3;
L4.a = 0.04; 

% First find the transform from 0-> 4, finds transform matrices of links

T1 = L1.A(0); 
T2 = L2.A(0);
T3 = L3.A(0); 
T4 = L4.A(0); 

%The transform 0 -> 4 is the product of the link transforms


Tfinal = T1*T2*T3*T4



robot = SerialLink([L1 L2 L3 L4] );
robot.name = "My first robot arm";
robot.teach()

