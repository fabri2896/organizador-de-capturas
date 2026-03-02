@echo off
REM Script ALTERNATIVO - Gera UM UNICO ARQUIVO EXE (mais deteccao de antivirus)
REM Use compilar_para_exe.bat (recomendado) se o antivirus estiver bloqueando

echo ================================================
echo   COMPILADOR ONEFILE (Arquivo Unico)
echo   Organizador de Capturas v1.0.1
echo ================================================
echo.
echo AVISO: Este metodo gera UM UNICO arquivo .exe
echo mas TEM MAIS DETECCAO de antivirus!
echo.
echo RECOMENDADO: Use compilar_para_exe.bat (--onedir)
echo.
echo Deseja continuar com --onefile mesmo assim?
pause
echo.

REM Verifica Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado!
    pause
    exit /b 1
)

REM Instala PyInstaller
echo Verificando PyInstaller...
python -c "import PyInstaller" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Instalando PyInstaller...
    pip install pyinstaller
)

echo [OK] PyInstaller pronto!
echo.

REM Limpa builds anteriores
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist OrganizadorCapturas.spec del /q OrganizadorCapturas.spec

echo ================================================
echo   Compilando ONEFILE... (1-2 minutos)
echo ================================================
echo.

REM Compila como arquivo UNICO
pyinstaller ^
  --onefile ^
  --noconsole ^
  --noupx ^
  --clean ^
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
echo   COMPILACAO ONEFILE CONCLUIDA!
echo ================================================
echo.
echo O arquivo EXE foi gerado em:
echo   %cd%\dist\OrganizadorCapturas.exe
echo.
echo VANTAGENS:
echo   ✅ Arquivo unico (facil de distribuir)
echo.
echo DESVANTAGENS:
echo   ❌ Maior deteccao de antivirus (60-80%%)
echo   ❌ Tamanho maior (~20-35 MB)
echo   ❌ Inicia um pouco mais lento
echo.
echo Se o antivirus bloquear, use:
echo   compilar_para_exe.bat (metodo --onedir, menos deteccao)
echo.

REM Abre a pasta
explorer dist

echo Pressione qualquer tecla para sair...
pause >nul
