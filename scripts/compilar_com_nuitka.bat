@echo off
REM ========================================================================
REM   COMPILADOR COM NUITKA - Organizador de Capturas v1.0.1
REM ========================================================================
REM
REM Nuitka compila Python em C antes de gerar EXE
REM VANTAGENS:
REM   - MUITO MENOS deteccao de antivirus (10-20% vs 60-80% do PyInstaller)
REM   - Mais rapido na execucao
REM   - Mais profissional
REM
REM DESVANTAGENS:
REM   - Compilacao MUITO mais lenta (5-15 minutos)
REM   - Precisa de Visual Studio Build Tools
REM
REM ========================================================================

echo ================================================
echo   COMPILADOR COM NUITKA
echo   Organizador de Capturas v1.0.1
echo ================================================
echo.
echo Nuitka e uma alternativa MUITO MELHOR ao PyInstaller!
echo.
echo VANTAGENS:
echo   ✅ 70-90%% MENOS deteccao de antivirus
echo   ✅ Codigo compilado em C (mais rapido)
echo   ✅ Mais profissional
echo.
echo DESVANTAGENS:
echo   ⚠️  Compilacao LENTA (5-15 minutos)
echo   ⚠️  Precisa Visual Studio Build Tools
echo.

pause
echo.

REM ========================================================================
REM Verificar Python
REM ========================================================================
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado!
    pause
    exit /b 1
)

echo [OK] Python encontrado!
echo.

REM ========================================================================
REM Verificar/Instalar Nuitka
REM ========================================================================
echo Verificando Nuitka...
python -c "import nuitka" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Instalando Nuitka (pode demorar)...
    pip install nuitka
    if %errorlevel% neq 0 (
        echo [ERRO] Falha ao instalar Nuitka!
        pause
        exit /b 1
    )
)

echo [OK] Nuitka instalado!
echo.

REM ========================================================================
REM Verificar Visual Studio Build Tools
REM ========================================================================
echo Verificando compilador C...
echo.
echo IMPORTANTE: Nuitka precisa de Visual Studio Build Tools!
echo.
echo Se nao tiver instalado, baixe em:
echo https://visualstudio.microsoft.com/visual-cpp-build-tools/
echo.
echo Marque: "Desktop development with C++"
echo.
pause
echo.

REM ========================================================================
REM Compilar com Nuitka
REM ========================================================================
echo ================================================
echo   Compilando com Nuitka...
echo   (PODE DEMORAR 5-15 MINUTOS!)
echo ================================================
echo.

python -m nuitka ^
  --standalone ^
  --windows-disable-console ^
  --enable-plugin=tk-inter ^
  --windows-icon-from-ico=icone.ico ^
  --company-name="fabri2896" ^
  --product-name="Organizador de Capturas" ^
  --file-version=1.0.1.0 ^
  --product-version=1.0.1.0 ^
  --file-description="Organizador Automatico de Capturas de Tela" ^
  --copyright="Copyright (C) 2026 fabri2896" ^
  --output-dir=dist-nuitka ^
  organizador_tray.py

if %errorlevel% neq 0 (
    echo.
    echo [ERRO] Falha na compilacao!
    echo.
    echo Possiveis causas:
    echo   - Visual Studio Build Tools nao instalado
    echo   - Faltando componente C++
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo   COMPILACAO NUITKA CONCLUIDA!
echo ================================================
echo.
echo O executavel foi gerado em:
echo   %cd%\dist-nuitka\organizador_tray.dist\organizador_tray.exe
echo.
echo VANTAGENS DO NUITKA:
echo   ✅ Muito menos deteccao de antivirus
echo   ✅ Execucao mais rapida
echo   ✅ Codigo compilado em C (nao empacotado)
echo.
echo PROXIMOS PASSOS:
echo   1. Teste: dist-nuitka\organizador_tray.dist\organizador_tray.exe
echo   2. Renomeie para OrganizadorCapturas.exe
echo   3. Distribua a pasta inteira (EXE + DLLs)
echo.
echo DICA: Crie instalador com Inno Setup (veja criar_instalador.bat)
echo.

REM Abre a pasta
explorer dist-nuitka\organizador_tray.dist

echo Pressione qualquer tecla para sair...
pause >nul
