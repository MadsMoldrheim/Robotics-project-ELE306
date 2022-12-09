rosshutdown
rosinit
global odom

sub_odom = rossubscriber("boat_robot/odom",@odom_callback);


[pub_vel,msg_vel] = rospublisher('boat_robot/cmd_vel','geometry_msgs/Twist');

%scandata = rosmessage("std_msgs/Float64")
q_temp = [0,0,0,0];

%Create a robotics toolbox vehicle object
V = diag([0.02, 0.5*pi/180].^2);        % Specify process covariance (distance/heading)
%veh = Unicycle('covar',V);               % Creates a vehicle from the unicycle model with covariance V

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
waypoints = waypoints*1;

rate = robotics.Rate(5);

%Loop through the list of waypoints
for i = 1:size(waypoints, 1)
    xtarget = waypoints(i,1);
    ytarget = waypoints(i, 2);

    %As long as the robot has not reached the waypoint, keep driving the
    %robot
    goal = false;
    while not(goal)
        lim = 2;          %How close the robot has to be before the goal is considered to be reached
        position = odom.Pose.Pose.Position;     %Get the state for the robot
        orientation = odom.Pose.Pose.Orientation;
        quat = quaternion([orientation.X orientation.Y orientation.Z orientation.W]);
        rad = euler(quat, 'XYZ', 'point');
        radZ = rad(1);
        
        %Get the robots position and orientation from the state
        xpos = position.X
        disp(xtarget)
        ypos = position.Y
        disp(ytarget)
        theta = radZ
%           xpos = 1;
%           ypos = 1;
%           theta = 1;
        
        %Check if the robot has reached the waypoint (within the limit)
        if abs(xtarget-xpos) < lim && abs(ytarget-ypos) < lim
            %If the goal is reached, set goal=true
            % The while loop will break
            goal = true;
        else
            %While the goal is not met, update the robot by controllers
            [v, w] = Control(xtarget, ytarget, xpos, ypos, theta)
            %veh.update([v, w]);
            msg_vel.Linear.X = v*10;
            msg_vel.Angular.Z = w;
            send(pub_vel,msg_vel)
        end
        waitfor(rate);
    end
end


msg_vel.Linear.X = 0.0;
msg_vel.Angular.Z = 0.0;
send(pub_vel,msg_vel)

rosshutdown

function odom_callback(src,msg)
    global odom
    odom = msg; 
end