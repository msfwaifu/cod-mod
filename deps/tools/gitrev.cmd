@echo off

IF NOT EXIST lastrev.txt (
    echo Unknown Revision > lastrev.txt
)

FOR /F %%H IN (lastrev.txt) DO SET LASTREVISION=%%H

IF EXIST "C:\Program Files\Git\bin\git.exe" (
    SET FOUNDGIT="C:\Program Files\Git\bin\git.exe"
) ELSE IF EXIST "C:\Program Files (x86)\Git\bin\git.exe" (
    SET FOUNDGIT="C:\Program Files (x86)\Git\bin\git.exe"
) ELSE IF EXIST "%PROGRAMFILES%\Git\bin\git.exe" (
    SET FOUNDGIT="%PROGRAMFILES%\Git\bin\git.exe"
) ELSE IF EXIST "%PROGRAMFILES(x86)%\Git\bin\git.exe" (
    SET FOUNDGIT="%PROGRAMFILES(x86)%\Git\bin\git.exe"
) ELSE (
    goto fail
)

%FOUNDGIT% rev-list HEAD --count > lastrev.txt

FOR /F %%H IN (lastrev.txt) DO SET REVISION=%%H

echo Current revision is %REVISION%
echo Last revision is %LASTREVISION%

IF %REVISION% NEQ %LASTREVISION% (
    echo // generated by gitrev.cmd > ..\..\code\buildnumber.h
    echo #define COMMIT %REVISION% >> ..\..\code\buildnumber.h
    echo #define COMMIT_STR "%REVISION%" >> ..\..\code\buildnumber.h
    echo #define BUILDHOST "%COMPUTERNAME%" >> ..\..\code\buildnumber.h
)

goto exit

:fail
echo Couldn't Update Buildnumber
echo msgbox"Please install git in order to compile this code!">a.vbs&a.vbs
START "" "http://git-scm.com/download/win" 
IF EXIST a.vbs (
    del a.vbs
)

:exit