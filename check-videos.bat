@echo off
pushd E:\Downloads\

setlocal EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

rem set path for going back to origina folder
set mypath=%cd%
set logfile=E:\bad_videos.log

rem show help menu
echo.
echo Check Video Integrity
echo.
echo.
echo Windows .bat script that checks video file integrity using ffmpeg.exe. 
echo.
echo Before you start the integrity check for the first time, you must edit the .bat script and replace the folder-adress in the second command line with the network- or desktop-folder address of your video folder. Then copy ffmpeg.exe into this video folder (get it here: https://ffmpeg.zeranoe.com/builds/ ). 
echo.
echo When you start the .bat script, all video files in your video folder and its subfolders will be checked and a log file will be created for each corrupted video file. To speed processing, ffmpeg.exe checks the audio stream for errors, instead of processing the entire file. This is usually enough to determine if a video is corrupt due to a stopped download, extraction or something similar. 
echo.
echo Punctuations in the file names may give false positives. If you have many video files, starting could take a few minutes.
pause
echo.

rem start scanning
echo.
echo Start Scanning Videos in Folder
echo.

rem loop thru all video files found in folder
FOR /F "delims=*" %%G in ('dir /b /s *.mkv *.mp4 *.mpg *.mpeg *.xvid *.webm *.m2v *.m4v *.3gp *.3g2 *.avi *.mov *.flv *.wmv') DO (

    rem display which video file we are verifying/scanning
    echo Scanning [%%~nG1]
	rem echo Verifying "%%G"
    
    rem use ffmpeg to check for errors and pass those errors to the log file
	ffmpeg -v error -i "%%G" -map 0:1 -f null - 2>"%logfile%"
	
    rem loop thru lines in the text log file
    FOR %%F in ("%logfile%") DO (
		
        rem check for error codes in the log file and show the result
        if %%~zF equ 0 (
          
            rem delete line from file
			del %%F
            
            rem show message
			call :colour 0a " -- Video is good"
			echo.
			echo. 
            
		) else (
			
            rem show message
            call :colour 0c " -- Error in video file:"
			echo.
            
            rem show error message details
			type %%F
			
            rem show where error can be found
            call :colour 0e " -- This can be found in the bad_videos.log file"
			echo.
			echo.
		)
        rem end if
	)
    rem end loop
    
)
rem end loop

rem show that we are completed
call :colour 0a "Verifying complete!" && echo.
pause
cd %mypath%
exit /b

:colour
set "param=^%~2" !
set "param=!param:"=\"!"
rem Prepare a file "X" with only one dot
<nul > X set /p ".=."
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
rem Delete "X" file
del X
exit /b
