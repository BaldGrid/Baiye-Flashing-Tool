@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

title 白叶一键工具 - Qualcomm Pro
color 0A

call "%~dp0..\common.bat"

if not exist "%LOG%" mkdir "%LOG%"
if not exist "%BACKUP%" mkdir "%BACKUP%"
if not exist "%QCOM%" mkdir "%QCOM%"



::========================
:: 主菜单
::========================


:menu

cls

echo =====================================
echo.
echo          白叶一键工具
echo.
echo          Qualcomm Pro中心
echo.
echo =====================================
echo.

call :detect


echo.
echo -------------------------------------
echo.

echo 1. 自动识别高通刷机包

echo 2. Qualcomm 9008 EDL

echo 3. Sahara检测

echo 4. Firehose管理

echo 5. GPT分区管理

echo 6. 分区备份

echo 7. Qualcomm 9006

echo 8. EDL退出恢复

echo 9. 工具检测

echo 10. 查看日志

echo.

echo 0. 返回


echo.
set /p CHOICE=请选择:


if "%CHOICE%"=="1" goto scan_package

if "%CHOICE%"=="2" goto edl_menu

if "%CHOICE%"=="3" goto sahara

if "%CHOICE%"=="4" goto firehose

if "%CHOICE%"=="5" goto gpt

if "%CHOICE%"=="6" goto backup

if "%CHOICE%"=="7" goto 9006

if "%CHOICE%"=="8" goto edl_exit

if "%CHOICE%"=="9" goto tools

if "%CHOICE%"=="10" goto logs

if "%CHOICE%"=="0" exit


goto menu






::========================
:: 设备检测
::========================


:detect

echo 当前设备:


adb get-state >nul 2>&1

if %errorlevel%==0 (
echo [√] ADB
) else (
echo [ ] ADB
)



fastboot devices | findstr "." >nul

if %errorlevel%==0 (
echo [√] Fastboot
) else (
echo [ ] Fastboot
)



if exist "%BIN%\edl.exe" (
echo [√] EDL工具
) else (
echo [ ] EDL工具
)



if exist "%BIN%\emmcdl.exe" (
echo [√] EMMCDL
) else (
echo [ ] EMMCDL
)


exit /b

::====================================
:: Qualcomm 9008 EDL菜单
::====================================

:edl_menu

cls

echo =====================================
echo.
echo          Qualcomm 9008 EDL
echo.
echo =====================================
echo.

echo 1. 检测9008设备

echo 2. 自动选择刷机包

echo 3. XML刷写

echo 4. 读取GPT

echo 5. 返回


echo.

set /p EDL_CHOICE=请选择:


if "%EDL_CHOICE%"=="1" goto check9008

if "%EDL_CHOICE%"=="2" goto scan_edl

if "%EDL_CHOICE%"=="3" goto edl_flash

if "%EDL_CHOICE%"=="4" goto gpt

if "%EDL_CHOICE%"=="5" goto menu


goto edl_menu





::====================================
:: 检测9008
::====================================


:check9008

cls

echo =====================================
echo          检测9008模式
echo =====================================
echo.


if exist "%BIN%\edl.exe" (

echo 正在连接Sahara...

edl printgpt


) else (

echo.
echo 未找到 edl.exe
echo 请放入:
echo %BIN%
echo.

)


pause

goto edl_menu





::====================================
:: 自动扫描EDL包
::====================================


:scan_edl

cls

echo =====================================
echo       自动识别高通刷机包
echo =====================================
echo.


set /p PACKAGE=请输入刷机包目录:


if not exist "%PACKAGE%" (

echo.

echo 目录不存在

pause

goto edl_menu

)



echo.

echo 正在扫描...


set FIRE_COUNT=0

set RAW=
set PATCH=



:: 查找Firehose

for /r "%PACKAGE%" %%a in (*.mbn *.elf) do (

set /a FIRE_COUNT+=1

set FIRE!FIRE_COUNT!=%%a

)



:: 查找XML

for /r "%PACKAGE%" %%a in (rawprogram*.xml) do (

if not defined RAW set RAW=%%a

)


for /r "%PACKAGE%" %%a in (patch*.xml) do (

if not defined PATCH set PATCH=%%a

)



echo.

echo 找到Firehose:

for /l %%i in (1,1,%FIRE_COUNT%) do (

echo %%i. !FIRE%%i!

)



echo.

echo Rawprogram:

echo %RAW%


echo.

echo Patch:

echo %PATCH%



if %FIRE_COUNT%==0 (

echo.

echo 未找到Firehose

pause

goto edl_menu

)



if %FIRE_COUNT%==1 (

set LOADER=!FIRE1!

goto fire_ready

)



echo.

set /p FIRE_SELECT=选择Firehose编号:


set LOADER=!FIRE%FIRE_SELECT%!





:fire_ready


echo.

echo 当前选择:

echo %LOADER%


echo.

echo 1. 开始刷写

echo 2. 返回


set /p START=:


if "%START%"=="1" goto edl_flash

goto edl_menu





::====================================
:: XML刷写
::====================================


:edl_flash

cls

echo =====================================
echo          EDL XML刷写
echo =====================================
echo.


if "%LOADER%"=="" (

echo 未选择Firehose

pause

goto scan_edl

)



if "%RAW%"=="" (

echo 未找到rawprogram.xml

pause

goto edl_menu

)



if "%PATCH%"=="" (

echo 未找到patch.xml

pause

goto edl_menu

)



echo.

echo 即将执行:

echo.

echo Firehose:
echo %LOADER%

echo.

echo XML:
echo %RAW%

echo.

echo Patch:
echo %PATCH%


echo.


choice /c YN /m "确认开始刷写?"


if errorlevel 2 goto edl_menu



echo.

echo 开始EDL刷写...

echo %date% %time% EDL START >> "%LOG%\QCOM_EDL.log"



if exist "%BIN%\edl.exe" (

edl --loader "%LOADER%" rawprogram "%RAW%" patch "%PATCH%"

) else (

echo 缺少edl工具

)



echo.

echo 刷写完成

echo %date% %time% EDL END >> "%LOG%\QCOM_EDL.log"



pause

goto edl_menu





::====================================
:: Sahara检测
::====================================


:sahara

cls

echo =====================================
echo          Sahara协议检测
echo =====================================
echo.


if exist "%BIN%\qdl.exe" (

qdl --debug


) else (

echo.

echo 未找到 qdl.exe

echo 请放入:
echo %BIN%

)



pause

goto menu

::====================================
:: GPT分区管理
::====================================

:gpt

cls

echo =====================================
echo          GPT分区管理
echo =====================================
echo.

echo 1. 读取GPT

echo 2. 保存GPT日志

echo 3. 存储类型检测

echo 4. 返回


echo.

set /p GPT_CHOICE=请选择:


if "%GPT_CHOICE%"=="1" goto read_gpt

if "%GPT_CHOICE%"=="2" goto save_gpt

if "%GPT_CHOICE%"=="3" goto storage_detect

if "%GPT_CHOICE%"=="4" goto menu


goto gpt






::====================================
:: 读取GPT
::====================================


:read_gpt

cls

echo =====================================
echo          读取GPT分区表
echo =====================================
echo.


echo 正在读取...


if exist "%BIN%\edl.exe" (

edl printgpt > "%LOG%\QCOM_GPT.log"


type "%LOG%\QCOM_GPT.log"


) else (

echo 未找到edl.exe

)



pause

goto gpt





::====================================
:: 保存GPT
::====================================


:save_gpt

cls


echo 保存GPT信息...


edl printgpt > "%LOG%\GPT_%date%.txt"


echo.

echo 保存完成:

echo %LOG%


pause

goto gpt






::====================================
:: UFS/eMMC检测
::====================================


:storage_detect

cls


echo =====================================
echo       存储类型检测
echo =====================================
echo.



if not exist "%BIN%\edl.exe" (

echo 缺少edl工具

pause

goto gpt

)



edl printgpt > "%TEMP%\gpt.txt"



findstr /i "ufs" "%TEMP%\gpt.txt" >nul


if %errorlevel%==0 (

echo.

echo [检测结果]

echo UFS 存储


set STORAGE=UFS


goto storage_end

)



findstr /i "emmc" "%TEMP%\gpt.txt" >nul


if %errorlevel%==0 (

echo.

echo [检测结果]

echo eMMC 存储


set STORAGE=EMMC


goto storage_end

)



echo.

echo 无法自动判断

echo 请手动确认





:storage_end


echo.

echo 推荐Firehose:


if "%STORAGE%"=="UFS" (

echo ufs_firehose


)



if "%STORAGE%"=="EMMC" (

echo emmc_firehose


)



pause

goto gpt







::====================================
:: 分区备份
::====================================


:backup

cls

echo =====================================
echo          Qualcomm分区备份
echo =====================================
echo.



echo 1. 单分区备份

echo 2. 常用分区备份

echo 3. 返回



set /p BACK_CHOICE=请选择:


if "%BACK_CHOICE%"=="1" goto backup_one


if "%BACK_CHOICE%"=="2" goto backup_all


if "%BACK_CHOICE%"=="3" goto menu



goto backup






::====================================
:: 单分区备份
::====================================


:backup_one

cls


echo 示例:

echo boot

echo modem

echo persist


echo.


set /p PART=输入分区名:


set OUT=%BACKUP%\Qualcomm\%PART%.img


if not exist "%BACKUP%\Qualcomm" mkdir "%BACKUP%\Qualcomm"



echo.

echo 正在备份:

echo %PART%



if exist "%BIN%\edl.exe" (

edl r %PART% "%OUT%"

) else (

echo 缺少edl.exe

)



echo.

echo 输出:

echo %OUT%



pause

goto backup





::====================================
:: 常用分区备份
::====================================


:backup_all

cls


echo 开始备份常用分区


if not exist "%BACKUP%\Qualcomm" mkdir "%BACKUP%\Qualcomm"



for %%p in (
boot
modem
persist
abl
xbl
tz
vendor
system
) do (


echo.

echo 备份 %%p ...


edl r %%p "%BACKUP%\Qualcomm\%%p.img"


)



echo.

echo 全部分区备份完成


pause

goto backup






::====================================
:: Qualcomm 9006
::====================================


:9006

cls

echo =====================================
echo          Qualcomm 9006模式
echo =====================================
echo.


echo 1. 检测9006

echo 2. 查看设备信息

echo 3. 返回



set /p C6=请选择:


if "%C6%"=="1" goto check9006

if "%C6%"=="2" goto info9006

if "%C6%"=="3" goto menu



goto 9006






:check9006

cls


if exist "%BIN%\emmcdl.exe" (

emmcdl -info


) else (

echo.

echo 未找到:

echo emmcdl.exe

)



pause

goto 9006






:info9006

cls


echo 输入COM端口:

echo 示例:
echo COM3


set /p COM=:


emmcdl -p %COM% -info


pause

goto 9006

::====================================
:: EDL退出恢复
::====================================

:edl_exit

cls

echo =====================================
echo          EDL退出恢复
echo =====================================
echo.


echo 正在尝试退出9008模式...


if exist "%BIN%\edl.exe" (

edl reset

) else (

echo 未找到 edl.exe

)



echo.

echo 设备应该正在重启...


echo %date% %time% EDL RESET >> "%LOG%\QCOM_EDL.log"


pause

goto menu






::====================================
:: 自动识别高通刷机包
::====================================


:scan_package

cls

echo =====================================
echo       高通刷机包智能识别
echo =====================================
echo.



echo 请拖入刷机包目录:
echo.


set /p PKG=路径:


if not exist "%PKG%" (

echo.

echo 路径不存在

pause

goto menu

)



echo.

echo 正在分析...


set QTYPE=UNKNOWN



:: Qualcomm判断

for /r "%PKG%" %%a in (prog_firehose*.mbn) do (

set QTYPE=QUALCOMM

)


for /r "%PKG%" %%a in (prog_firehose*.elf) do (

set QTYPE=QUALCOMM

)



:: 小米判断

if exist "%PKG%\flash_all.bat" (

set QTYPE=XIAOMI_FASTBOOT

)



if exist "%PKG%\images" (

if "%QTYPE%"=="UNKNOWN" (

set QTYPE=XIAOMI_ROM

)

)



cls


echo =====================================
echo          分析结果
echo =====================================
echo.


if "%QTYPE%"=="QUALCOMM" (

echo 类型:
echo Qualcomm EDL固件

echo.

echo 模式:
echo 9008 Firehose

goto package_end

)



if "%QTYPE%"=="XIAOMI_FASTBOOT" (

echo 类型:
echo 小米Fastboot ROM

echo.

echo 建议:
echo 使用fastboot模块

goto package_end

)



if "%QTYPE%"=="XIAOMI_ROM" (

echo 类型:
echo 小米官方ROM

echo.

echo 包含:
echo images目录

goto package_end

)



echo 未识别类型





:package_end


echo.

echo 路径:

echo %PKG%


echo.

pause


goto menu






::====================================
:: 工具检测
::====================================


:tools

cls

echo =====================================
echo          Qualcomm工具检测
echo =====================================
echo.



echo [EDL]

if exist "%BIN%\edl.exe" (

echo √ edl.exe

) else (

echo × edl.exe

)



echo.

echo [QDL]

if exist "%BIN%\qdl.exe" (

echo √ qdl.exe

) else (

echo × qdl.exe

)



echo.

echo [EMMCDL]

if exist "%BIN%\emmcdl.exe" (

echo √ emmcdl.exe

) else (

echo × emmcdl.exe

)



echo.

echo [Firehose Loader]

if exist "%BIN%\fh_loader.exe" (

echo √ fh_loader.exe

) else (

echo × fh_loader.exe

)



echo.

echo [ADB]

where adb



echo.

echo [Fastboot]

where fastboot



pause

goto menu






::====================================
:: 日志中心
::====================================


:logs

cls

echo =====================================
echo          Qualcomm日志
echo =====================================
echo.



if not exist "%LOG%" mkdir "%LOG%"



echo 1. 查看日志

echo 2. 打开日志目录

echo 3. 清理日志

echo 4. 返回



set /p LOG_CHOICE=请选择:



if "%LOG_CHOICE%"=="1" goto show_logs


if "%LOG_CHOICE%"=="2" goto open_logs


if "%LOG_CHOICE%"=="3" goto clear_logs


if "%LOG_CHOICE%"=="4" goto menu



goto logs






:show_logs

cls


dir "%LOG%" /b


pause

goto logs






:open_logs

start "" "%LOG%"


goto logs






:clear_logs

cls


echo 删除全部日志?


choice /c YN


if errorlevel 2 goto logs



del /q "%LOG%\*.*"



echo 完成


pause

goto logs






::====================================
:: 拖拽支持
::====================================


:drag


if not "%~1"=="" (

set DRAG_PATH=%~1


echo 检测:

echo %DRAG_PATH%


goto scan_package

)


exit /b





::====================================
:: 结束
::====================================


:end

exit

