@echo off
chcp 65001 >nul
title 白叶一键工具 - 重启管理
color 0A

call "%~dp0..\common.bat"

:menu

cls

echo =====================================
echo          白叶一键工具
echo             重启管理
echo =====================================
echo.


echo 当前设备状态:


adb get-state >nul 2>&1

if %errorlevel%==0 (
echo [√] ADB设备在线
) else (
echo [ ] ADB未连接
)


fastboot devices | findstr "." >nul

if %errorlevel%==0 (
echo [√] Fastboot设备在线
) else (
echo [ ] Fastboot未连接
)


echo.

echo -------------------------------------

echo 1. 重启系统 Android
-

echo 5. 重启 EDL 9008

echo 6. Qualcomm退出9008

echo.

echo 0. 返回


echo.

set /p R=请选择:


if "%R%"=="1" goto system

if "%R%"=="2" goto recovery

if "%R%"=="3" goto bootloader

if "%R%"=="4" goto fastbootd

if "%R%"=="5" goto edl

if "%R%"=="6" goto edl_exit

if "%R%"=="0" exit


goto menu






:system

cls

echo 正在重启系统...


adb reboot


pause

goto menu





:recovery

cls

echo 正在进入Recovery...


adb reboot recovery


pause

goto menu





:bootloader

cls

echo 正在进入Bootloader...


adb reboot bootloader


pause

goto menu





:fastbootd

cls

echo 正在进入FastbootD...


adb reboot fastboot


pause

goto menu





:edl

cls

echo =================================
echo       Qualcomm EDL模式
echo =================================


echo.

echo 方法1:
echo adb reboot edl


echo.

adb reboot edl



echo.

echo 如果失败:
echo 请使用9008工具


pause

goto menu






:edl_exit

cls


echo 正在退出9008...


if exist "%BIN%\edl.exe" (

edl reset

) else (

echo 未找到edl.exe

)


pause

goto menu