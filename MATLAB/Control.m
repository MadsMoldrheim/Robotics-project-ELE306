function [v, w] = Control(xtarget, ytarget, xpos, ypos, theta)
%{
Controller for differential kinematics
Controls speed and angular velocity, given a goal and state of robot

Inputs
--------------------------------------------------------------
xtarget     The x-coordinate for the target position
ytarget     The y-coordinate for the target position
xpos        The current x-coordinate for the robot's position
ypos        The current y-coordinate for the robot's position
theta       The current heading for the robot
--------------------------------------------------------------

Outputs
--------------------------------------------------------------
v           The speed decided by the controller
w           The angular velocity decided by the controller
--------------------------------------------------------------
%}
    gainv = 1;
    gainw = 1;
    gainvTheta = 100;
    lookahead = 0.0;

    xerror = xtarget - xpos;
    yerror = ytarget - ypos;
    
    deltaTheta = angdiff(atan2(yerror, xerror), theta);

    v = (sqrt(xerror^2 + yerror^2) - lookahead)*gainv/(abs(deltaTheta)*gainvTheta + 1);
    w = deltaTheta*gainw;
end