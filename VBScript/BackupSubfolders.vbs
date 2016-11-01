' Backup files to removable drive

Dim objFSO, sFolders(11), objStream, sPathIn, sPathOut
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

Const OverwriteExisting = TRUE

'=====folders=====
sPathIn = "C:\Users\heitor\Desktop\BAK_EC\EC_1TB_UDF\"
sPathOut = "D:\"
sFolders(0) = "_Arquivos\_Inbox\"
sFolders(1) = "_Arquivos\Pessoal\_Família\"
sFolders(2) = "_Arquivos\Pessoal\Docs\"
sFolders(3) = "_Arquivos\Pessoal\Interesses\"
sFolders(4) = "_Arquivos\Pessoal\Multimídia\"
sFolders(5) = "_Arquivos\Profissional\Acadêmico\"
sFolders(6) = "_Arquivos\Profissional\Concursos\"
sFolders(7) = "_Arquivos\Profissional\Trabalho\"
sFolders(8) = "_Arquivos\Sistema\Configurações\"
sFolders(9) = "_Arquivos\Sistema\Instalações\"
sFolders(10) = "_Arquivos\Sistema\Programação\"

For i = 0 to 10
	Set objFolder = objFSO.GetFolder(sPathIn & sFolders(i))
	For Each objSubfolder in objFolder.SubFolders
		objFSO.CopyFolder objSubfolder.Path, sPathOut & sFolders(i), OverwriteExisting
	Next
Next

MsgBox "Finished."
