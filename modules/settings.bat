@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

title 白叶一键工具 - 设置中心
color 0A

call "%~dp0..\common.bat"

:: 初始化配置文件
if not exist "%CONFIG%" (
    (
    echo [PATH]
    echo BIN=%ROOT%\bin
    echo FIRMWARE=%ROOT%\firmware
    echo BACKUP=%ROOT%\backup
    echo LOG=%ROOT%\logs
    echo MODE=auto
    echo THEME=default
    echo DEBUG=false
    ) > "%CONFIG%"
)


:menu
cls

echo =====================================
echo          白叶一键工具
echo             设置中心
echo =====================================
echo.

echo 1. 查看当前配置
echo 2. 修改工具目录 (BIN)
echo 3. 修改固件目录 (FIRMWARE)
echo 4. 修改备份目录 (BACKUP)
echo 5. 修改日志目录 (LOG)
echo 6. 默认设备模式
echo 7. 切换主题颜色
echo 8. 调试模式
echo 9. 恢复默认设置
echo.
echo 0. 返回

echo.

set /p S=请选择:

if "%S%"=="1" goto show
if "%S%"=="2" goto set_bin
if "%S%"=="3" goto set_firmware
if "%S%"=="4" goto set_backup
if "%S%"=="5" goto set_logs
if "%S%"=="6" goto set_mode
if "%S%"=="7" goto set_theme
if "%S%"=="8" goto set_debug
if "%S%"=="9" goto reset
if "%S%"=="0" exit

goto menu


::====================================
:: 查看当前配置
::====================================

:show
cls

echo =====================================
echo             当前配置
echo =====================================
echo.

if exist "%CONFIG%" (
    type "%CONFIG%"
) else (
    echo 配置文件不存在
)

echo.
echo =====================================
echo 实际目录状态:
echo.
echo BIN目录:     %ROOT%\bin
echo FIRMWARE目录: %ROOT%\firmware
echo BACKUP目录:   %ROOT%\backup
echo LOG目录:     %ROOT%\logs
echo.

pause
goto menu


::====================================
:: 修改工具目录
::====================================

:set_bin
cls

echo =====================================
echo          修改工具目录
echo =====================================
echo.
echo 当前: %ROOT%\bin
echo.

set /p NEWBIN=请输入新的bin目录路径 (留空取消):

if "%NEWBIN%"=="" goto menu

:: 使用PowerShell更新配置文件
powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^BIN=.*', 'BIN=%NEWBIN%' | Set-Content '%CONFIG%'"

echo.
echo [√] 工具目录已更新为: %NEWBIN%
echo [提示] 请将adb.exe、fastboot.exe等工具放入该目录

pause
goto menu


::====================================
:: 修改固件目录
::====================================

:set_firmware
cls

echo =====================================
echo          修改固件目录
echo =====================================
echo.
echo 当前: %ROOT%\firmware
echo.

set /p NEWFW=请输入新的固件目录路径 (留空取消):

if "%NEWFW%"=="" goto menu

powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^FIRMWARE=.*', 'FIRMWARE=%NEWFW%' | Set-Content '%CONFIG%'"

echo.
echo [√] 固件目录已更新为: %NEWFW%

pause
goto menu


::====================================
:: 修改备份目录
::====================================

:set_backup
cls

echo =====================================
echo          修改备份目录
echo =====================================
echo.
echo 当前: %ROOT%\backup
echo.

set /p NEWBK=请输入新的备份目录路径 (留空取消):

if "%NEWBK%"=="" goto menu

powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^BACKUP=.*', 'BACKUP=%NEWBK%' | Set-Content '%CONFIG%'"

echo.
echo [√] 备份目录已更新为: %NEWBK%
echo [提示] 原备份文件不会自动移动，请手动迁移

pause
goto menu


::====================================
:: 修改日志目录
::====================================

:set_logs
cls

echo =====================================
echo          修改日志目录
echo =====================================
echo.
echo 当前: %ROOT%\logs
echo.

set /p NEWLOG=请输入新的日志目录路径 (留空取消):

if "%NEWLOG%"=="" goto menu

powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^LOG=.*', 'LOG=%NEWLOG%' | Set-Content '%CONFIG%'"

echo.
echo [√] 日志目录已更新为: %NEWLOG%

pause
goto menu


::====================================
:: 默认设备模式
::====================================

:set_mode
cls

echo =====================================
echo          默认设备模式
echo =====================================
echo.
echo 当前模式:
findstr /i "^MODE=" "%CONFIG%"
echo.

echo 请选择默认模式:
echo 1. auto    (自动检测)
echo 2. adb     (优先ADB)
echo 3. fastboot (优先Fastboot)
echo 4. edl     (优先EDL)
echo.

set /p MODE_CHOICE=请选择 (1-4):

if "%MODE_CHOICE%"=="1" set NEWMODE=auto
if "%MODE_CHOICE%"=="2" set NEWMODE=adb
if "%MODE_CHOICE%"=="3" set NEWMODE=fastboot
if "%MODE_CHOICE%"=="4" set NEWMODE=edl

if "%NEWMODE%"=="" goto set_mode

powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^MODE=.*', 'MODE=%NEWMODE%' | Set-Content '%CONFIG%'"

echo.
echo [√] 默认模式已更新为: %NEWMODE%

pause
goto menu


::====================================
:: 切换主题颜色
::====================================

:set_theme
cls

echo =====================================
echo          切换主题颜色
echo =====================================
echo.
echo 当前主题:
findstr /i "^THEME=" "%CONFIG%"
echo.

echo 可用颜色:
echo 0A - 亮绿色 (默认)
echo 0C - 亮红色
echo 0E - 亮黄色
echo 0B - 亮青色
echo 0D - 亮紫色
echo 0F - 亮白色
echo 02 - 暗绿色
echo.

set /p NEWTHEME=请输入颜色代码 (如 0A):

if "%NEWTHEME%"=="" goto set_theme

:: 验证颜色代码格式
echo %NEWTHEME% | findstr /r "^[0-9A-Fa-f][0-9A-Fa-f]$" >nul
if errorlevel 1 (
    echo.
    echo [错误] 无效的颜色代码，请输入两位十六进制数
    pause
    goto set_theme
)

powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^THEME=.*', 'THEME=%NEWTHEME%' | Set-Content '%CONFIG%'"

echo.
echo [√] 主题已更新为: %NEWTHEME%
echo [提示] 重启工具后生效

pause
goto menu


::====================================
:: 调试模式
::====================================

:set_debug
cls

echo =====================================
echo          调试模式
echo =====================================
echo.
echo 开启后将显示详细错误信息

echo.

findstr /i "DEBUG=true" "%CONFIG%" >nul
if errorlevel 1 (
    echo 当前状态: [关闭]
    set /p TURNON=是否开启调试模式? (Y/N):
    if /i "!TURNON!"=="Y" (
        powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^DEBUG=.*', 'DEBUG=true' | Set-Content '%CONFIG%'"
        echo [√] 调试模式已开启
    )
) else (
    echo 当前状态: [开启]
    set /p TURNOFF=是否关闭调试模式? (Y/N):
    if /i "!TURNOFF!"=="Y" (
        powershell -command "$c = Get-Content '%CONFIG%'; $c -replace '^DEBUG=.*', 'DEBUG=false' | Set-Content '%CONFIG%'"
        echo [√] 调试模式已关闭
    )
)

pause
goto menu


::====================================
:: 恢复默认设置
::====================================

:reset
cls

echo =====================================
echo          恢复默认设置
echo =====================================
echo.
echo 警告: 将重置所有配置为默认值！
echo.

choice /c YN /m "确认恢复默认设置?"

if errorlevel 2 goto menu

echo.
echo 正在恢复默认配置...

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

echo.
echo [√] 已恢复默认设置

pause
goto menu


:end
exit