function [ fail, pszCollectFile ] = OdauSaveCollectionToFile( pszCollectFile )
%ODAUSAVECOLLECTIONTOFILE This function creates a config file for the ODAU's set-up. This allows you to load/change it manually.
%   -> pszCollectFile is the name of the .ini file you want to save to. Do not add the extension.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szCollectFile_pointer = libpointer('cstring', pszCollectFile);

    if(new_or_old)
        fail = calllib('oapi64', 'OdauSaveCollectionToFile', szCollectFile_pointer);
    else
        fail = calllib('oapi', 'OdauSaveCollectionToFile', szCollectFile_pointer);
    end


    % Get updated data with the pointer
    pszCollectFile = get(szCollectFile_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szCollectFile_pointer;

end

