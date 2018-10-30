% main script file, run this first.

loadData;

N = numel(boom_angle_deg);
NumSignals = 13;

AllData = [boom_angle_deg, boom_speed_deg_per_sec, ...
            bucket_angle_deg, bucket_speed_deg_per_sec, ...
            digging, drive_axle_speed_rps, ...
            engine_speed_rps, force_lift_MN, ...
            force_tilt_MN, gear_index, ...
            lift_joystick, throttle, ...
            tilt_joystick];
AllDataNames = ["boom_angle_deg", "boom_speed_deg_per_sec", ...
                "bucket_angle_deg", "bucket_speed_deg_per_sec", ...
                "digging", "drive_axle_speed_rps", ...
                "engine_speed_rps", "force_lift_MN", ...
                "force_tilt_MN", "gear_index", ...
                "lift_joystick", "throttle", ...
                "tilt_joystick"];
            
            
%% Plot all data
figure();
hold on;
for i=1:NumSignals
    plot(AllData(:,i));
end
legend(strrep(AllDataNames,'_',' '));
hold off;


%% Examine linear trends in data
trends = nan(NumSignals, 2);
for i=1:NumSignals
    trends(i,:) = polyfit([1:N]',AllData(:,i), 1);
end
disp(["slope","constant","data"])
disp([trends,AllDataNames']);
disp("We hereby assume that slopes are insignificant, and only detrend by removing means in later steps");