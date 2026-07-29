@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

title 白叶一键工具 - Qualcomm 9006 刷机中心
color 0A

call "%~dp0..\common.bat"

:: 额外变量
set QCDIR=%ROOT%\firmware\qualcomm\9006
set EMMCDL=%BIN%\emmcdl.exe

if not exist "%QCDIR%" mkdir "%QCDIR%"


:menu
cls
call :print_banner

echo =============================================
echo          Qualcomm 9006 刷机中心
echo          大容量存储模式 / Disk Mode
echo =============================================
echo.

call :detect_9006

echo.
echo ---------------------------------------------
echo.

echo 1. 检测9006设备
echo 2. 查看设备信息
echo 3. 加载 Firehose (prog_*.mbn)
echo 4. 执行 XML 刷写 (rawprogram*.xml)
echo 5. 刷写单分区
echo 6. 备份分区
echo 7. 擦除分区
echo 8. 退出9006模式
echo 9. 查看可用端口
echo.
echo 0. 返回主菜单
echo.

set /p CHOICE=请选择:

if "%CHOICE%"=="1" goto detect
if "%CHOICE%"=="2" goto info
if "%CHOICE%"=="3" goto load_firehose
if "%CHOICE%"=="4" goto flash_xml
if "%CHOICE%"=="5" goto flash_part
if "%CHOICE%"=="6" goto backup_part
if "%CHOICE%"=="7" goto erase_part
if "%CHOICE%"=="8" goto exit_9006
if "%CHOICE%"=="9" goto list_ports
if "%CHOICE%"=="0" exit

goto menu


::====================================
:: 打印标题
::====================================

:print_banner
cls
echo =============================================
echo          白叶一键工具
echo          Qualcomm 9006 刷机中心
echo =============================================
exit /b


::====================================
:: 检测9006设备
::====================================

:detect_9006
echo 正在检测9006设备...
echo.

if not exist "%EMMCDL%" (
    echo [!] 未找到 emmcdl.exe
    echo [!] 请放入: %BIN%
    set DEVICE_9006=false
    exit /b
)

:: 尝试检测
%EMMCDL% -info > "%TEMP%\9006_info.txt" 2>&1

findstr /i "COM" "%TEMP%\9006_info.txt" >nul

if errorlevel 1 (
    echo [×] 未检测到9006设备
    echo.
    echo 提示:
    echo 1. 手机需进入9006模式
    echo 2. 检查驱动是否安装
    echo 3. 使用 "选项9" 查看端口
    set DEVICE_9006=false
) else (
    echo [√] 检测到9006设备
    set DEVICE_9006=true
    for /f "tokens=2 delims=: " %%a in ('findstr /i "COM" "%TEMP%\9006_info.txt"') do set DETECTED_PORT=%%a
    echo [√] 端口: %DETECTED_PORT%
)

exit /b


::====================================
:: 查看设备信息
::====================================

:info
cls
echo =============================================
echo          9006 设备信息
echo =============================================
echo.

if "%DEVICE_9006%"=="false" (
    echo [!] 请先检测设备 (选项1)
    pause
    goto menu
)

echo 正在读取设备信息...
echo.

%EMMCDL% -info

echo.
echo =============================================

pause
goto menu


::====================================
:: 可用端口列表
::====================================

:list_ports
cls
echo =============================================
echo          可用 COM 端口
echo =============================================
echo.

echo 正在扫描端口...

for /l %%i in (1,1,30) do (
    set PORT=COM%%i
    echo 检测 !PORT! ...
    %EMMCDL% -p !PORT! -info >nul 2>&1
    if not errorlevel 1 (
        echo [√] !PORT! - 设备在线
    )
)

echo.
echo 提示: 如果未检测到，请检查驱动

pause
goto menu


::====================================
:: 加载 Firehose
::====================================

:load_firehose
cls
echo =============================================
echo          加载 Firehose Loader
echo =============================================
echo.

if "%DEVICE_9006%"=="false" (
    echo [!] 请先检测设备 (选项1)
    pause
    goto menu
)

echo 请选择 Firehose 文件:
echo.
echo 搜索: %QCDIR%\prog_*.mbn
echo.

dir "%QCDIR%\prog_*.mbn" /b 2>nul

if errorlevel 1 (
    echo.
    echo [!] 未找到 prog_*.mbn 文件
    echo.
    echo 请将 Firehose 文件放入:
    echo %QCDIR%
    echo.
    echo 文件名示例:
    echo prog_emmc_firehose_8974.mbn
    echo prog_ufs_firehose_8996.elf
    pause
    goto menu
)

echo.
set /p FH_FILE=请输入 Firehose 文件名:

if "%FH_FILE%"=="" goto load_firehose

if not exist "%QCDIR%\%FH_FILE%" (
    echo [错误] 文件不存在
    pause
    goto load_firehose
)

set FIREHOSE_PATH=%QCDIR%\%FH_FILE%

set /p COM_PORT=请输入 COM 端口 (如 COM3):

if "%COM_PORT%"=="" goto load_firehose

echo.
echo 正在加载 Firehose ...
echo.

%EMMCDL% -p %COM_PORT% -f "%FIREHOSE_PATH%"

if errorlevel 1 (
    echo.
    echo [错误] 加载失败
    echo 可能原因:
    echo 1. Firehose 与设备不匹配
    echo 2. 端口不正确
    echo 3. 设备未就绪
) else (
    echo.
    echo [√] Firehose 加载成功
)

pause
goto menu


::====================================
:: XML 刷写
::====================================

:flash_xml
cls
echo =============================================
echo          XML 刷写 (Rawprogram)
echo =============================================
echo.

echo 请选择 XML 文件:
echo.
echo 搜索: %QCDIR%\*.xml
echo.

dir "%QCDIR%\*.xml" /b 2>nul

if errorlevel 1 (
    echo.
    echo [!] 未找到 XML 文件
    echo.
    echo 需要文件:
    echo rawprogram0.xml
    echo patch0.xml
    pause
    goto menu
)

echo.
set /p RAW_XML=请输入 rawprogram 文件名:

if "%RAW_XML%"=="" goto flash_xml

if not exist "%QCDIR%\%RAW_XML%" (
    echo [错误] 文件不存在
    pause
    goto flash_xml
)

set /p PATCH_XML=请输入 patch 文件名:

if "%PATCH_XML%"=="" goto flash_xml

if not exist "%QCDIR%\%PATCH_XML%" (
    echo [错误] 文件不存在
    pause
    goto flash_xml
)

set /p COM_PORT=请输入 COM 端口 (如 COM3):

if "%COM_PORT%"=="" goto flash_xml

echo.
echo =============================================
echo           即将执行刷写
echo =============================================
echo.
echo 端口:  %COM_PORT%
echo Raw:   %QCDIR%\%RAW_XML%
echo Patch: %QCDIR%\%PATCH_XML%
echo.
echo 警告: 刷写将覆盖目标分区！
echo.

choice /c YN /m "确认继续?"

if errorlevel 2 goto menu

echo.
echo 开始刷写...
echo %date% %time% [9006] XML刷写开始 >> "%LOG%\9006.log"

%EMMCDL% -p %COM_PORT% -x "%QCDIR%\%RAW_XML%"

if errorlevel 1 (
    echo.
    echo [错误] 刷写失败
    echo %date% %time% [9006] 刷写失败 >> "%LOG%\9006.log"
) else (
    echo.
    echo [√] 刷写完成
    echo %date% %time% [9006] 刷写成功 >> "%LOG%\9006.log"
)

pause
goto menu


::====================================
:: 刷写单分区
::====================================

:flash_part
cls
echo =============================================
echo          刷写单分区
echo =============================================
echo.

echo 可用镜像:
dir "%QCDIR%\*.img" /b 2>nul

echo.
set /p IMG_FILE=请输入镜像文件名:

if "%IMG_FILE%"=="" goto flash_part

if not exist "%QCDIR%\%IMG_FILE%" (
    echo [错误] 文件不存在
    pause
    goto flash_part
)

set /p PART_NAME=请输入目标分区名 (如 boot):

if "%PART_NAME%"=="" goto flash_part

set /p COM_PORT=请输入 COM 端口 (如 COM3):

if "%COM_PORT%"=="" goto flash_part

echo.
echo 刷写: %PART_NAME% <- %IMG_FILE%
echo.

choice /c YN /m "确认?"

if errorlevel 2 goto menu

echo.
echo 正在刷写...

%EMMCDL% -p %COM_PORT% -x "%QCDIR%\%IMG_FILE%" -partition %PART_NAME%

if errorlevel 1 (
    echo [错误] 刷写失败
) else (
    echo [√] 刷写完成
)

pause
goto menu


::====================================
:: 备份分区
::====================================

:backup_part
cls
echo =============================================
echo          备份分区
echo =============================================
echo.

set /p PART_NAME=请输入要备份的分区名:

if "%PART_NAME%"=="" goto backup_part

set /p COM_PORT=请输入 COM 端口 (如 COM3):

if "%COM_PORT%"=="" goto backup_part

set OUT_FILE=%BACKUP%\%PART_NAME%_9006_backup.img

echo.
echo 正在备份 %PART_NAME% ...

%EMMCDL% -p %COM_PORT% -r %PART_NAME% -f "%OUT_FILE%"

if errorlevel 1 (
    echo [错误] 备份失败
) else (
    echo [√] 备份完成
    echo 保存: %OUT_FILE%
)

pause
goto menu


::====================================
:: 擦除分区
::====================================

:erase_part
cls
echo =============================================
echo          擦除分区
echo =============================================
echo.
echo 警告: 擦除操作不可恢复！
echo.

set /p PART_NAME=请输入要擦除的分区名:

if "%PART_NAME%"=="" goto erase_part

set /p COM_PORT=请输入 COM 端口 (如 COM3):

if "%COM_PORT%"=="" goto erase_part

echo.
echo 即将擦除: %PART_NAME%
echo.

choice /c YN /m "确认?"

if errorlevel 2 goto menu

echo.
echo 正在擦除...

%EMMCDL% -p %COM_PORT% -e %PART_NAME%

if errorlevel 1 (
    echo [错误] 擦除失败
) else (
    echo [√] 擦除完成
)

pause
goto menu


::====================================
:: 退出9006模式
::====================================

:exit_9006
cls
echo =============================================
echo          退出9006模式
echo =============================================
echo.

set /p COM_PORT=请输入 COM 端口 (如 COM3):

if "%COM_PORT%"=="" goto exit_9006

echo.
echo 正在重置设备...

%EMMCDL% -p %COM_PORT% -r

if errorlevel 1 (
    echo [错误] 重置失败
    echo.
    echo 尝试手动操作:
    echo 长按电源键强制重启
) else (
    echo [√] 设备正在重启
)

pause
goto menu


:end
exit