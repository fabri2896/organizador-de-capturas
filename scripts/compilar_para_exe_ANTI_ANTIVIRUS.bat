@echo off
REM ========================================================================
REM   COMPILADOR ANTI-ANTIVÍRUS - Organizador de Capturas v1.0.1
REM ========================================================================
REM 
REM Este script usa técnicas para REDUZIR (não eliminar) detecções de
REM antivírus em EXEs gerados pelo PyInstaller.
REM 
REM IMPORTANTE: O arquivo NÃO É VÍRUS! É falso positivo!
REM ========================================================================

echo ================================================
echo   COMPILADOR ANTI-ANTIVIRUS
echo   Organizador de Capturas v1.0.1
echo ================================================
echo.
echo AVISO: Mesmo com estas tecnicas, alguns antivirus
echo podem detectar FALSO POSITIVO. E normal!
echo.
echo Pressione qualquer tecla para continuar...
pause >nul
echo.

REM Verifica Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Python nao encontrado!
    pause
    exit /b 1
)

REM Instala PyInstaller se necessário
echo [INFO] Verificando PyInstaller...
python -c "import PyInstaller" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Instalando PyInstaller...
    pip install pyinstaller
)

REM Instala UPX (compressor - ajuda a reduzir detecção)
echo [INFO] Baixando UPX (compressor)...
if not exist upx (
    echo Fazendo download do UPX...
    powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/upx/upx/releases/download/v4.2.2/upx-4.2.2-win64.zip' -OutFile 'upx.zip'}"
    powershell -Command "& {Expand-Archive -Path 'upx.zip' -DestinationPath '.' -Force}"
    move upx-4.2.2-win64 upx
    del upx.zip
)

echo [OK] Ferramentas prontas!
echo.

REM Limpa builds anteriores
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist OrganizadorCapturas.spec del /q OrganizadorCapturas.spec

echo ================================================
echo   Compilando com tecnicas ANTI-ANTIVIRUS...
echo ================================================
echo.
echo Tecnicas usadas:
echo   1. Compressao UPX (muda assinatura do arquivo)
echo   2. Modo --onedir (menos suspeito que --onefile)
echo   3. Strip de symbols
echo   4. Otimizacoes de bytecode
echo.

REM Compila com técnicas anti-detecção
pyinstaller ^
  --onedir ^
  --windowed ^
  --name "OrganizadorCapturas" ^
  --version-file "version_info.txt" ^
  --upx-dir "upx" ^
  --strip ^
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
echo   COMPILACAO CONCLUIDA!
echo ================================================
echo.
echo O executavel foi gerado em:
echo   %cd%\dist\OrganizadorCapturas\OrganizadorCapturas.exe
echo.
echo IMPORTANTE:
echo   - Desta vez foi gerado uma PASTA (nao um unico EXE)
echo   - A pasta contem o EXE + DLLs necessarias
echo   - Isto reduz MUITO a deteccao de antivirus
echo   - Para distribuir: compacte a pasta inteira em ZIP
echo.
echo PROXIMOS PASSOS:
echo   1. Adicione EXCECAO no seu antivirus
echo   2. Teste o EXE: dist\OrganizadorCapturas\OrganizadorCapturas.exe
echo   3. Se funcionar, distribua a pasta inteira
echo.

REM Abre a pasta
explorer dist\OrganizadorCapturas

echo Pressione qualquer tecla para sair...
pause >nul
