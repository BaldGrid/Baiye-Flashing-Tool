@echo off
chcp 65001 >nul
title 白叶一键工具 - Fastboot管理
color 0A

call "%~dp0..\common.bat"

:menu

cls

echo ====================================
echo          白叶一键工具
echo            Fastboot管理
echo ====================================
echo.

call :check


echo.
echo 1. 检测Fastboot设备
echo 2. 查看设备信息
echo 3. 刷入boot.img
echo 4. 刷入vbmeta.img
echo 5. 刷入dtbo.img
echo 6. 刷入vendor_boot.img
echo 7. 刷入recovery.img
echo 8. 一键刷入Boot组件
echo 9. 执行flash_all.bat
echo.
echo 10. 解锁BL
echo 11. 锁定BL
echo 12. 擦除分区
echo 13. 进入FastbootD
echo 14. 重启设备
echo.
echo 0. 返回主菜单
echo.


set /p choice=请选择:


if "%choice%"=="1" goto devices
if "%choice%"=="2" goto info
if "%choice%"=="3" goto boot
if "%choice%"=="4" goto vbmeta
if "%choice%"=="5" goto dtbo
if "%choice%"=="6" goto vendorboot
if "%choice%"=="7" goto recovery
if "%choice%"=="8" goto all
if "%choice%"=="9" goto script
if "%choice%"=="10" goto unlock
if "%choice%"=="11" goto lock
if "%choice%"=="12" goto erase
if "%choice%"=="13" goto fastbootd
if "%choice%"=="14" goto reboot
if "%choice%"=="0" exit


goto menu




:check

fastboot devices >nul 2>&1

if %errorlevel%==0 (

echo [√] Fastboot设备已连接

) else (

echo [×] 未检测到Fastboot设备

)

exit /b




:devices

cls

echo ===== Fastboot设备 =====

fastboot devices

pause

goto menu




:info

cls

echo ===== 设备信息 =====


fastboot getvar product

fastboot getvar unlocked

fastboot getvar all


pause

goto menu




:boot

cls

call :needboot

fastboot flash boot "%FIRMWARE%\boot.img"


pause

goto menu




:vbmeta

cls

if not exist "%FIRMWARE%\vbmeta.img" (

echo 找不到vbmeta.img
pause
goto menu

)


fastboot flash vbmeta "%FIRMWARE%\vbmeta.img"


pause

goto menu




:dtbo

cls

fastboot flash dtbo "%FIRMWARE%\dtbo.img"


pause

goto menu




:vendorboot

cls

fastboot flash vendor_boot "%FIRMWARE%\vendor_boot.img"


pause

goto menu




:recovery

cls

fastboot flash recovery "%FIRMWARE%\recovery.img"


pause

goto menu




:all

cls

echo =====一键刷入=====


if exist "%FIRMWARE%\boot.img" (

fastboot flash boot "%FIRMWARE%\boot.img"

)


if exist "%FIRMWARE%\vbmeta.img" (

fastboot flash vbmeta "%FIRMWARE%\vbmeta.img"

)


if exist "%FIRMWARE%\dtbo.img" (

fastboot flash dtbo "%FIRMWARE%\dtbo.img"

)


if exist "%FIRMWARE%\vendor_boot.img" (

fastboot flash vendor_boot "%FIRMWARE%\vendor_boot.img"

)


echo 完成

pause

goto menu





:script

cls

echo 将flash_all.bat拖入窗口
echo 或输入完整路径

set /p file=路径:


if not exist "%file%" (

echo 文件不存在

pause

goto menu

)


call "%file%"


pause

goto menu





:unlock

cls

echo 注意:
echo 解锁BL会清除数据

pause


fastboot flashing unlock


pause

goto menu





:lock

cls

echo 注意:
echo 锁BL可能导致无法启动


pause


fastboot flashing lock


pause

goto menu




:erase

cls

echo 输入需要擦除的分区

echo 示例:
echo userdata
echo cache
echo metadata

set /p part=分区:


fastboot erase %part%


pause

goto menu




:fastbootd

cls


fastboot reboot fastboot


pause

goto menu





:reboot

cls

fastboot reboot


pause

goto menu




:needboot

if not exist "%FIRMWARE%\boot.img" (

echo 找不到:
echo %FIRMWARE%\boot.img

pause

exit /b 1

)

exit /b 0