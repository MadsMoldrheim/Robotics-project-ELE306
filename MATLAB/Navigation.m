randinit(); 
map = LandmarkMap(0, 10);                   % Create a landmark object
map.plot();

V = diag([0.02, 0.5*pi/180].^2);        % Specify process covariance (distance/heading)
veh = Unicycle('covar',V);               % Creates a vehicle from the unicycle model with covariance V

waypoints = [0 0;
            1 0;
            1 10;
            2 10;
            2 0;
            3 0;
            3 10;
            4 10;
            4 0;
            5 0;
            5 10;
            6 10;
            6 0;
            7 0;
            7 10;
            8 10;
            8 0;
            9 0;
            9 10;
            10 10;
            10 0;];

deltaThetaa = [];
for i = 1:size(waypoints, 1)
    xtarget = waypoints(i,1);
    ytarget = waypoints(i, 2);

    goal = false;
    while not(goal)
        lim = 0.2;
        state = veh.x;
        xpos = state(1);
        ypos = state(2);
        theta = state(3);

        if abs(xtarget-xpos) < lim && abs(ytarget-ypos) < lim
            goal = true;
        else
            [v, w, deltaTheta] = Control(xtarget, ytarget, xpos, ypos, theta);
            veh.update([v, w]);

            deltaThetaa = [deltaThetaa deltaTheta];
        end
    end
end
veh.plot_xy();
plot(waypoints(:,1), waypoints(:,2), "rx")
