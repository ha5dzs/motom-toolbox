function [ fail, pszFileName, uFileId, uFileMode, pnItems, pnSubItems, plnFrames, pfFrequency, pszComments, pFileHeader ] = FileOpen( pszFileName, uFileId, uFileMode, pnItems, pnSubItems, plnFrames, pfFrequency, pszComments, pFileHeader )
%FILEOPEN
% [ fail, pszFileName, uFileId, uFileMode, pnItems, pnSubItems, plnFrames, pfFrequency, pszComments, pFileHeader ] = FileOpen( pszFileName, uFileId, uFileMode, pnItems, pnSubItems, plnFrames, pfFrequency, pszComments, pFileHeader )
% This function opens an NDI floating point file, and reads its header.
%   -> pszFileName is the file's name to be opened
%   -> uFileId is a number you assign to the open file.
%   -> uFileMode can be the following:
%       1: OPEN_READ: Open the file as read-only
%       2: OPEN_WRITE: This setting allows you to tinker with the file.
%   -> pnItems tells you how many items are in the tile. Refer to the file format docs for this.
%   -> pnSubItems tells you how many sub-items are in the file. Refer to the file format docs for this.
%   -> pnFrames tells you how many data frames are in the file
%   -> pfFrequency tells you the sampling rate
%   -> pfzComments will contain the comment field in the file you are reading
%   -> pFileHeader is a C file pointer, pointing to the header of the NDI floating point file.
% Important:
%       -This function can only open 16 files at the same time.
%       -When you open the file in read-write mode, you can meddle with its header only, and not its data.
%       -While NDI gave you the file pointer to provide low-level access to the file header, they recommend not using it.
%   fail is the return value of the function. The API docs don't go into details on what this does.
%   So, 0 for all good, and pretty much anything else for fail.

    % Prepare pointer inputs
    szFileName_pointer = libpointer('cstring', pszFileName);
    nItems_pointer = libpointer('int32Ptr', pnItems);
    nSubItems_pointer = libpointer('int32Ptr', pnSubItems);
    lnFrames_pointer = libpointer('longPtr', plnFrames);
    fFrequency_pointer = libpointer('singlePtr', pfFrequency);
    szComments_pointer = libpointer('cstring', pszComments);
    FileHeader_pointer = libpointer('voidPtrPtr', pFileHeader);

    if(isunix)
        fail = calllib('liboapi', 'FileOpen', szFileName_pointer, uFileId, uFileMode, nItems_pointer, nSubItems_pointer, lnFrames_pointer, fFrequency_pointer, szComments_pointer, FileHeader_pointer);
    else
        if(new_or_old)
            fail = calllib('oapi64', 'FileOpen', szFileName_pointer, uFileId, uFileMode, nItems_pointer, nSubItems_pointer, lnFrames_pointer, fFrequency_pointer, szComments_pointer, FileHeader_pointer);
        else
            fail = calllib('oapi', 'FileOpen', szFileName_pointer, uFileId, uFileMode, nItems_pointer, nSubItems_pointer, lnFrames_pointer, fFrequency_pointer, szComments_pointer, FileHeader_pointer);
        end
    end

    % Get updated data with the pointer
    pszFileName = get(szFileName_pointer, 'Value');
    pnItems = get(nItems_pointer, 'Value');
    pnSubItems = get(nSubItems_pointer, 'Value');
    plnFrames = get(lnFrames_pointer, 'Value');
    pfFrequency = get(fFrequency_pointer, 'Value');
    pszComments = get(szComments_pointer, 'Value');
    pFileHeader = get(FileHeader_pointer, 'Value');

    % Clean up pointers so Matlab won't crash on repeated use of this function
    clear szFileName_pointer nItems_pointer nSubItems_pointer lnFrames_pointer fFrequency_pointer szComments_pointer FileHeader_pointer;
end

