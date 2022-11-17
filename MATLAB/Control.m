function [v, w, deltaTheta] = Control(xtarget, ytarget, xpos, ypos, theta)
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