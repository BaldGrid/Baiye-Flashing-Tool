@echo off
chcp 65001 >nul
title 白叶一键工具 - 关于
color 0A

call "%~dp0..\common.bat"

:menu

cls

echo ====================================
echo.
echo            白叶一键工具
echo.
echo        Android Device Toolkit
echo.
echo ====================================
echo.


echo 名称:
echo 白叶一键工具

echo.

echo 版本:
echo V1.0 Alpha

echo.

echo 运行目录:
echo %ROOT%

echo.

echo 支持平台:
echo Android
echo Windows ADB/Fastboot环境

echo.

echo 功能模块:
echo ------------------------------------
echo [√] ADB管理
echo [√] Fastboot管理
echo [√] Boot修补
echo [√] 分区处理
echo [√] 刷机工具
echo [√] 日志管理
echo [√] 设备检测
echo [√] 高通EDL支持
echo ------------------------------------

echo.

echo 工具目录:
echo %ROOT%\bin


echo.

echo ====================================
echo.
echo 使用说明:
echo.
echo 1. 将ADB/Fastboot等工具放入bin目录
echo 2. 将固件放入firmware目录
echo 3. 使用modules中的功能模块
echo.
echo ====================================

echo.


echo 1. 查看已安装工具
echo 2. 返回


set /p choice=请选择:


if "%choice%"=="1" goto tools
if "%choice%"=="2" exit


goto menu





:tools

cls

echo ====================================
echo        白叶一键工具
echo          工具列表
echo ====================================
echo.


if exist "%ROOT%\bin" (

dir "%ROOT%\bin" /b

) else (

echo 未找到bin目录

)


echo.

pause

goto menu