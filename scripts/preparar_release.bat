@echo off
chcp 65001 >nul
echo ========================================
echo   PREPARADOR DE RELEASE - v1.0.1
echo ========================================
echo.

REM Define o diretório base
set BASE_DIR=%~dp0..
set RELEASE_DIR=%BASE_DIR%\release-package
set DIST_DIR=%BASE_DIR%\dist\OrganizadorCapturas
set OUTPUT_ZIP=%BASE_DIR%\OrganizadorCapturas-v1.0.1-Windows.zip

echo [1/4] Verificando se o EXE foi compilado...
if not exist "%DIST_DIR%\Organizador_Tray.exe" (
    echo.
    echo [ERRO] O arquivo EXE não foi encontrado!
    echo.
    echo Por favor, compile o projeto primeiro executando:
    echo   scripts\compilar_para_exe.bat
    echo.
    pause
    exit /b 1
)

echo [OK] EXE encontrado: %DIST_DIR%\Organizador_Tray.exe
echo.

echo [2/4] Copiando arquivos compilados para release-package...
xcopy "%DIST_DIR%\*" "%RELEASE_DIR%\OrganizadorCapturas\" /E /I /Y >nul
echo [OK] Arquivos copiados.
echo.

echo [3/4] Criando arquivo ZIP para release...
powershell -Command "Compress-Archive -Path '%RELEASE_DIR%\*' -DestinationPath '%OUTPUT_ZIP%' -Force"
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar o arquivo ZIP.
    pause
    exit /b 1
)
echo [OK] ZIP criado: %OUTPUT_ZIP%
echo.

echo [4/4] Calculando hash SHA256 do ZIP...
for /f "tokens=*" %%a in ('powershell -Command "Get-FileHash -Path '%OUTPUT_ZIP%' -Algorithm SHA256 | Select-Object -ExpandProperty Hash"') do set HASH=%%a
echo [OK] Hash SHA256: %HASH%
echo.

echo ========================================
echo   RELEASE PREPARADO COM SUCESSO!
echo ========================================
echo.
echo Arquivo criado: %OUTPUT_ZIP%
echo Hash SHA256: %HASH%
echo.
echo Próximos passos:
echo 1. Faça push do repositório para o GitHub
echo 2. Crie uma nova Release na página do GitHub
echo 3. Anexe o arquivo ZIP: %OUTPUT_ZIP%
echo 4. Use o template em: docs\GITHUB_RELEASE_TEMPLATE.md
echo.
pause
