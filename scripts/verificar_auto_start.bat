@echo off
REM Script para verificar onde o Organizador está configurado para auto-start

echo ================================================
echo   VERIFICADOR DE AUTO-START
echo   Organizador de Capturas
echo ================================================
echo.

echo Verificando locais de inicializacao...
echo.

echo ┌────────────────────────────────────────────────┐
echo │ 1. REGISTRY (HKEY_CURRENT_USER\Run)           │
echo └────────────────────────────────────────────────┘
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "organizador"
if %errorlevel% equ 0 (
    echo    ✅ ENCONTRADO no Registry!
) else (
    echo    ❌ Nao encontrado no Registry
)
echo.

echo ┌────────────────────────────────────────────────┐
echo │ 2. PASTA STARTUP (Usuario Atual)              │
echo └────────────────────────────────────────────────┘
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP%\*Organizador*.lnk" (
    echo    ✅ ENCONTRADO atalho na pasta Startup!
    dir /b "%STARTUP%\*Organizador*.lnk"
) else (
    echo    ❌ Nao encontrado na pasta Startup
)
echo.

echo ┌────────────────────────────────────────────────┐
echo │ 3. PASTA STARTUP (Todos os Usuarios)          │
echo └────────────────────────────────────────────────┘
set "STARTUP_ALL=%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"
if exist "%STARTUP_ALL%\*Organizador*.lnk" (
    echo    ✅ ENCONTRADO atalho na pasta Startup (Todos)!
    dir /b "%STARTUP_ALL%\*Organizador*.lnk"
) else (
    echo    ❌ Nao encontrado na pasta Startup (Todos)
)
echo.

echo ┌────────────────────────────────────────────────┐
echo │ 4. TASK SCHEDULER (Agendador de Tarefas)      │
echo └────────────────────────────────────────────────┘
schtasks /query | findstr /i "organizador"
if %errorlevel% equ 0 (
    echo    ✅ ENCONTRADO no Agendador de Tarefas!
) else (
    echo    ❌ Nao encontrado no Agendador
)
echo.

echo ================================================
echo   RESUMO
echo ================================================
echo.
echo Verifique os locais marcados com ✅ acima.
echo Esses sao os locais onde o organizador esta
echo configurado para iniciar automaticamente.
echo.

pause
