@echo off
chcp 65001 >nul
title 白叶一键工具 - ADB管理
color 0A

call "%~dp0..\common.bat"

:menu
cls

echo ====================================
echo          白叶一键工具
echo             ADB管理
echo ====================================
echo.


adb get-state >nul 2>&1

if %errorlevel% neq 0 (
    echo [!] 当前没有ADB设备
) else (
    echo [+] ADB设备已连接
)

echo.
echo 1. 查看设备
echo 2. 设备详细信息
echo 3. 进入Shell
echo 4. 安装APK
echo 5. 卸载应用
echo 6. 推送文件
echo 7. 拉取文件
echo 8. 截图
echo 9. 录屏
echo 10. 应用列表
echo 11. 清除应用数据
echo 12. 保存Logcat
echo 13. 重启设备
echo.
echo 0. 返回主菜单
echo.


choice /c 123456789ABC D0 /n /m "请选择:"

if %errorlevel%==1 goto devices
if %errorlevel%==2 goto info
if %errorlevel%==3 goto shell
if %errorlevel%==4 goto install
if %errorlevel%==5 goto uninstall
if %errorlevel%==6 goto push
if %errorlevel%==7 goto pull
if %errorlevel%==8 goto screenshot
if %errorlevel%==9 goto record
if %errorlevel%==10 goto apps
if %errorlevel%==11 goto clear
if %errorlevel%==12 goto logcat
if %errorlevel%==13 goto reboot
if %errorlevel%==14 exit


goto menu



:devices

cls
echo =====ADB设备=====

adb devices

pause
goto menu



:info

cls

echo =====设备信息=====

adb shell getprop ro.product.manufacturer
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell getprop ro.build.version.sdk
adb shell getprop ro.board.platform
adb shell getprop ro.bootloader

pause
goto menu



:shell

cls

echo 输入 exit 返回

adb shell

goto menu



:install

cls

set /p apk=请输入APK路径:

adb install "%apk%"

pause
goto menu



:uninstall

cls

set /p pkg=请输入应用包名:

adb uninstall %pkg%

pause
goto menu



:push

cls

set /p local=请输入电脑文件:

set /p remote=请输入手机路径:

adb push "%local%" "%remote%"

pause
goto menu



:pull

cls

set /p remote=请输入手机文件:

set /p local=保存位置:

adb pull "%remote%" "%local%"

pause
goto menu



:screenshot

cls

if not exist "%ROOT%\backup" mkdir "%ROOT%\backup"

adb shell screencap -p /sdcard/baiye_screen.png

adb pull /sdcard/baiye_screen.png "%ROOT%\backup"

echo 截图完成

pause
goto menu



:record

cls

echo 按 Ctrl+C 停止录屏

adb shell screenrecord /sdcard/baiye_record.mp4

pause
goto menu



:apps

cls

adb shell pm list packages

pause
goto menu



:clear

cls

set /p pkg=请输入包名:

adb shell pm clear %pkg%

pause
goto menu



:logcat

cls

if not exist "%ROOT%\logs" mkdir "%ROOT%\logs"

adb logcat -d > "%ROOT%\logs\logcat.txt"

echo 日志已保存:

echo %ROOT%\logs\logcat.txt

pause
goto menu



:reboot

cls

echo 1. 正常重启
echo 2. Recovery
echo 3. Bootloader
echo 4. FastbootD
echo 5. 返回


choice /c 12345


if %errorlevel%==1 adb reboot
if %errorlevel%==2 adb reboot recovery
if %errorlevel%==3 adb reboot bootloader
if %errorlevel%==4 adb reboot fastboot
if %errorlevel%==5 goto menu


pause
goto menu