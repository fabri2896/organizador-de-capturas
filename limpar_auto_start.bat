@echo off
REM Script para REMOVER todas as configurações de auto-start do Organizador

echo ================================================
echo   LIMPADOR DE AUTO-START
echo   Organizador de Capturas
echo ================================================
echo.
echo Este script vai REMOVER todas as configuracoes
echo de auto-start do Organizador de Capturas.
echo.
echo Pressione qualquer tecla para continuar...
pause >nul
echo.

echo Removendo configuracoes...
echo.

REM ============================================================
REM 1. REMOVE DO REGISTRY
REM ============================================================
echo [1/4] Removendo do Registry...
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v OrganizadorCapturas /f >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✅ Removido do Registry!
) else (
    echo    ⚠️  Nao estava no Registry
)

REM ============================================================
REM 2. REMOVE DA PASTA STARTUP (Usuario Atual)
REM ============================================================
echo [2/4] Removendo da pasta Startup (usuario atual)...
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
del /q "%STARTUP%\*Organizador*.lnk" >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✅ Removido da pasta Startup!
) else (
    echo    ⚠️  Nao estava na pasta Startup
)

REM ============================================================
REM 3. REMOVE DA PASTA STARTUP (Todos os Usuarios)
REM ============================================================
echo [3/4] Removendo da pasta Startup (todos usuarios)...
set "STARTUP_ALL=%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"
del /q "%STARTUP_ALL%\*Organizador*.lnk" >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✅ Removido da pasta Startup (Todos)!
) else (
    echo    ⚠️  Nao estava na pasta Startup (Todos)
)

REM ============================================================
REM 4. REMOVE DO TASK SCHEDULER
REM ============================================================
echo [4/4] Removendo do Agendador de Tarefas...
schtasks /delete /tn "OrganizadorCapturas" /f >nul 2>&1
if %errorlevel% equ 0 (
    echo    ✅ Removido do Agendador de Tarefas!
) else (
    echo    ⚠️  Nao estava no Agendador
)

echo.
echo ================================================
echo   LIMPEZA CONCLUIDA!
echo ================================================
echo.
echo Todas as configuracoes de auto-start foram
echo removidas. O Organizador NAO vai mais iniciar
echo automaticamente com o Windows.
echo.
echo Para configurar novamente:
echo   - Execute o EXE do Organizador
echo   - Clique com botao direito no icone da bandeja
echo   - Selecione "Iniciar com Windows"
echo.

pause
