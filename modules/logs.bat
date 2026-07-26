@echo off
chcp 65001 >nul
title 白叶一键工具 - 日志中心
color 0A

call "%~dp0..\common.bat"

if not exist "%LOG%" mkdir "%LOG%"



:menu

cls

echo ====================================
echo          白叶一键工具
echo             日志中心
echo ====================================
echo.

echo 日志目录:
echo %LOG%

echo.

echo 1. 保存ADB日志
echo 2. 保存设备信息
echo 3. 保存Fastboot日志
echo 4. 保存EDL日志
echo 5. 查看日志文件
echo 6. 打开日志目录
echo 7. 清理日志
echo.
echo 0. 返回主菜单
echo.


set /p choice=请选择:


if "%choice%"=="1" goto adb_log
if "%choice%"=="2" goto device_log
if "%choice%"=="3" goto fastboot_log
if "%choice%"=="4" goto edl_log
if "%choice%"=="5" goto view
if "%choice%"=="6" goto open
if "%choice%"=="7" goto clear

if "%choice%"=="0" exit


goto menu





:time

for /f "tokens=1-3 delims=/ " %%a in ("%date%") do (

set TODAY=%%a-%%b-%%c

)

exit /b





:adb_log

cls

call :time


echo 正在保存ADB日志...


adb logcat -d > "%LOG%\%TODAY%_adb_log.txt"


echo 完成:

echo %LOG%\%TODAY%_adb_log.txt


pause

goto menu






:device_log

cls

call :time


echo 保存设备信息...


adb shell getprop > "%LOG%\%TODAY%_device_prop.txt"

adb shell uname -a >> "%LOG%\%TODAY%_device_prop.txt"


echo 完成


pause

goto menu






:fastboot_log

cls

call :time


echo 保存Fastboot信息...


fastboot getvar all > "%LOG%\%TODAY%_fastboot.txt" 2>&1


echo 完成


pause

goto menu





:edl_log

cls

call :time


echo 保存EDL信息...


if exist "%BIN%\edl.exe" (

edl printgpt > "%LOG%\%TODAY%_edl.txt"

) else (

echo 未找到edl工具

)


pause

goto menu





:view

cls

echo =====日志列表=====

dir "%LOG%" /b


pause

goto menu






:open

start "" "%LOG%"

goto menu






:clear

cls

echo 注意:
echo 将删除所有日志

pause


del /q "%LOG%\*.*"


echo 清理完成


pause

goto menu