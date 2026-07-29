@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

title 加载中 ing...

set ROOT=%~dp0
set MODULE=%ROOT%modules

:start
cls

:: 显示 LOGO（注意是 logos.bat）
if exist "%MODULE%\logos.bat" (
    call "%MODULE%\logos.bat"
) else (
    echo [错误] 找不到 logos.bat
    pause
    exit
)

echo.
echo =============================================
echo.
echo              正在初始化环境...
echo.
echo =============================================
echo.

:: 检查是否为首次启动
set FIRST_BOOT=false

if not exist "%ROOT%backup" set FIRST_BOOT=true
if not exist "%ROOT%tools" set FIRST_BOOT=true
if not exist "%ROOT%firmware" set FIRST_BOOT=true
if not exist "%ROOT%logs" set FIRST_BOOT=true
if not exist "%ROOT%mtk" set FIRST_BOOT=true

if "%FIRST_BOOT%"=="true" (
    call :first_boot
) else (
    call :normal_boot
)

:: 进入主界面
if exist "%MODULE%\main.bat" (
    call "%MODULE%\main.bat"
) else (
    echo.
    echo [错误] 找不到 main.bat
    echo.
    pause
    exit
)

exit


:first_boot
echo [√] 检测到首次启动
echo.
echo 正在创建必要目录...
echo.

call :create_dir "tools" "工具目录"
call :create_dir "backup" "备份目录"
call :create_dir "firmware" "固件目录"
call :create_dir "logs" "日志目录"
call :create_dir "mtk" "联发科工具目录"

echo. > "%ROOT%backup\.keep" 2>nul
echo. > "%ROOT%logs\.keep" 2>nul
echo. > "%ROOT%mtk\.keep" 2>nul

echo.
echo =============================================
echo.
echo    ✅ 初始化完成！
echo.
echo    即将进入主界面...
echo.
echo =============================================
echo.

timeout /t 2 >nul
exit /b


:normal_boot
echo [√] 检测到已初始化
echo.
echo 正在检查目录...
echo.

call :check_dir "tools"
call :check_dir "backup"
call :check_dir "firmware"
call :check_dir "logs"
call :check_dir "mtk"

echo.
echo =============================================
echo.
echo    ✅ 全部就绪
echo.
echo    即将进入主界面...
echo.
echo =============================================
echo.

timeout /t 1 >nul
exit /b


:create_dir
set DIR_NAME=%~1
set DIR_DESC=%~2
if "%DIR_DESC%"=="" set DIR_DESC=%DIR_NAME%

if exist "%ROOT%%DIR_NAME%" (
    echo [   ] %DIR_DESC% ... 已存在
) else (
    mkdir "%ROOT%%DIR_NAME%" 2>nul
    if errorlevel 1 (
        echo [×] %DIR_DESC% ... 创建失败
    ) else (
        echo [√] %DIR_DESC% ... 创建成功
    )
)
exit /b


:check_dir
set DIR_NAME=%~1
set DIR_DESC=%~2
if "%DIR_DESC%"=="" set DIR_DESC=%DIR_NAME%

if exist "%ROOT%%DIR_NAME%" (
    echo [√] %DIR_DESC% ... OK
) else (
    echo [ ] %DIR_DESC% ... 不存在
    mkdir "%ROOT%%DIR_NAME%" 2>nul
    if errorlevel 1 (
        echo [×] %DIR_DESC% ... 创建失败
    ) else (
        echo [√] %DIR_DESC% ... 已修复
    )
)
exit /b


:end
exit