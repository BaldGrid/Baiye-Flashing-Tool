@echo off
chcp 65001 >nul
title 白叶一键工具 - 分区管理
color 0A

call "%~dp0..\common.bat"

if not exist "%BACKUP%" mkdir "%BACKUP%"
if not exist "%LOG%" mkdir "%LOG%"



:menu

cls

echo =====================================
echo          白叶一键工具
echo             分区管理
echo =====================================
echo.

echo 1. 查看ADB分区
echo 2. 查看Fastboot分区
echo 3. 获取GPT分区表
echo 4. 备份分区镜像
echo 5. 刷入分区镜像
echo 6. 擦除分区
echo 7. 保存分区日志
echo.
echo 0. 返回
echo.


set /p choice=请选择:


if "%choice%"=="1" goto adb_part
if "%choice%"=="2" goto fastboot_part
if "%choice%"=="3" goto gpt
if "%choice%"=="4" goto backup_part
if "%choice%"=="5" goto flash_part
if "%choice%"=="6" goto erase_part
if "%choice%"=="7" goto save_log

if "%choice%"=="0" exit


goto menu





:adb_part

cls

echo ===== ADB分区列表 =====


adb shell ls -l /dev/block/by-name


pause

goto menu






:fastboot_part

cls

echo ===== Fastboot分区信息 =====


fastboot getvar all


pause

goto menu






:gpt

cls

echo ===== GPT分区 =====


echo.

echo 请选择模式:

echo 1. Fastboot
echo 2. Qualcomm 9008


set /p GPT=:


if "%GPT%"=="1" (

fastboot getvar all > "%LOG%\fastboot_gpt.txt" 2>&1

)


if "%GPT%"=="2" (

if exist "%BIN%\edl.exe" (

edl printgpt > "%LOG%\edl_gpt.txt"

) else (

echo 缺少edl工具

)

)


echo 完成


pause

goto menu





:backup_part

cls

echo =====备份分区=====

echo.

echo 示例:
echo boot
echo vbmeta
echo dtbo


set /p PART=分区名称:


echo.

echo 选择设备模式:

echo 1.Fastboot
echo 2.9008


set /p MODE=:



if "%MODE%"=="1" (

fastboot fetch %PART% "%BACKUP%\%PART%.img"

)



if "%MODE%"=="2" (

echo 请使用EDL备份工具

pause

goto menu

)


echo.

echo 备份完成:

echo %BACKUP%\%PART%.img


pause

goto menu





:flash_part

cls

echo =====刷入分区=====


set /p PART=分区名称:

set /p IMG=镜像路径:


if not exist "%IMG%" (

echo 文件不存在

pause

goto menu

)


fastboot flash %PART% "%IMG%"


pause

goto menu






:erase_part

cls

echo =====擦除分区=====


set /p PART=分区名称:


fastboot erase %PART%


pause

goto menu






:save_log

cls


fastboot getvar all > "%LOG%\partition.txt" 2>&1


adb shell ls -l /dev/block/by-name >> "%LOG%\partition.txt"


echo.

echo 已保存:

echo %LOG%\partition.txt


pause

goto menu