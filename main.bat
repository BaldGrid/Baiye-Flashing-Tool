@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

title 白叶一键工具
color 0A

call "%~dp0..\common.bat"

if not exist "%LOG%" mkdir "%LOG%"



:main

cls

call "%MODULE%\logo.bat"

call :device_check


echo.
echo -----------------------------------------
echo.


echo 1. ADB工具

echo 2. Fastboot工具

echo 3. 刷机中心

echo 4. Qualcomm高通工具

echo 5. Recovery工具

echo 6. 重启管理

echo 7. 分区管理

echo 8. Magisk Root

echo 9. BL解锁

echo 10. 备份中心

echo 11. 设置中心

echo 12. 日志中心


echo.

echo 0. 退出


echo.

set /p M=请选择功能:


if "%M%"=="1" call "%MODULE%\adb.bat"

if "%M%"=="2" call "%MODULE%\fastboot.bat"

if "%M%"=="3" call "%MODULE%\flash.bat"

if "%M%"=="4" call "%MODULE%\qualcomm.bat"

if "%M%"=="5" call "%MODULE%\recovery.bat"

if "%M%"=="6" call "%MODULE%\reboot.bat"

if "%M%"=="7" call "%MODULE%\partition.bat"

if "%M%"=="8" call "%MODULE%\magisk.bat"

if "%M%"=="9" call "%MODULE%\unlock.bat"

if "%M%"=="10" call "%MODULE%\backup.bat"

if "%M%"=="11" call "%MODULE%\settings.bat"

if "%M%"=="12" call "%MODULE%\logs.bat"


if "%M%"=="0" goto exit



goto main






::=================================
::设备检测
::=================================


:device_check


echo 设备状态:


adb get-state >nul 2>&1


if %errorlevel%==0 (

echo [√] ADB 已连接

) else (

echo [ ] ADB 未连接

)



fastboot devices | findstr "." >nul


if %errorlevel%==0 (

echo [√] Fastboot 已连接

) else (

echo [ ] Fastboot 未连接

)



if exist "%BIN%\edl.exe" (

echo [√] Qualcomm EDL

) else (

echo [ ] Qualcomm EDL

)



if exist "%BIN%\magiskboot.exe" (

echo [√] Magisk工具

) else (

echo [ ] Magisk工具

)


exit /b





:exit


cls

echo.

echo 感谢使用白叶一键工具

echo.

echo Bye!


timeout /t 2 >nul


exit