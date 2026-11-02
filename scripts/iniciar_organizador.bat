@echo off
REM Script para iniciar o Organizador de Capturas no Windows
REM Executa em segundo plano sem janela visível

cd /d "%~dp0"

REM Verifica se Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python nao encontrado! Instalando Python...
    start "" https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Verifica e instala dependências
python -c "import watchdog, pystray, PIL" >nul 2>&1
if %errorlevel% neq 0 (
    echo Instalando dependencias necessarias...
    pip install watchdog pystray pillow --quiet
)

REM Inicia o aplicativo em segundo plano (sem janela)
start /B pythonw organizador_tray.py

REM Aguarda um momento para garantir que iniciou
timeout /t 2 /nobreak >nul

echo.
echo ========================================
echo   Organizador de Capturas INICIADO!
echo ========================================
echo.
echo Procure o icone na area de notificacao
echo (bandeja do sistema, proximo ao relogio)
echo.
echo Esta janela fechara automaticamente em 3 segundos...
timeout /t 3 /nobreak >nul

exit /b 0
