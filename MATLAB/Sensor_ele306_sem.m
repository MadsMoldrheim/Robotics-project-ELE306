clc;
clear;
close all;
%Sensor--
%The robotScenario object generates a simulation scenario consisting of static meshes, robot platforms, 
%and sensors in a 3-D environment.

%Usikker om vi må bruke scenario for vårt eksempel.
scenario = robotScenario(UpdateRate=100,StopTime=1);

%Danner en "verden" med bokser.
addMesh(scenario,"Plane",Size=[10 10],Color=[0.7 0.7 0.7]);
addMesh(scenario,"Box",Size=[0.5 0.5 0.5],Position=[0 0 0.25], ...
        Color=[0 1 0]);

%Ruten den skal kjøre
waypoint = [-5 -5 0; -5 5 0; -3 5 0; -3 -5 0; -1 -5 0; -1 5 0];

toa = linspace(0,1,length(waypoint));
traj = waypointTrajectory("Waypoints",waypoint, ...
                          "TimeOfArrival",toa, ...
                          "ReferenceFrame","ENU");

                      
%Her loader vi roboten. Skal vi her legge inn kinematisk modell for båt?                      
robotRBT = loadrobot("robotisTurtleBot3WafflePi");

%Ditta vil då være båtens kinematikk??
platform = robotPlatform("TurtleBot",scenario, ...
                         BaseTrajectory=traj);

%Nokke endring i nokke greie som gjør nokke
updateMesh(platform,"RigidBodyTree",Object=robotRBT);       

%Legger til sensor. Vårt eksempel skal vi bruke robotLidarPointCloudGenerator
%Lidar er en optisk sensor som finner og måler avstand. 
%lidar = robotSensor("robotLidarPointCloudGenerator",platform); ?????
%Skal ikkje ha ins, det er en slags gps. 
ins = robotSensor("INS",platform,insSensor("RollAccuracy",0), ...
                  UpdateRate=scenario.UpdateRate);
            



%Kompliserte printegreier som virka ganske piss  Ingenting her å røre           
[ax,plotFrames] = show3D(scenario);
axis equal
hold on

count = 1;
while ~isDone(traj)
    [Position(count,:),Orientation(count,:),Velocity(count,:), ...
     Acceleration(count,:),AngularVelocity(count,:)] = traj();
    count = count+1;
end

trajPlot = plot3(nan,nan,nan,"Color",[1 0 1],"LineWidth",2);
trajPlot.XDataSource = "Position(:,1)";
trajPlot.YDataSource = "Position(:,2)";
trajPlot.ZDataSource = "Position(:,3)";
setup(scenario)

for idx = 1:count-1
    % Read sensor readings.
    [isUpdated,insTimestamp(idx,1),sensorReadings(idx)] = read(ins);
    if isUpdated
        % Use fast update to move platform visualization frames.
        show3D(scenario,FastUpdate=true,Parent=ax);
        % Refresh all plot data and visualize.
        refreshdata
        drawnow limitrate
    end
    % Advance scenario simulation time.
    advance(scenario);
    % Update all sensors in the scene.
    updateSensors(scenario)
end
hold off