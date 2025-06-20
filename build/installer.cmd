@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
CLS

TITLE Creating LAV Filters Installer

IF [%1] == [] EXIT /B 404

IF "%programfiles(x86)%XXX"=="XXX" GOTO 32BIT
    :: 64-bit
    SET PROGS=%programfiles(x86)%
    GOTO CONT
:32BIT
    SET PROGS=%ProgramFiles%
:CONT

IF NOT EXIST "%PROGS%\Team MediaPortal\MediaPortal\" SET PROGS=C:

:: Get version
SET i=1
SET "x=%1"
SET "x!i!=%x:.=" & SET /A i+=1 & SET "x!i!=%"

SET VERSION=
IF [%x1%] == [] (SET VERSION=0) ELSE (SET VERSION=%x1%)
IF [%x2%] == [] (SET VERSION=%VERSION%.0) ELSE (SET VERSION=%VERSION%.%x2%)
IF [%x3%] == [] (SET VERSION=%VERSION%.0) ELSE (SET VERSION=%VERSION%.%x3%)
IF [%x4%] == [] (SET VERSION=%VERSION%.0) ELSE (SET VERSION=%VERSION%.%x4%)

:: Temp xmp2 file
COPY ..\LAV\LAVFilters.xmp2 ..\LAV\LAVFiltersTemp.xmp2

CD ..\LAV
:: Prepare for Build
"..\Tools\Tools\sed.exe" -i "s/0.0.0-Installer/%1-Installer/g" LAVFiltersTemp.xmp2
"..\Tools\Tools\sed.exe" -i "s/v0.0.0/v%1/g" LAVFiltersTemp.xmp2

:: Build MPE1
ECHO Build MPE1 - %1 - %VERSION%

"%PROGS%\Team MediaPortal\MediaPortal\MPEMaker.exe" LAVFiltersTemp.xmp2 /B /V=%VERSION% /UpdateXML
CD ..\build

:: Cleanup
DEL ..\LAV\LAVFiltersTemp.xmp2
