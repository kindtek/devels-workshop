@ECHO off
color 80
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO:
ECHO please confirm admin access
timeout /t 4 
powershell.exe start-process -filepath 'powershell.exe' -ErrorAction SilentlyContinue -Verb RunAs -WindowStyle Hidden -ArgumentList '-Command', 'wt.exe /p /M cmd.exe powershell.exe -windowstyle maximized %USERPROFILE%\dvlp.ps1 `"%KINDTEK_AUTO_BOOT%`"  `"skip`"' > NUL
IF errorlevel 1 ( 
    ECHO:
    ECHO:
    ECHO:
    ECHO:
    ECHO something went wrong. prompting for admin access again but not requiring it ...
    timeout /t 3
    powershell.exe start-process -filepath powershell.exe -WindowStyle Maximized -Wait -ArgumentList '-Command', '%USERPROFILE%\dvlp.ps1 %KINDTEK_AUTO_BOOT% skip' > NUL
    IF errorlevel 1 ( 
        ECHO:
        ECHO:
        ECHO:
        ECHO:        
        ECHO attempting extraordinary measures. results may vary ...
        timeout /t 3
        powershell.exe -Command %USERPROFILE%\dvlp.ps1 %KINDTEK_AUTO_BOOT% skip noadmin > NUL
        IF errorlevel 1 ( 
            ECHO:
            ECHO:
            ECHO:
            ECHO: 
            ECHO exiting ...
            timeout /t 3 
        ) ELSE ( 
            ECHO success^!
            timeout /t 3
        ) 
    ) 
)
