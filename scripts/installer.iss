; ============================================================================
;  Instalador do Organizador de Capturas — v2.0.2
;  Inno Setup 6.x  (https://jrsoftware.org/isinfo.php)
;
;  Gera: Output\OrganizadorCapturas-2.0.2-Setup.exe
;  Compilar com: ISCC.exe scripts\installer.iss
; ============================================================================

[Setup]
; --- Identidade (AppId fixo: permite atualizar por cima sem duplicar) ---
AppId={{A7F3D2C1-5E4B-4C9A-9B21-7D6E8F0A1B2C}
AppName=Organizador de Capturas
AppVersion=2.0.2
AppVerName=Organizador de Capturas 2.0.2
AppPublisher=fabri2896
AppPublisherURL=https://github.com/fabri2896/organizador-de-capturas
AppSupportURL=https://github.com/fabri2896/organizador-de-capturas/issues
AppUpdatesURL=https://github.com/fabri2896/organizador-de-capturas/releases
AppCopyright=Copyright (C) 2026 fabri2896 - Licenca MIT

; --- Onde instalar (página de pasta sempre visível: usuário pode mudar) ---
DefaultDirName={autopf}\OrganizadorCapturas
DisableDirPage=no
DefaultGroupName=Organizador de Capturas
AllowNoIcons=yes

; --- Janela/aparência ---
WizardStyle=modern
WizardImageFile=wizard.png
WizardSmallImageFile=wizsmall.png
SetupIconFile=..\app.ico
UninstallDisplayIcon={app}\OrganizadorCapturas.exe
UninstallDisplayName=Organizador de Capturas

; --- Permissões: usuário escolhe "todos os usuários" (admin) ou "só eu" ---
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

; --- Saída ---
OutputDir=..\Output
OutputBaseFilename=OrganizadorCapturas-2.0.2-Setup
LicenseFile=..\LICENSE
Compression=lzma2/max
SolidCompression=yes

; --- Metadados do arquivo de instalação ---
VersionInfoVersion=2.0.2.0
VersionInfoCompany=fabri2896
VersionInfoDescription=Instalador do Organizador de Capturas de Tela
VersionInfoCopyright=Copyright (C) 2026 fabri2896
VersionInfoProductName=Organizador de Capturas

; Fecha o app antes de atualizar e reabre depois
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
; --- Opção 1: atalho na área de trabalho ---
Name: "desktopicon"; Description: "Criar atalho na &Área de Trabalho"; GroupDescription: "Atalhos:"; Flags: unchecked

; --- Opção 2: iniciar junto com o Windows ---
Name: "autostart"; Description: "Iniciar o Organizador automaticamente com o &Windows"; GroupDescription: "Inicialização:"; Flags: checkedonce

[Files]
; Aplicativo (EXE + dependências do PyInstaller)
Source: "..\dist\OrganizadorCapturas\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Documentação
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Menu Iniciar
Name: "{group}\Organizador de Capturas"; Filename: "{app}\OrganizadorCapturas.exe"; Comment: "Organiza suas capturas de tela por data"
Name: "{group}\Desinstalar Organizador de Capturas"; Filename: "{uninstallexe}"
; Área de trabalho (só se marcado)
Name: "{autodesktop}\Organizador de Capturas"; Filename: "{app}\OrganizadorCapturas.exe"; Tasks: desktopicon

; (O auto-start em HKCU\...\Run é gravado na seção [Code], para que uma
;  falha de registro — raro, mas possível em máquinas travadas — nunca
;  aborte a instalação inteira.)

[Run]
Filename: "{app}\OrganizadorCapturas.exe"; Description: "Abrir o Organizador de Capturas agora"; \
    Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Dados regeneráveis do usuário (config.json é mantido de propósito)
Type: files; Name: "{userappdata}\OrganizadorCapturas\hash_cache.json"
Type: files; Name: "{userappdata}\OrganizadorCapturas\organizador.log"
Type: files; Name: "{userappdata}\OrganizadorCapturas\organizador.log.*"
; Config antiga de versões que salvavam ao lado do executável
Type: files; Name: "{app}\config.json"

[Code]
const
  RUN_KEY = 'Software\Microsoft\Windows\CurrentVersion\Run';
  RUN_VAL = 'OrganizadorCapturas';

{ Grava (ou remove) o auto-start no mesmo local que o próprio aplicativo usa,
  HKCU\Software\Microsoft\Windows\CurrentVersion\Run. Assim o menu
  "Iniciar com Windows" da bandeja mostra o estado correto.
  Em caso de falha, apenas avisa — não aborta a instalação. }
procedure CurStepChanged(CurStep: TSetupStep);
var
  alvo: String;
  ok: Boolean;
begin
  if CurStep = ssPostInstall then
  begin
    if WizardIsTaskSelected('autostart') then
    begin
      alvo := '"' + ExpandConstant('{app}\OrganizadorCapturas.exe') + '"';
      ok := RegWriteStringValue(HKEY_CURRENT_USER, RUN_KEY, RUN_VAL, alvo);
      if not ok then
        MsgBox('O programa foi instalado, mas não foi possível registrar' + #13#10 +
               'o início automático com o Windows (acesso ao registro negado).' + #13#10 + #13#10 +
               'Você pode ativar depois pelo menu da bandeja:' + #13#10 +
               '"Iniciar com Windows".', mbInformation, MB_OK);
    end
    else
    begin
      { Usuário desmarcou: remove entrada antiga, se existir }
      RegDeleteValue(HKEY_CURRENT_USER, RUN_KEY, RUN_VAL);
    end;
  end;
end;

{ Remove a entrada de auto-start ao desinstalar }
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RegDeleteValue(HKEY_CURRENT_USER, RUN_KEY, RUN_VAL);
end;

{ Aviso amigável sobre a primeira execução }
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
  begin
    WizardForm.FinishedLabel.Caption :=
      'O Organizador de Capturas foi instalado.' + #13#10 + #13#10 +
      'Na primeira execução, escolha a pasta que deseja monitorar' + #13#10 +
      '(por exemplo, a pasta onde o ShareX salva suas capturas).' + #13#10 + #13#10 +
      'Depois disso, clique com o botão direito no ícone da bandeja' + #13#10 +
      'para pausar, trocar a pasta ou sair.';
  end;
end;
