@echo off
mode con: cols=90 lines=35
title Instalador Office - by Derik Oliveira
color 0B

:: Verificar se e Administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo  Solicitando permissao de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo.
echo  ============================================================
echo   INSTALADOR OFFICE OFICIAL - by Derik Oliveira
echo   github.com/derikolis/Pacote-Office
echo  ============================================================
echo.
echo   Bem-vindo! Esta ferramenta vai guiar voce pela instalacao
echo   do Microsoft Office de forma 100%% oficial e segura,
echo   diretamente dos servidores da Microsoft.
echo.
echo   O que vai acontecer:
echo    [1] Voce escolhe a versao, idioma e configuracoes
echo    [2] O instalador baixa os arquivos da Microsoft
echo    [3] O Office e instalado automaticamente
echo.
echo   Mantenha a internet conectada durante todo o processo.
echo   A instalacao pode demorar entre 10 e 30 minutos.
echo.
echo  ============================================================
echo.
pause
powershell -ExecutionPolicy Bypass -File "%~dp0InstalarOffice.ps1"