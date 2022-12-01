randinit(); 
map = LandmarkMap(0, 10);                   % Create a landmark object
map.plot();

V = diag([0.02, 0.5*pi/180].^2);        % Specify process covariance (distance/heading)
veh = Unicycle('covar',V);               % Creates a vehicle from the unicycle model with covariance V

%Create a list of waypoints [x-value yvalue]
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

%Initialize a list for storing -----?????
%deltaThetaa = [];

%Loop through the list of waypoints
for i = 1:size(waypoints, 1)
    xtarget = waypoints(i,1);
    ytarget = waypoints(i, 2);

    %As long as the robot has not reached the waypoint, keep driving the
    %robot
    goal = false;
    while not(goal)
        lim = 0.2;          %How close the robot has to be before the goal is considered to be reached
        state = veh.x;      %Get the state for the robot

        %Get the robots position and orientation from the state
        xpos = state(1);
        ypos = state(2);
        theta = state(3);
        
        %Check if the robot has reached the waypoint (within the limit)
        if abs(xtarget-xpos) < lim && abs(ytarget-ypos) < lim
            %If the goal is reached, set goal=true
            % The while loop will break
            goal = true;
        else
            %While the goal is not met, update the robot by controllers
            [v, w, deltaTheta] = Control(xtarget, ytarget, xpos, ypos, theta);
            veh.update([v, w]);
            
            %Update the list of  ?????
            %deltaThetaa = [deltaThetaa deltaTheta];
        end
    end
end
veh.plot_xy();
plot(waypoints(:,1), waypoints(:,2), "rx")
