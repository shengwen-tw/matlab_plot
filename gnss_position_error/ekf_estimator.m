classdef ekf_estimator
    properties
        home_longitude = 0;
        home_latitude = 0;
        home_ecef_x = 0;
        home_ecef_y = 0;
        home_ecef_z = 0;
        
        EQUATORIAL_RADIUS = 6378137 %[m], earth semi-major length (AE)
        POLAR_RADIUS = 6356752      %[m], earth semi-minor length (AP)
        AP_SQ_DIV_AE_SQ = 0.99331   %(AP^2)/(AE^2)
        ECCENTRICITY = 0.081820     %e^2 = 1 - (AP^2)/(AE^2)
    end
        
    methods      
         function ret_obj = set_home_longitude_latitude(obj, longitude, latitude, height_msl)
            obj.home_longitude = longitude;
            obj.home_latitude = latitude;
            
            sin_lambda = sin(deg2rad(longitude));
            cos_lambda = cos(deg2rad(longitude));
            sin_phi = sin(deg2rad(latitude));
            cos_phi = cos(deg2rad(latitude));
            
            %convert geodatic coordinates to earth center earth fixed frame (ecef)
            N = obj.EQUATORIAL_RADIUS / sqrt(1 - (obj.ECCENTRICITY * sin_phi * sin_phi));
            obj.home_ecef_x = (N + height_msl) * cos_phi * cos_lambda;
            obj.home_ecef_y = (N + height_msl) * cos_phi * sin_lambda;
            obj.home_ecef_z = (obj.AP_SQ_DIV_AE_SQ * N + height_msl) * sin_phi;
            
            ret_obj = obj;
        end
        
        function enu_pos = covert_geographic_to_ned_frame(obj, longitude, latitude, height_msl)
            sin_lambda = sin(deg2rad(longitude));
            cos_lambda = cos(deg2rad(longitude));
            sin_phi = sin(deg2rad(latitude));
            cos_phi = cos(deg2rad(latitude));

            %convert geodatic coordinates to earth center earth fixed frame (ecef)
            N = obj.EQUATORIAL_RADIUS / sqrt(1 - (obj.ECCENTRICITY * sin_phi * sin_phi));
            ecef_now_x = (N + height_msl) * cos_phi * cos_lambda;
            ecef_now_y = (N + height_msl) * cos_phi * sin_lambda;
            ecef_now_z = (obj.AP_SQ_DIV_AE_SQ * N + height_msl) * sin_phi;
            
            %convert position from earth center earth fixed frame to east north up frame
            r11 = -sin_phi * cos_lambda;
            r12 = -sin_lambda;
            r13 = -cos_phi * cos_lambda;
            r21 = -sin_phi * sin_lambda;
            r22 = cos_lambda;
            r23 = -cos_phi * sin_lambda;
            r31 = cos_phi;
            r32 = 0;
            r33 = -sin_phi;
            R = [r11, r12, r13;
                 r21, r22, r23
                 r31, r32, r33];
            
            dx = ecef_now_x - obj.home_ecef_x;
            dy = ecef_now_y - obj.home_ecef_y;
            dz = ecef_now_z - obj.home_ecef_z;
            
            enu_pos = R.' * [dx; dy; dz];
        end
    end
end