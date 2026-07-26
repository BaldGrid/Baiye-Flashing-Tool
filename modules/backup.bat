@echo off
chcp 65001 >nul
title 白叶一键工具 - 备份中心
color 0A

call "%~dp0..\common.bat"

if not exist "%BACKUP%" mkdir "%BACKUP%"
if not exist "%LOG%" mkdir "%LOG%"


:menu
cls

echo ====================================
echo          白叶一键工具
echo             备份中心
echo ====================================
echo.

echo 1. ADB文件备份
echo 2. 备份boot.img
echo 3. 备份vbmeta.img
echo 4. 备份dtbo.img
echo 5. 备份分区表
echo 6. 恢复镜像
echo 7. 查看备份文件
echo.
echo 0. 返回主菜单
echo.

set /p choice=请选择:

if "%choice%"=="1" goto adbbackup
if "%choice%"=="2" goto bootbackup
if "%choice%"=="3" goto vbmetabackup
if "%choice%"=="4" goto dtbobackup
if "%choice%"=="5" goto partition
if "%choice%"=="6" goto restore
if "%choice%"=="7" goto list
if "%choice%"=="0" exit

goto menu


::====================================
:: ADB文件备份
::====================================

:adbbackup
cls

echo =====ADB备份=====
echo.

adb devices

echo.
echo 正在备份应用列表...
adb shell pm list packages > "%BACKUP%\packages.txt"

echo.
echo 正在备份系统属性...
adb shell getprop > "%BACKUP%\system_prop.txt"

echo.
echo 正在备份安装的应用列表...
adb shell pm list packages -3 > "%BACKUP%\user_apps.txt"

echo.
echo 正在备份系统应用列表...
adb shell pm list packages -s > "%BACKUP%\system_apps.txt"

echo.
echo 备份完成！
echo 保存位置: %BACKUP%

pause
goto menu


::====================================
:: 备份boot.img
::====================================

:bootbackup
cls

echo =====备份boot=====

fastboot devices

echo.

set /p slot=请输入分区名称 (例如: boot_a 或 boot_b):

if "%slot%"=="" goto bootbackup

echo.
echo 正在备份 %slot% ...
echo.

fastboot fetch %slot% "%BACKUP%\%slot%.img"

if errorlevel 1 (
    echo.
    echo [警告] fastboot fetch 失败，尝试使用 dd 方式...
    echo 请确保设备在 Recovery 模式下执行
    pause
    goto menu
)

echo.
echo boot镜像备份完成！
echo 保存位置: %BACKUP%\%slot%.img

pause
goto menu


::====================================
:: 备份vbmeta.img
::====================================

:vbmetabackup
cls

echo =====备份vbmeta=====

fastboot devices

echo.

set /p slot=请输入分区名称 (例如: vbmeta_a 或 vbmeta_b):

if "%slot%"=="" goto vbmetabackup

echo.
echo 正在备份 %slot% ...

fastboot fetch %slot% "%BACKUP%\%slot%.img"

if errorlevel 1 (
    echo.
    echo [警告] fastboot fetch 失败，请检查设备连接
    pause
    goto menu
)

echo.
echo vbmeta镜像备份完成！
echo 保存位置: %BACKUP%\%slot%.img

pause
goto menu


::====================================
:: 备份dtbo.img
::====================================

:dtbobackup
cls

echo =====备份dtbo=====

fastboot devices

echo.

set /p slot=请输入分区名称 (例如: dtbo_a 或 dtbo_b):

if "%slot%"=="" goto dtbobackup

echo.
echo 正在备份 %slot% ...

fastboot fetch %slot% "%BACKUP%\%slot%.img"

if errorlevel 1 (
    echo.
    echo [警告] fastboot fetch 失败，请检查设备连接
    pause
    goto menu
)

echo.
echo dtbo镜像备份完成！
echo 保存位置: %BACKUP%\%slot%.img

pause
goto menu


::====================================
:: 备份分区表
::====================================

:partition
cls

echo =====备份分区表=====

echo.
echo 请选择备份方式:
echo 1. ADB (需root)
echo 2. Fastboot
echo 3. Qualcomm EDL

set /p pmode=请选择:

if "%pmode%"=="1" goto part_adb
if "%pmode%"=="2" goto part_fastboot
if "%pmode%"=="3" goto part_edl

goto partition


:part_adb
cls

echo 正在通过ADB获取分区表...

adb shell su -c "ls -l /dev/block/by-name" > "%BACKUP%\partition_table.txt" 2>nul

if errorlevel 1 (
    echo.
    echo [警告] 需要root权限，尝试无root方式...
    adb shell ls -l /dev/block/by-name > "%BACKUP%\partition_table.txt" 2>nul
)

echo.
echo 正在获取分区大小信息...
adb shell su -c "df -h" >> "%BACKUP%\partition_table.txt" 2>nul

echo 分区表已保存:
echo %BACKUP%\partition_table.txt

pause
goto menu


:part_fastboot
cls

echo 正在通过Fastboot获取分区表...

fastboot getvar all > "%BACKUP%\fastboot_partition.txt" 2>&1

echo 分区信息已保存:
echo %BACKUP%\fastboot_partition.txt

pause
goto menu


:part_edl
cls

if not exist "%BIN%\edl.exe" (
    echo [错误] 未找到 edl.exe
    pause
    goto menu
)

echo 正在通过EDL读取GPT...

edl printgpt > "%BACKUP%\edl_gpt.txt" 2>&1

echo GPT分区表已保存:
echo %BACKUP%\edl_gpt.txt

pause
goto menu


::====================================
:: 恢复镜像
::====================================

:restore
cls

echo =====恢复镜像=====
echo.

dir "%BACKUP%\*.img" /b

echo.

set /p img=请输入要恢复的镜像文件名 (例如: boot_a.img):

if "%img%"=="" goto restore

set /p part=请输入目标分区名称 (例如: boot_a):

if "%part%"=="" goto restore

if not exist "%BACKUP%\%img%" (
    echo.
    echo [错误] 镜像文件不存在！
    pause
    goto menu
)

echo.
echo 即将恢复:
echo 镜像: %BACKUP%\%img%
echo 分区: %part%
echo.

choice /c YN /m "确认继续?"

if errorlevel 2 goto menu

echo.
echo 正在恢复 %part% ...

fastboot flash %part% "%BACKUP%\%img%"

if errorlevel 1 (
    echo.
    echo [错误] 恢复失败！
    pause
    goto menu
)

echo.
echo 恢复完成！

pause
goto menu


::====================================
:: 查看备份文件
::====================================

:list
cls

echo =====备份文件列表=====
echo.
echo 保存目录: %BACKUP%
echo.

dir "%BACKUP%" /b /a-d

echo.
echo =====目录结构=====
dir "%BACKUP%" /ad

pause
goto menu


:end
exit