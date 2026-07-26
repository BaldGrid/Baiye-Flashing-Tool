@echo off
chcp 65001 >nul
title 白叶一键工具 - LOGO

color 0A


:logo

cls

echo.
echo.
echo          ██╗    ██╗███████╗
echo          ██║    ██║██╔════╝
echo          ██║ █╗ ██║█████╗
echo          ██║███╗██║██╔══╝
echo          ╚███╔███╔╝███████╗
echo           ╚══╝╚══╝ ╚══════╝
echo.
echo.
echo              白叶一键工具
echo.
echo          Android Device Toolkit
echo.
echo              Version 1.0
echo.
echo ======================================
echo.
echo        ADB   Fastboot   EDL
echo        Root  Flash      Backup
echo.
echo ======================================
echo.


timeout /t 2 >nul


echo.
echo 正在初始化工具...


timeout /t 1 >nul


echo.
echo [√] 加载ADB模块

timeout /t 1 >nul

echo [√] 加载Fastboot模块

timeout /t 1 >nul

echo [√] 加载刷机模块

timeout /t 1 >nul

echo [√] 加载设备检测

timeout /t 1 >nul


echo.

echo 白叶一键工具启动完成


timeout /t 2 >nul


exit /b