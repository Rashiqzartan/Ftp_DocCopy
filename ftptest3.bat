@echo off

for /f "tokens=1-3 delims=/" %%a in ('powershell.exe -command "(Get-Date).AddDays(-1).ToString('yyyy/MM/dd')"') do (
    set "year=%%a"
    set "month=%%b"
    set "day=%%c"
)
set FOLDER_NAME=%year%%month%%day%

set SOURCE_SERVER=192.88.4.148
set SOURCE_USERNAME=belc
set SOURCE_PASSWORD=belc2017!
set SOURCE_FOLDER=/rashiqtest/%FOLDER_NAME%

set DESTINATION_SERVER=192.88.4.148
set DESTINATION_USERNAME=belc
set DESTINATION_PASSWORD=belc2017!
set DESTINATION_FOLDER=/testftp

REM Temporary folder for storing downloaded files
set TEMP_FOLDER=%TEMP%\ftp_download

REM Create temporary folder if it doesn't exist
if not exist "%TEMP_FOLDER%" mkdir "%TEMP_FOLDER%"

REM Source FTP commands
echo user %SOURCE_USERNAME%> source_ftpcmd.dat
echo %SOURCE_PASSWORD%>> source_ftpcmd.dat
echo binary>> source_ftpcmd.dat
echo cd %SOURCE_FOLDER%>> source_ftpcmd.dat
echo lcd %TEMP_FOLDER%>> source_ftpcmd.dat
echo prompt>> source_ftpcmd.dat
echo mget *.*>> source_ftpcmd.dat
echo pause>> source_ftpcmd.dat
echo quit>> source_ftpcmd.dat



REM Connect to source FTP server and download files
ftp -n -s:source_ftpcmd.dat %SOURCE_SERVER%
del source_ftpcmd.dat

pause

set NEW_FOLDER=%year%%month%%day%

REM Destination FTP commands
echo user %DESTINATION_USERNAME%> destination_ftpcmd.dat
echo %DESTINATION_PASSWORD%>> destination_ftpcmd.dat
echo binary>> destination_ftpcmd.dat
echo cd %DESTINATION_FOLDER%>> destination_ftpcmd.dat
echo prompt>> destination_ftpcmd.dat
echo mkdir %NEW_FOLDER%>> destination_ftpcmd.dat
echo cd %NEW_FOLDER%>> destination_ftpcmd.dat
echo lcd %TEMP_FOLDER%>> destination_ftpcmd.dat
echo mput *.*>> destination_ftpcmd.dat
echo quit>> destination_ftpcmd.dat

REM Connect to destination FTP server and upload files
ftp -n -s:destination_ftpcmd.dat %DESTINATION_SERVER%

del /Q "%TEMP_FOLDER%\*.*"


del destination_ftpcmd.dat

pause