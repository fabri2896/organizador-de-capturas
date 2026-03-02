' Script VBS para criar atalho na pasta Inicializar do Windows
' Executa este script para adicionar o Organizador na inicializacao automatica

Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Pasta do script atual
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)

' Caminho do arquivo .bat
batFile = scriptPath & "\iniciar_organizador.bat"

' Pasta Inicializar do Windows
startupFolder = WshShell.SpecialFolders("Startup")

' Nome do atalho
shortcutName = "Organizador de Capturas.lnk"
shortcutPath = startupFolder & "\" & shortcutName

' Verifica se o arquivo .bat existe
If Not fso.FileExists(batFile) Then
    MsgBox "Erro: Arquivo iniciar_organizador.bat nao encontrado!", vbCritical, "Erro"
    WScript.Quit 1
End If

' Cria o atalho
Set shortcut = WshShell.CreateShortcut(shortcutPath)
shortcut.TargetPath = batFile
shortcut.WorkingDirectory = scriptPath
shortcut.WindowStyle = 7  ' Minimizado
shortcut.Description = "Organizador Automatico de Capturas de Tela"
shortcut.Save

' Mensagem de sucesso
MsgBox "Atalho criado com sucesso!" & vbCrLf & vbCrLf & _
       "O Organizador de Capturas agora vai iniciar automaticamente" & vbCrLf & _
       "quando voce ligar o computador!" & vbCrLf & vbCrLf & _
       "Local: " & startupFolder, vbInformation, "Sucesso!"

WScript.Quit 0
