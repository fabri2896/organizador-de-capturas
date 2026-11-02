@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0.."

echo ============================================================
echo   BUILD - Organizador de Capturas
echo ============================================================
echo.
echo Passos: assets ^> EXE ^> instalador
echo.

REM --- Python (3.14 se estiver no caminho padrao) ---
set "PY=python"
if exist "%LOCALAPPDATA%\Programs\Python\Python314\python.exe" (
    set "PY=%LOCALAPPDATA%\Programs\Python\Python314\python.exe"
)

echo [1/4] Conferindo dependencias...
"%PY%" -c "import PIL, pystray, watchdog, PyInstaller" 2>nul
if errorlevel 1 (
    echo.
    echo [ERRO] Faltam dependencias. Rode:
    echo        "%PY%" -m pip install -r requirements.txt pyinstaller
    exit /b 1
)
echo       OK

echo [2/4] Gerando icone e artes do instalador...
"%PY%" scripts\gerar_assets.py
if errorlevel 1 exit /b 1

echo [3/4] Compilando EXE com PyInstaller...
"%PY%" -m PyInstaller --noconfirm --clean OrganizadorCapturas.spec
if errorlevel 1 (
    echo.
    echo [ERRO] Falha no PyInstaller.
    exit /b 1
)

echo [4/4] Compilando instalador com Inno Setup...
set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if not exist "!ISCC!" set "ISCC=%ProgramFiles%\Inno Setup 6\ISCC.exe"
if not exist "!ISCC!" (
    echo.
    echo [ERRO] Inno Setup 6 nao encontrado.
    echo        Instale em https://jrsoftware.org/isdl.php
    exit /b 1
)
"!ISCC!" scripts\installer.iss
if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao compilar o instalador.
    exit /b 1
)

echo.
echo ============================================================
echo   PRONTO
echo ============================================================
echo.
echo Executavel:
echo   dist\OrganizadorCapturas\OrganizadorCapturas.exe
echo Instalador:
dir /b Output\OrganizadorCapturas-*-Setup.exe
echo.
endlocal
exit /b 0
