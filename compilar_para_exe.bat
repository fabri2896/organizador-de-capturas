@echo off
REM Script para compilar o Organizador de Capturas para EXE no Windows
REM Execute este script no Windows para gerar o arquivo .exe

echo ================================================
echo   COMPILADOR - Organizador de Capturas v1.0
echo ================================================
echo.

REM Verifica se Python esta instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado!
    echo Por favor, instale Python 3.6+ em: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [OK] Python encontrado!
echo.

REM Instala PyInstaller se necessario
echo Verificando PyInstaller...
python -c "import PyInstaller" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Instalando PyInstaller...
    pip install pyinstaller
    if %errorlevel% neq 0 (
        echo [ERRO] Falha ao instalar PyInstaller!
        pause
        exit /b 1
    )
)

echo [OK] PyInstaller pronto!
echo.

REM Limpa builds anteriores
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist OrganizadorCapturas.spec del /q OrganizadorCapturas.spec

echo ================================================
echo   Compilando... (isso pode demorar 1-2 minutos)
echo ================================================
echo.

REM Compila o executavel COM assinatura de desenvolvedor
pyinstaller ^
  --onefile ^
  --windowed ^
  --name "OrganizadorCapturas" ^
  --version-file "version_info.txt" ^
  --hidden-import "pystray._win32" ^
  --hidden-import "PIL._tkinter_finder" ^
  --hidden-import "winreg" ^
  organizador_tray.py

if %errorlevel% neq 0 (
    echo.
    echo [ERRO] Falha na compilacao!
    pause
    exit /b 1
)

echo.
echo ================================================
echo   COMPILACAO CONCLUIDA COM SUCESSO!
echo ================================================
echo.
echo O arquivo EXE foi gerado em:
echo   %cd%\dist\OrganizadorCapturas.exe
echo.
echo Tamanho aproximado: 15-30 MB
echo.
echo PROXIMOS PASSOS:
echo   1. Teste o EXE: dist\OrganizadorCapturas.exe
echo   2. Copie para onde quiser usar
echo   3. Execute e configure a pasta a monitorar
echo.
echo DICA: Use o menu do icone (botao direito) para:
echo   - Configurar auto-start (Iniciar com Windows)
echo   - Ver logs e status
echo   - Pausar/Retomar monitoramento
echo.

REM Abre a pasta dist
explorer dist

echo Pressione qualquer tecla para sair...
pause >nul
