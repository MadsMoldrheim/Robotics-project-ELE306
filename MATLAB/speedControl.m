function v = speedControl(xtarget, ytarget, xpos, ypos, w)
    gain = 1/;
    lookahead = 0.3;

    xerror = xtarget - xpos;
    yerror = ytarget - ypos;
    
    v = (sqrt(xerror^2 + yerror^2) - lookahead)*gain;
end