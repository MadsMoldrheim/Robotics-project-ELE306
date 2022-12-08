%randinit(); 
map = LandmarkMap(0, 10);                   % Create a landmark object
map.plot();

%How close the robot has to be before the goal is considered to be reached
lim = 0.1;
%Radius of sensor
R = 2;

%Initialize the robot
V = diag([0.02, 0.5*pi/180].^2);        % Specify process covariance (distance/heading)
veh = Unicycle('covar',V);               % Creates a vehicle from the unicycle model with covariance V

%Simulate a pice of plastic as a vehicle
Plastic = Unicycle('covar', V);
Pactive = true;

%Initialize a starting position and random starting target
Plastic.init([7 7 0])
Pxtarget = randi([0 10]);
Pytarget = randi([0 10]);

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

%Loop through the list of waypoints
for i = 1:size(waypoints, 1)

    %Get target values for robot
    xtarget = waypoints(i,1);
    ytarget = waypoints(i, 2);

    %As long as the robot has not reached the waypoint, keep driving the robot
    goal = false;
    while not(goal)

        %Get state values for robot and plastic simulation
        state = veh.x;
        xpos = state(1);
        ypos = state(2);
        theta = state(3);
    
        Pstate = Plastic.x;
        Pxpos = Pstate(1);
        Pypos = Pstate(2);
        Ptheta = Pstate(3);

        %If the piece of plastic is within the radius of the sensor, set
        %the position of the plastic to be the target
        if Pactive && sqrt((xpos - Pxpos)^2 + (ypos - Pypos)^2) <= R
            xtarget = Pxpos;
            ytarget = Pypos;
        end

        %Check if the robot has reached the waypoint (within the limit)
        if abs(xtarget-xpos) < lim && abs(ytarget-ypos) < lim
            %If the goal is reached, set goal=true
            % The while loop will break
            goal = true;
            
            %If the target was the plastic, "pick it up" / disable the
            %simulation
            if xtarget == Pxpos
                Pactive = false;
                disp(Pxpos)
            end
        else
            %While the goal is not met, update the robot by controllers
            [v, w] = Control(xtarget, ytarget, xpos, ypos, theta);
            veh.update([v, w]);
            
        end

        %Update the plastic if still active
        %Check if the plastic has reached the waypoint (within the limit)
        if abs(Pxtarget-Pxpos) < lim && abs(Pytarget-Pypos) < lim && Pactive
            %If the goal is reached, add a new goal, not too far away from
            %the previous goal
            Pxtarget = min(max(Pxtarget + randi([-1 1]), 0), 10);
            Pytarget = min(max(Pytarget + randi([-1 1]), 0), 10);
        elseif Pactive
            %While the goal is not met, update the robot by controllers
            [v, w] = Control(Pxtarget, Pytarget, Pxpos, Pypos, Ptheta);
            %The plastic drifts with a constant velocity of 0.1 m/s
            Plastic.update([0.1, w]);
            
        end
    end
end

veh.plot_xy();
Plastic.plot_xy();
plot(waypoints(:,1), waypoints(:,2), "rx")
plot(7,7, "gx")

