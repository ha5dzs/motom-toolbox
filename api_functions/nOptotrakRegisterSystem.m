function [ fail, dtRegisterParms, pfRMSError ] = nOptotrakRegisterSystem( dtRegisterParms, pfRMSError )
%NOPTOTRAKREGISTERSYSTEM
% [ fail, dtRegisterParms, pfRMSError ] = nOptotrakRegisterSystem( dtRegisterParms, pfRMSError )
% If you use more than one sensor, you'll need to generate camera parameter files.
% The pre-requisite is that you need to record a moving pre-defined rigid body with the un-aligned cameras.
%   -> dtRegisterParms is a stucture, initialised as follows:
%       char szRawDataFile is the file name of the raw data file you previously recorded with the unaligned camera settings
%       char szRigidBodyFile is the file name of the rigid body you used to make the recording you are giving this function to work with
%       char szInputCamFile is the unaligned camera file to be read by this function
%       char szOutputCamFile is the camera file which will hold the correct calibration data generated by this function
%       char szLogFile is the name of the log file to be generated during the calibration process
%       float fXrfmMaxError is the maximum allowable error introduced by the rigid body transformation. Typical value is 0.2...0.5 [mm]. If the error is largen than what you specify here, the function will fail.
%       float fXfrm3dRmsError is a maximum allowable RMS error. Typical value is 0.5...0.75 [mm]. If the error is larger than what you set here, the function will fail.
%       float fSpread1; float fSpread2, float fSpread3: you can specify the minimum volume to be covered during calibration. Set these to 0 if you don't want to use this feature
%       float fMinNumberOfXfrms you can specity how many successful conversions are at least required to the calibration. If the system detects less than this, the function will fail.
%       int nLogFileLevel is a number, as follows:
%           0: REG_NO_LOG_FILE means that nothing will be written to the log
%           1: REG_SUMMARY_LOG_FILE instructs the system to keep things as brief as possible in the log
%           2: REG_DETAILED_LOG_FILE for nerds
%       boolean bCheckCalibration is a binary parameter, if set to a nonzero value, the function will not write the new camera file. This is useful to see if your system needs calibrating.
%       boolean bVerbose is a binary parameter, if set to a nonzero value, it will generate output text to the console
%   -> pfRMSError is the RMS error in the calibration process. This allows you to check whether the calibration was up to standard.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    RegisterParms_struct = libstruct('RegisterParmsStruct', dtRegisterParms);
    fRMSError_pointer = libpointer('singlePtr', pfRMSError);

    if(isunix)
        fail = calllib('liboapi', 'nOptotrakRegisterSystem', RegisterParms_struct, fRMSError_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'nOptotrakRegisterSystem', RegisterParms_struct, fRMSError_pointer);
        else
            fail = calllib('oapi', 'nOptotrakRegisterSystem', RegisterParms_struct, fRMSError_pointer);
        end
    end

    % Get updated data with the pointer
    dtRegisterParms = get(RegisterParms_struct);
    pfRMSError = get(fRMSError_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear RegisterParms_struct fRMSError_pointer;

end

