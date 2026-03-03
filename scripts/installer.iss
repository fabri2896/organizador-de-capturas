; Script do Inno Setup para Organizador de Capturas v1.0.1
; Cria um instalador profissional para Windows
; Download Inno Setup: https://jrsoftware.org/isinfo.php

[Setup]
; Informações do Aplicativo
AppName=Organizador de Capturas
AppVersion=1.0.1
AppPublisher=fabri2896
AppPublisherURL=https://github.com/fabri2896/organizador-capturas
AppSupportURL=https://github.com/fabri2896/organizador-capturas/issues
AppUpdatesURL=https://github.com/fabri2896/organizador-capturas/releases
DefaultDirName={autopf}\OrganizadorCapturas
DefaultGroupName=Organizador de Capturas
AllowNoIcons=yes
LicenseFile=LICENSE
OutputDir=.
OutputBaseFilename=OrganizadorCapturas-v1.0.1-Setup
SetupIconFile=
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest

; Informações de versão
VersionInfoVersion=1.0.1.0
VersionInfoCompany=fabri2896
VersionInfoDescription=Instalador do Organizador de Capturas de Tela
VersionInfoCopyright=Copyright (C) 2026 fabri2896

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "autostart"; Description: "Iniciar automaticamente com o Windows"; GroupDescription: "Opções de inicialização:"

[Files]
; Copia TODA a pasta dist\OrganizadorCapturas (EXE + DLLs)
Source: "dist\OrganizadorCapturas\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Copia documentação
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "LEIA-ME.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "INSTRUCOES-WINDOWS.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "COMO-USAR-EXE.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "ANTIVIRUS-BLOQUEOU.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "GERENCIAR-AUTO-START.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Ícone no Menu Iniciar
Name: "{group}\Organizador de Capturas"; Filename: "{app}\OrganizadorCapturas.exe"
Name: "{group}\Leia-me"; Filename: "{app}\LEIA-ME.txt"
Name: "{group}\Como Usar"; Filename: "{app}\COMO-USAR-EXE.txt"
Name: "{group}\Desinstalar"; Filename: "{uninstallexe}"

; Ícone na Área de Trabalho (se selecionado)
Name: "{autodesktop}\Organizador de Capturas"; Filename: "{app}\OrganizadorCapturas.exe"; Tasks: desktopicon

; Auto-start (se selecionado)
Name: "{userstartup}\Organizador de Capturas"; Filename: "{app}\OrganizadorCapturas.exe"; Tasks: autostart

[Run]
; Executar após instalação (pergunta ao usuário)
Filename: "{app}\OrganizadorCapturas.exe"; Description: "{cm:LaunchProgram,Organizador de Capturas}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Remove arquivos de configuração ao desinstalar
Type: files; Name: "{app}\config.json"
Type: files; Name: "{app}\organizador.log"

[Code]
// Mensagem personalizada na primeira tela
function InitializeSetup(): Boolean;
begin
  Result := True;
end;

// Mensagem ao finalizar instalação
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    MsgBox('Instalação concluída com sucesso!' + #13#10 + #13#10 +
           'O Organizador de Capturas foi instalado.' + #13#10 + #13#10 +
           'Na primeira execução, você será solicitado a selecionar a pasta para monitorar.' + #13#10 + #13#10 +
           'Clique com botão direito no ícone 📁 da bandeja para acessar as opções.',
           mbInformation, MB_OK);
  end;
end;
