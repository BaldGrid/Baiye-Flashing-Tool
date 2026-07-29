@echo off
chcp 65001 >nul
title 白叶一键工具 - 驱动安装
color 0A

call "%~dp0..\common.bat"

set DRIVERS_7Z=%ROOT%\tools\d.7z
set SEVENZ=%ROOT%\tools\7z.exe
set EXTRACT_DIR=%TEMP%\drivers_extract


:menu
cls
echo =====================================
echo          白叶一键工具
echo            设备驱动安装
echo =====================================
echo.

echo 1. 安装驱动
echo 2. 查看已安装驱动
echo.
echo 0. 返回主菜单
echo.

set /p choice=请选择:

if "%choice%"=="1" goto install
if "%choice%"=="2" goto view
if "%choice%"=="0" exit

goto menu


:install
cls
echo =====================================
echo           安装设备驱动
echo =====================================
echo.

:: 检查 7z.exe
if not exist "%SEVENZ%" (
    echo [×] 错误喵：找不到 7z.exe
    echo 请将 7z.exe 放入 tools 目录
    pause
    goto menu
)

:: 检查 d.7z
if not exist "%DRIVERS_7Z%" (
    echo [×] 错误喵：找不到驱动包 d.7z
    echo 请将 d.7z 放入 tools 目录
    pause
    goto menu
)

:: 清理旧解压目录
if exist "%EXTRACT_DIR%" (
    rd /s /q "%EXTRACT_DIR%" 2>nul
)

:: 创建解压目录
mkdir "%EXTRACT_DIR%" 2>nul

:: 静默解压
echo 正在解压驱动包喵...
"%SEVENZ%" x "%DRIVERS_7Z%" -o"%EXTRACT_DIR%" -y >nul 2>&1

if errorlevel 1 (
    echo [×] 解压失败喵
    rd /s /q "%EXTRACT_DIR%" 2>nul
    pause
    goto menu
)

echo [√] 解压完成喵
echo.

:: 搜索所有 inf 文件并安装
echo 正在安装驱动喵...
echo 如果提示是否安装驱动请务必点击安装喵
echo.

set INSTALL_COUNT=0
set INSTALL_FAIL=0

for /r "%EXTRACT_DIR%" %%f in (*.inf) do (
    echo 安装: %%~nxf
    rundll32.exe syssetup,SetupInfObjectInstallAction DefaultInstall 128 "%%f" >nul 2>&1
    if errorlevel 1 (
        echo [×] %%~nxf 安装失败喵
        set /a INSTALL_FAIL+=1
    ) else (
        echo [√] %%~nxf 安装成功喵
        set /a INSTALL_COUNT+=1
    )
    echo.
)

echo.
echo =====================================
if %INSTALL_FAIL% GTR 0 (
    echo [×] 安装错误喵
) else (
    echo [√] 安装成功喵
)
echo =====================================

:: 清理临时文件
echo.
echo 正在清理临时文件喵...
rd /s /q "%EXTRACT_DIR%" 2>nul
echo [√] 清理完成喵

pause
goto menu


:view
cls
echo =====================================
echo          已安装驱动列表
echo =====================================
echo.

echo 系统中已安装的高通/ADB相关驱动:
echo.

driverquery | findstr /i "qualcomm qcom adb android" 2>nul

if errorlevel 1 (
    echo 未找到相关驱动喵
)

echo.
pause
goto menu


:end
exit