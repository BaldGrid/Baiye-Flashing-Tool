@echo off
chcp 65001 >nul
setlocal

title 白叶一键工具 - BL解锁中心
color 0A

call "%~dp0..\common.bat"

if not exist "%LOG%" mkdir "%LOG%"



:menu

cls

echo =====================================
echo          白叶一键工具
echo            BL解锁中心
echo =====================================
echo.


echo 1. 检测设备状态

echo 2. 查看Bootloader状态

echo 3. 解锁Bootloader

echo 4. 解锁关键分区

echo 5. 重启设备

echo 6. 查看日志


echo.

echo 0. 返回


echo.

set /p U=请选择:


if "%U%"=="1" goto detect

if "%U%"=="2" goto status

if "%U%"=="3" goto unlock

if "%U%"=="4" goto critical

if "%U%"=="5" goto reboot

if "%U%"=="6" goto logs

if "%U%"=="0" exit


goto menu






:detect

cls

echo =====设备检测=====

echo.


adb devices


echo.


fastboot devices


pause

goto menu






:status

cls

echo =====Bootloader状态=====


fastboot getvar unlocked 2>&1


fastboot getvar secure 2>&1


pause

goto menu






:unlock

cls

echo =====================================
echo          解锁Bootloader
echo =====================================
echo.


echo 警告:
echo 解锁会清除用户数据
echo 请确认已经备份


echo.


choice /c YN /m "继续?"


if errorlevel 2 goto menu



echo.

echo 开始解锁...


echo %date% %time% START UNLOCK >> "%LOG%\unlock.log"



fastboot flashing unlock



if errorlevel 1 (

echo.

echo flashing unlock失败

echo 尝试OEM方式...


fastboot oem unlock

)



echo.

echo 解锁命令执行完成


echo %date% %time% END >> "%LOG%\unlock.log"



pause


goto menu






:critical

cls


echo 解锁关键分区:

echo.

echo 适用于部分设备

echo.

choice /c YN /m "继续?"


if errorlevel 2 goto menu



fastboot flashing unlock_critical


pause


goto menu






:reboot

cls


echo.

echo 1. 重启系统

echo 2. 重启Bootloader


set /p RB=:



if "%RB%"=="1" fastboot reboot


if "%RB%"=="2" fastboot reboot bootloader



pause

goto menu






:logs

cls


type "%LOG%\unlock.log" 2>nul


pause

goto menu