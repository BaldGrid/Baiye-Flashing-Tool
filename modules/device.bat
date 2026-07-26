@echo off
chcp 65001 >nul
title 白叶一键工具 - 设备信息中心
color 0A

call "%~dp0..\common.bat"

:menu

cls

echo ====================================
echo          白叶一键工具
echo           设备信息中心
echo ====================================
echo.


echo 1. 自动检测设备模式
echo 2. ADB设备信息
echo 3. Fastboot设备信息
echo 4. 导出设备报告
echo 5. 查看电池信息
echo 6. 查看存储信息
echo.
echo 0. 返回主菜单
echo.


set /p choice=请选择:


if "%choice%"=="1" goto detect
if "%choice%"=="2" goto adb
if "%choice%"=="3" goto fastboot
if "%choice%"=="4" goto report
if "%choice%"=="5" goto battery
if "%choice%"=="6" goto storage
if "%choice%"=="0" exit


goto menu




:detect

cls

echo =====设备模式检测=====
echo.


adb get-state >nul 2>&1

if %errorlevel%==0 (

echo.
echo [√] 当前模式:
echo ADB模式

pause
goto menu

)


fastboot devices >nul 2>&1

if %errorlevel%==0 (

echo.
echo [√] 当前模式:
echo Fastboot模式

pause
goto menu

)


echo.
echo [×] 未发现设备

pause

goto menu





:adb

cls

echo =====ADB设备信息=====
echo.


adb devices


echo.
echo --------基本信息--------

adb shell getprop ro.product.manufacturer

adb shell getprop ro.product.brand

adb shell getprop ro.product.model

adb shell getprop ro.product.device


echo.
echo --------系统信息--------

adb shell getprop ro.build.version.release

adb shell getprop ro.build.version.sdk

adb shell getprop ro.build.display.id


echo.
echo --------硬件信息--------

adb shell getprop ro.board.platform

adb shell getprop ro.hardware


echo.
echo --------内核--------

adb shell uname -a


pause

goto menu





:fastboot

cls

echo =====Fastboot信息=====
echo.


fastboot devices


echo.

fastboot getvar product

fastboot getvar unlocked

fastboot getvar secure


pause

goto menu





:report

cls

if not exist "%LOG%" mkdir "%LOG%"


set FILE=%LOG%\device_report.txt


echo 白叶一键工具设备报告 > "%FILE%"

echo ===================== >> "%FILE%"


echo.
echo 正在生成报告...


echo. >> "%FILE%"

echo [ADB信息] >> "%FILE%"

adb shell getprop >> "%FILE%" 2>nul


echo. >> "%FILE%"

echo [Fastboot信息] >> "%FILE%"

fastboot getvar all >> "%FILE%" 2>&1



echo.

echo 报告生成:

echo %FILE%


pause

goto menu





:battery

cls

echo =====电池信息=====


adb shell dumpsys battery


pause

goto menu





:storage

cls

echo =====存储信息=====


adb shell df -h


pause

goto menu