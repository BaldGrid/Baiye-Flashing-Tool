@echo off
chcp 65001 >nul
title 白叶一键工具 - 全能刷机中心
color 0A

call "%~dp0..\common.bat"

if not exist "%LOG%" mkdir "%LOG%"



:menu

cls

echo =========================================
echo.
echo          白叶一键工具
echo.
echo            全能刷机中心
echo.
echo =========================================
echo.


call :detect



echo.
echo -----------------------------------------
echo.
echo 1. Fastboot刷机
echo.
echo 2. Qualcomm 9008 EDL刷机
echo.
echo 3. Qualcomm 9006模式
echo.
echo 4. ADB Sideload刷机
echo.
echo 5. 官方flash_all脚本
echo.
echo 6. 固件文件管理
echo.
echo 7. 设备模式检测
echo.
echo 8. 查看刷机日志
echo.
echo 0. 返回
echo.
echo -----------------------------------------


set /p choice=请选择:


if "%choice%"=="1" goto fastboot

if "%choice%"=="2" goto edl9008

if "%choice%"=="3" goto edl9006

if "%choice%"=="4" goto sideload

if "%choice%"=="5" goto flashscript

if "%choice%"=="6" goto firmware

if "%choice%"=="7" goto detectmenu

if "%choice%"=="8" goto logs

if "%choice%"=="0" exit


goto menu






:detect

echo 当前设备状态:

adb get-state >nul 2>&1

if %errorlevel%==0 (

echo [√] ADB设备

) else (

echo [ ] ADB设备

)



fastboot devices | findstr "." >nul

if %errorlevel%==0 (

echo [√] Fastboot设备

) else (

echo [ ] Fastboot设备

)



if exist "%BIN%\edl.exe" (

echo [√] EDL工具

) else (

echo [ ] EDL工具

)


exit /b





:detectmenu

cls

echo =================================
echo        设备模式检测
echo =================================


call :detect


echo.

pause

goto menu

:fastboot

cls

echo =========================================
echo          白叶一键工具
echo           Fastboot刷机
echo =========================================
echo.


echo 1. 检测Fastboot设备
echo 2. 查看设备信息
echo.
echo 3. 刷入boot.img
echo 4. 刷入init_boot.img
echo 5. 刷入vendor_boot.img
echo 6. 刷入vbmeta.img
echo 7. 刷入vbmeta_system.img
echo 8. 刷入dtbo.img
echo 9. 刷入recovery.img
echo 10. 刷入super.img
echo 11. 刷入userdata.img
echo.
echo 12. 自动刷入已有镜像
echo 13. 自定义刷写
echo 14. 擦除分区
echo 15. 重启设备
echo.
echo 0. 返回
echo.


set /p fb=请选择:


if "%fb%"=="1" goto fb_device
if "%fb%"=="2" goto fb_info

if "%fb%"=="3" goto flash_boot
if "%fb%"=="4" goto flash_initboot
if "%fb%"=="5" goto flash_vendorboot
if "%fb%"=="6" goto flash_vbmeta
if "%fb%"=="7" goto flash_vbmetasystem
if "%fb%"=="8" goto flash_dtbo
if "%fb%"=="9" goto flash_recovery
if "%fb%"=="10" goto flash_super
if "%fb%"=="11" goto flash_userdata

if "%fb%"=="12" goto auto_flash
if "%fb%"=="13" goto custom_flash
if "%fb%"=="14" goto erase
if "%fb%"=="15" goto reboot

if "%fb%"=="0" goto menu


goto fastboot





:fb_device

cls

echo ===== Fastboot设备 =====

fastboot devices

pause

goto fastboot






:fb_info

cls

echo ===== Fastboot设备信息 =====


fastboot getvar product

fastboot getvar all > "%LOG%\fastboot_info.txt" 2>&1


echo.

echo 信息已保存:
echo %LOG%\fastboot_info.txt


pause

goto fastboot

:flash_boot

cls

call :check_fastboot

if errorlevel 1 goto fastboot


if not exist "%FIRMWARE%\boot.img" (

echo 未找到:
echo %FIRMWARE%\boot.img

pause

goto fastboot

)


echo 正在刷入 boot.img...


fastboot flash boot "%FIRMWARE%\boot.img"


pause

goto fastboot





:flash_initboot

cls

call :check_fastboot


if not exist "%FIRMWARE%\init_boot.img" (

echo 未找到:
echo init_boot.img

pause

goto fastboot

)


fastboot flash init_boot "%FIRMWARE%\init_boot.img"


pause

goto fastboot





:flash_vendorboot

cls

call :check_fastboot


if not exist "%FIRMWARE%\vendor_boot.img" (

echo 未找到:
echo vendor_boot.img

pause

goto fastboot

)


fastboot flash vendor_boot "%FIRMWARE%\vendor_boot.img"


pause

goto fastboot






:flash_vbmeta

cls

call :check_fastboot


if not exist "%FIRMWARE%\vbmeta.img" (

echo 未找到:
echo vbmeta.img

pause

goto fastboot

)


fastboot flash vbmeta "%FIRMWARE%\vbmeta.img"


pause

goto fastboot






:flash_vbmetasystem

cls

call :check_fastboot


if not exist "%FIRMWARE%\vbmeta_system.img" (

echo 未找到:
echo vbmeta_system.img

pause

goto fastboot

)


fastboot flash vbmeta_system "%FIRMWARE%\vbmeta_system.img"


pause

goto fastboot





:flash_dtbo

cls

call :check_fastboot


if not exist "%FIRMWARE%\dtbo.img" (

echo 未找到:
echo dtbo.img

pause

goto fastboot

)


fastboot flash dtbo "%FIRMWARE%\dtbo.img"


pause

goto fastboot





:flash_recovery

cls

call :check_fastboot


if not exist "%FIRMWARE%\recovery.img" (

echo 未找到:
echo recovery.img

pause

goto fastboot

)


fastboot flash recovery "%FIRMWARE%\recovery.img"


pause

goto fastboot





:flash_super

cls

call :check_fastboot


if not exist "%FIRMWARE%\super.img" (

echo 未找到:
echo super.img

pause

goto fastboot

)


echo 正在刷入super分区...


fastboot wipe-super super

fastboot flash super "%FIRMWARE%\super.img"


pause

goto fastboot






:flash_userdata

cls

call :check_fastboot


if not exist "%FIRMWARE%\userdata.img" (

echo 未找到:
echo userdata.img

pause

goto fastboot

)


fastboot flash userdata "%FIRMWARE%\userdata.img"


pause

goto fastboot

:auto_flash

cls

call :check_fastboot

if errorlevel 1 goto fastboot

echo =========================================
echo        自动识别并刷写镜像
echo =========================================
echo.

if exist "%FIRMWARE%\boot.img" (
    echo [+] boot.img
    fastboot flash boot "%FIRMWARE%\boot.img"
)

if exist "%FIRMWARE%\init_boot.img" (
    echo [+] init_boot.img
    fastboot flash init_boot "%FIRMWARE%\init_boot.img"
)

if exist "%FIRMWARE%\vendor_boot.img" (
    echo [+] vendor_boot.img
    fastboot flash vendor_boot "%FIRMWARE%\vendor_boot.img"
)

if exist "%FIRMWARE%\vbmeta.img" (
    echo [+] vbmeta.img
    fastboot flash vbmeta "%FIRMWARE%\vbmeta.img"
)

if exist "%FIRMWARE%\vbmeta_system.img" (
    echo [+] vbmeta_system.img
    fastboot flash vbmeta_system "%FIRMWARE%\vbmeta_system.img"
)

if exist "%FIRMWARE%\dtbo.img" (
    echo [+] dtbo.img
    fastboot flash dtbo "%FIRMWARE%\dtbo.img"
)

if exist "%FIRMWARE%\recovery.img" (
    echo [+] recovery.img
    fastboot flash recovery "%FIRMWARE%\recovery.img"
)

if exist "%FIRMWARE%\super.img" (
    echo [+] super.img
    fastboot wipe-super super
    fastboot flash super "%FIRMWARE%\super.img"
)

echo.
echo 自动刷写完成。
pause
goto fastboot



:custom_flash

cls

echo ========= 自定义刷写 =========
echo.
echo 示例：
echo 分区：boot
echo 镜像：D:\boot.img
echo.

set /p PART=请输入分区名称：
set /p IMG=请输入镜像路径：

if not exist "%IMG%" (
    echo.
    echo [错误] 镜像不存在！
    pause
    goto fastboot
)

fastboot flash %PART% "%IMG%"

pause
goto fastboot



:erase

cls

echo ========= 擦除分区 =========
echo.
echo 示例：
echo userdata
echo cache
echo metadata
echo.

set /p ERASE=请输入分区：

fastboot erase %ERASE%

pause
goto fastboot



:reboot

cls

echo 1. 重启系统
echo 2. 重启Recovery
echo 3. 重启Bootloader
echo 4. 重启FastbootD
echo.

set /p RB=请选择：

if "%RB%"=="1" fastboot reboot
if "%RB%"=="2" fastboot reboot recovery
if "%RB%"=="3" fastboot reboot bootloader
if "%RB%"=="4" fastboot reboot fastboot

pause
goto fastboot



:flashscript

cls

echo =========================================
echo         官方刷机脚本
echo =========================================
echo.
echo 请将 flash_all.bat
echo 或 flash_all_lock.bat
echo 或其他官方 .bat 拖入窗口
echo.

set /p SCRIPT=脚本路径：

if "%SCRIPT%"=="" goto menu

if not exist "%SCRIPT%" (
    echo.
    echo [错误] 文件不存在！
    pause
    goto menu
)

echo.
echo 正在执行：
echo %SCRIPT%
echo.

call "%SCRIPT%"

echo.
echo 官方脚本执行完成。

pause
goto menu



:check_fastboot

fastboot devices | findstr "." >nul

if errorlevel 1 (
    echo.
    echo [错误] 未检测到 Fastboot 设备！
    echo.
    pause
    exit /b 1
)

exit /b 0

:edl_flash

cls

echo =========================================
echo        Qualcomm 9008 EDL刷机
echo =========================================
echo.

echo 请把高通刷机包文件夹拖入窗口
echo 或输入完整路径
echo.

set /p EDL_PATH=刷机包目录:


if "%EDL_PATH%"=="" goto edl9008


if not exist "%EDL_PATH%" (

echo.
echo [错误] 目录不存在

pause

goto edl9008

)


echo.
echo 当前刷机包:
echo %EDL_PATH%

echo.


echo 正在搜索文件...


set FIREHOSE=
set RAWPROGRAM=
set PATCH=


for /r "%EDL_PATH%" %%a in (*.mbn) do (

if not defined FIREHOSE set FIREHOSE=%%a

)


for /r "%EDL_PATH%" %%a in (rawprogram*.xml) do (

if not defined RAWPROGRAM set RAWPROGRAM=%%a

)


for /r "%EDL_PATH%" %%a in (patch*.xml) do (

if not defined PATCH set PATCH=%%a

)



echo.

echo Firehose:
echo %FIREHOSE%

echo.

echo Rawprogram:
echo %RAWPROGRAM%

echo.

echo Patch:
echo %PATCH%


echo.


if "%FIREHOSE%"=="" (

echo 未找到Firehose文件

pause

goto edl9008

)


if "%RAWPROGRAM%"=="" (

echo 未找到rawprogram文件

pause

goto edl9008

)


if "%PATCH%"=="" (

echo 未找到patch文件

pause

goto edl9008

)



echo.

echo 开始刷写...

echo.


edl rawprogram "%RAWPROGRAM%" patch "%PATCH%"



echo.

echo =================================
echo       EDL刷写完成
echo =================================


pause

goto menu