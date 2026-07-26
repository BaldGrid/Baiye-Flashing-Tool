@echo off
chcp 65001 >nul
setlocal

title 白叶一键工具 - Recovery中心
color 0A

call "%~dp0..\common.bat"

if not exist "%LOG%" mkdir "%LOG%"



:menu

cls

echo =====================================
echo          白叶一键工具
echo            Recovery中心
echo =====================================
echo.


echo 1. 检测设备

echo 2. 重启进入Recovery

echo 3. 临时启动Recovery

echo 4. 刷入Recovery

echo 5. ADB Sideload刷机

echo 6. 拉取Recovery日志

echo 7. 查看Recovery分区

echo.

echo 0. 返回


echo.

set /p R=请选择:


if "%R%"=="1" goto detect

if "%R%"=="2" goto reboot

if "%R%"=="3" goto boot

if "%R%"=="4" goto flash

if "%R%"=="5" goto sideload

if "%R%"=="6" goto log

if "%R%"=="7" goto partition

if "%R%"=="0" exit


goto menu






:detect

cls

echo =====设备状态=====


adb devices


echo.


fastboot devices


pause

goto menu






:reboot

cls

echo 正在进入Recovery...


adb reboot recovery


pause

goto menu






:boot

cls

echo =================================
echo       临时启动Recovery
echo =================================
echo.


echo 示例:
echo recovery.img


set /p IMG=请输入Recovery镜像:


if not exist "%IMG%" (

echo 文件不存在

pause

goto menu

)



fastboot boot "%IMG%"


pause

goto menu






:flash

cls

echo =================================
echo          刷入Recovery
echo =================================
echo.


echo 支持:

echo recovery.img

echo vendor_boot.img


echo.


set /p IMG=镜像路径:


if not exist "%IMG%" (

echo 文件不存在

pause

goto menu

)



echo.

echo 选择分区:

echo 1. recovery

echo 2. vendor_boot


set /p PART=:



if "%PART%"=="1" (

fastboot flash recovery "%IMG%"

)



if "%PART%"=="2" (

fastboot flash vendor_boot "%IMG%"

)



echo.

echo 完成


pause

goto menu






:sideload

cls

echo =================================
echo          ADB Sideload
echo =================================
echo.


echo 请进入Recovery:

echo Apply update from ADB


pause


adb devices


echo.


set /p ZIP=ZIP文件路径:


if not exist "%ZIP%" (

echo 文件不存在

pause

goto menu

)



adb sideload "%ZIP%"


echo.

echo Sideload完成


pause

goto menu






:log

cls


echo 保存Recovery日志...


adb shell dmesg > "%LOG%\recovery_dmesg.txt"


adb logcat -d > "%LOG%\recovery_logcat.txt"



echo 完成:

echo %LOG%


pause

goto menu






:partition

cls


echo =====Recovery分区=====


adb shell ls -l /dev/block/by-name


pause

goto menu