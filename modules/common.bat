@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

if defined COMMON_LOADED exit /b
set COMMON_LOADED=1

:: ======== 路径变量 ========
set ROOT=%~dp0..
set BIN=%ROOT%\bin
set MODULE=%ROOT%\modules
set FIRMWARE=%ROOT%\firmware
set BACKUP=%ROOT%\backup
set LOG=%ROOT%\logs
set CONFIG=%ROOT%\config.ini
set TEMP=%ROOT%\temp

:: 添加到PATH
set PATH=%BIN%;%PATH%

:: 创建目录
if not exist "%BIN%" mkdir "%BIN%"
if not exist "%MODULE%" mkdir "%MODULE%"
if not exist "%FIRMWARE%" mkdir "%FIRMWARE%"
if not exist "%BACKUP%" mkdir "%BACKUP%"
if not exist "%LOG%" mkdir "%LOG%"
if not exist "%TEMP%" mkdir "%TEMP%"

:: ======== 配置文件 ========
if not exist "%CONFIG%" (
    (
    echo [PATH]
    echo BIN=%ROOT%\bin
    echo FIRMWARE=%ROOT%\firmware
    echo BACKUP=%ROOT%\backup
    echo LOG=%ROOT%\logs
    echo MODE=auto
    echo THEME=0A
    echo DEBUG=false
    ) > "%CONFIG%"
)

:: 读取配置
for /f "usebackq tokens=1,* delims==" %%a in ("%CONFIG%") do (
    set "CFG_%%a=%%b"
)

:: 用配置覆盖默认
if defined CFG_BIN set BIN=%CFG_BIN%
if defined CFG_FIRMWARE set FIRMWARE=%CFG_FIRMWARE%
if defined CFG_BACKUP set BACKUP=%CFG_BACKUP%
if defined CFG_LOG set LOG=%CFG_LOG%

:: 重置PATH
set PATH=%BIN%;%PATH%

:: ======== 设备变量 ========
set DEVICE_ADB=false
set DEVICE_FASTBOOT=false
set DEVICE_EDL=false
set DEVICE_MODE=none

:: 检测ADB
adb get-state >nul 2>&1
if not errorlevel 1 (
    set DEVICE_ADB=true
    set DEVICE_MODE=adb
)

:: 检测Fastboot
fastboot devices | findstr "." >nul
if not errorlevel 1 (
    set DEVICE_FASTBOOT=true
    if "!DEVICE_MODE!"=="none" set DEVICE_MODE=fastboot
)

:: 检测EDL工具
if exist "%BIN%\edl.exe" set DEVICE_EDL=true

:: ======== 其他变量 ========
for /f "tokens=1-3 delims=/- " %%a in ("%date%") do set TODAY=%%a-%%b-%%c
for /f "tokens=1-6 delims=:,. " %%a in ("%time%") do set NOW=%%a-%%b-%%c

exit /b