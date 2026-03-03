@echo off
REM ========================================================================
REM   CRIAR INSTALADOR PROFISSIONAL - Inno Setup
REM   Organizador de Capturas v1.0.1
REM ========================================================================
REM
REM Este script:
REM   1. Compila o projeto com PyInstaller (--onedir)
REM   2. Cria instalador com Inno Setup
REM
REM PRE-REQUISITOS:
REM   - Python + PyInstaller
REM   - Inno Setup: https://jrsoftware.org/isinfo.php
REM
REM ========================================================================

echo ================================================
echo   CRIADOR DE INSTALADOR PROFISSIONAL
echo   Organizador de Capturas v1.0.1
echo ================================================
echo.

REM ========================================================================
REM Verificar Inno Setup
REM ========================================================================
echo Verificando Inno Setup...
set "INNO_PATH=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"

if not exist "%INNO_PATH%" (
    echo.
    echo [ERRO] Inno Setup nao encontrado!
    echo.
    echo INSTALE PRIMEIRO:
    echo   1. Baixe: https://jrsoftware.org/isdl.php
    echo   2. Instale o Inno Setup 6
    echo   3. Execute este script novamente
    echo.
    pause
    exit /b 1
)

echo [OK] Inno Setup encontrado!
echo.

REM ========================================================================
REM Passo 1: Compilar com PyInstaller
REM ========================================================================
echo ================================================
echo   PASSO 1/2: Compilando com PyInstaller...
echo ================================================
echo.

call compilar_para_exe.bat

if %errorlevel% neq 0 (
    echo [ERRO] Falha na compilacao!
    pause
    exit /b 1
)

echo.
echo [OK] Compilacao concluida!
echo.

REM ========================================================================
REM Passo 2: Criar instalador com Inno Setup
REM ========================================================================
echo ================================================
echo   PASSO 2/2: Criando instalador...
echo ================================================
echo.

"%INNO_PATH%" installer.iss

if %errorlevel% neq 0 (
    echo.
    echo [ERRO] Falha ao criar instalador!
    pause
    exit /b 1
)

echo.
echo ================================================
echo   INSTALADOR CRIADO COM SUCESSO!
echo ================================================
echo.
echo O instalador foi gerado em:
echo   %cd%\OrganizadorCapturas-v1.0.1-Setup.exe
echo.
echo VANTAGENS DO INSTALADOR:
echo   ✅ Instalacao profissional (Next, Next, Finish)
echo   ✅ Desinstalador automatico
echo   ✅ Icone no Menu Iniciar
echo   ✅ Opcao de auto-start
echo   ✅ MUITO mais confiavel que EXE sozinho
echo   ✅ Windows confia mais em instaladores
echo.
echo PROXIMOS PASSOS:
echo   1. Teste: OrganizadorCapturas-v1.0.1-Setup.exe
echo   2. Distribua este instalador (nao o EXE diretamente)
echo   3. Publique no GitHub Release
echo.

REM Abre a pasta
explorer .

echo Pressione qualquer tecla para sair...
pause >nul
