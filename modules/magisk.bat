@echo off
chcp 65001 >nul
title 白叶一键工具 - Magisk Root中心
color 0A

call "%~dp0..\common.bat"

if not exist "%LOG%" mkdir "%LOG%"


:menu

cls

echo =====================================
echo          白叶一键工具
echo            Magisk Root中心
echo =====================================
echo.

echo 1. 检测设备Root状态
echo 2. 提取boot镜像
echo 3. 修补boot镜像
echo 4. 刷入Magisk boot
echo 5. 刷入vbmeta
echo 6. 安装Magisk APK
echo 7. 查看设备信息
echo.
echo 0. 返回
echo.


set /p choice=请选择:


if "%choice%"=="1" goto root_check
if "%choice%"=="2" goto dump_boot
if "%choice%"=="3" goto patch_boot
if "%choice%"=="4" goto flash_boot
if "%choice%"=="5" goto flash_vbmeta
if "%choice%"=="6" goto install_magisk
if "%choice%"=="7" goto info

if "%choice%"=="0" exit


goto menu





:root_check

cls

echo ===== Root状态 =====


adb shell id


adb shell su -c "id"


pause

goto menu






:dump_boot

cls

echo ===== 提取boot =====

echo.

echo 当前支持:
echo Fastboot设备
echo Recovery设备


fastboot devices


echo.


set /p PART=输入boot分区:

fastboot dump "%PART%" "%FIRMWARE%\boot.img"


echo.

echo 完成:

echo %FIRMWARE%\boot.img


pause

goto menu






:patch_boot

cls

echo =================================
echo        Magisk修补boot
echo =================================
echo.


echo 请使用Magisk App:
echo.
echo 选择:
echo 修补文件
echo.
echo 选择:
echo boot.img
echo.


pause


echo 修补完成后:
echo 将magisk_patched.img放入:

echo %FIRMWARE%


pause

goto menu





:flash_boot

cls


if not exist "%FIRMWARE%\magisk_patched.img" (

echo 未找到:

echo magisk_patched.img

pause

goto menu

)


fastboot flash boot "%FIRMWARE%\magisk_patched.img"


echo.

echo Magisk boot刷入完成


pause

goto menu






:flash_vbmeta

cls


if not exist "%FIRMWARE%\vbmeta.img" (

echo 未找到vbmeta.img

pause

goto menu

)


fastboot flash vbmeta "%FIRMWARE%\vbmeta.img" --disable-verity --disable-verification


echo.

echo vbmeta完成


pause

goto menu






:install_magisk

cls

echo 安装Magisk APK


set /p APK=请输入Magisk APK路径:


if not exist "%APK%" (

echo 文件不存在

pause

goto menu

)


adb install "%APK%"


pause

goto menu






:info

cls

adb shell getprop


pause

goto menu