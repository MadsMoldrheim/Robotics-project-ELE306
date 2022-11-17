function [v, w] = Control(xtarget, ytarget, xpos, ypos, theta)
    gainv = 1;
    gainw = 1;
    lookahead = 0.3;

    xerror = xtarget - xpos;
    yerror = ytarget - ypos;
    
    deltaTheta = angdiff(atan2(yerror, xerror), theta);

    v = (sqrt(xerror^2 + yerror^2) - lookahead)*gain/(deltaTheta + 1);
    w = deltaTheta*gain;
end