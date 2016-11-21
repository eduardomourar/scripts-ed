'---------------------------------------------------------------------------------------
' Name      : Automação Consulado Portugal
' Author    : edmoura
' Desc      : Script para acessar o site do Consulado de Portugal
' Date      : 2016-09-28
' Changed   : 2016-09-28
'---------------------------------------------------------------------------------------
' Copyright (C) 2016
'---------------------------------------------------------------------------------------

Option Explicit ' Force explicit variable declaration

'*************************************( CONSTANTS )*************************************

Const APP_TITLE = "Automação Consulado Portugal"
Const PATH_DEFAULT = "C:\Users\ADMIN\Desktop\"
Const MAX_TIMEOUT = 10
Const vbFromUnicode = 128
Const vbUnicode = 64
Const adTypeBinary = 1
Const adTypeText = 2
Const adModeReadWrite = 3


'*************************************( VARIABLES )*************************************

Dim sMsgFinal, sFilePath, sFileOrig, sFileDest, dtBase

Main()
'**********************************( SYSTEM FUNCTIONS )*********************************

'**********************************( PROCEDURES - AUX )*********************************

Function PathExists(sPathFull)
'---------------------------------------------------------------------------------------
' Procedure : PathExists
' Author    : edmoura
' Desc      : Rotina que confere se existe o caminho especificado
' Input     : Caminho do arquivo ou pasta
' Output    :
' Usage     : PathExists(caminho)
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
    Dim fso
    
    On Error Resume Next
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    PathExists = False

    ' Confere se caminho existe
    If fso.FolderExists(sPathFull) Then
        PathExists = True
        Set fso = Nothing
        Exit Function
    End If
    If fso.FileExists(sPathFull) Then
        PathExists = True
    End If
    
    Set fso = Nothing

End Function

Function WriteLog(sLogFileLine) 
	Dim sLogFileName, dateStamp, objFsoLog, logOutput
    dateStamp = Now()
	
	sLogFileName = PATH_DEFAULT & "Consulado\log.txt"
    Set objFsoLog = CreateObject("Scripting.FileSystemObject") 
    Set logOutput = objFsoLog.OpenTextFile(sLogFileName, 8, True)

    logOutput.WriteLine cstr(dateStamp) & " -" & vbTab & sLogFileLine 
    logOutput.Close

    Set logOutput = Nothing 
    Set objFsoLog = Nothing

End Function

Function StringToBytes(str, charset)
' Charsets	
'	Windows-1252
'	Windows-1257
'	UTF-8
'	UTF-7
'	ASCII
'	X-ANSI
    With CreateObject("ADODB.Stream")
        .Mode = adModeReadWrite
        .Type = adTypeText
        .Charset = charset
        .Open
        .WriteText str
        .Position = 0
        .Type = adTypeBinary
        StringToBytes = .Read
    End With
End Function

Function URLEncode(Data)
'---------------------------------------------------------------------------------------
' Procedure : URLEncode
' Author    : edmoura
' Desc      : Função que faz o encoding do texto para enviar 
' Input     : Dados do texto
' Output    :
' Usage     : URLEncode(data)
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
  Dim I, C, Out
  
  For I = 1 To Len(Data)
    C = Asc(Mid(Data, I, 1))
    If C = 32 Then
      Out = Out + "+"
    ElseIf C < 48 Then
      Out = Out + "%" + Hex(C)
    Else
      Out = Out + Mid(Data, I, 1)
    End If
  Next
  URLEncode = Out
End Function

Function FindClass(domnode, sclass)
Dim my_xml, rootNode, els, i, mnode, at

Set my_xml = CreateObject("HTMLFile")
Set rootNode = my_xml.DocumentElement
Set els = domnode.getElementsByTagName("*")
For i = 0 To els.Length - 1
Set mnode = els.Item(i)
        If mnode.NodeType = 1 Then
                For Each at In mnode.Attributes
                        If at.Name = "class" And at.Value = sclass Then
                            Set FindClass = mnode
							Exit Function
                        End If
                Next
        End If
Next
Set FindClass = Nothing
End Function

'**********************************( PROCEDURES - MAIN )********************************

Sub Main()
'---------------------------------------------------------------------------------------
' Procedure : Main
' Author    : edmoura
' Desc      : Rotina principal do programa
' Input     :
' Output    :
' Usage     : Main()
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
	sMsgFinal = False

	PostRequest "http://www.consuladoportugalrjservicos.com/public_html/exec", _
		Array("modulo", "acao", "txtcpf", "txtusuario", "txtsenha"), _
		Array("modulo.login", "login001", "USER_CPF", "USER_EMAIL", "USER_PASS")
		
	REM PostRequest "http://www.consuladoportugalrjservicos.com/public_html/exec", _
		REM Array("modulo", "acao"), _
		REM Array("modulo.servicos", "servico900")
	
	'modulo=modulo.login&acao=login001&txtcpf=USER_CPF&txtusuario=USER_EMAIL&txtsenha=USER_PASS
	'modulo=modulo.servicos&acao=servico997
	'modulo=modulo.servicos&acao=servico900
	
	'Casamentos com pacto antenupcial entre português(a) e estrangeiro (a).
	'modulo=modulo.servicos&acao=servico902&opcao=&idpedido=376535&indexboleto=0
	
	'Requerimento Cartão Cidadão Normal
	'modulo=modulo.servicos&acao=servico902&opcao=&idpedido=376520&indexboleto=0
	
	'Nacionalidade para menor de 14 anos filho(a) de pai e/ou mãe português(a) sem procuração
	'modulo=modulo.servicos&acao=servico902&opcao=&idpedido=376537&indexboleto=0

	'modulo=modulo.servicos&acao=servico914&agendardia=11%2F10%2F2016&idpedido=376535&rbtnhora=14
		PostRequest "http://www.consuladoportugalrjservicos.com/public_html/exec", _
			Array("modulo", "acao", "agendardia", "idpedido", "rbtnhora"), _
			Array("modulo.servicos", "servico914", "11/10/2016", "376535", "14")

    ' Mostra mensagem de finalização
    If sMsgFinal Then
        sMsgFinal = "Script finalizado com sucesso."
    Else
        sMsgFinal = "Script finalizado com erro:" & vbCrLf & sMsgFinal
    End If
	
    MsgBox sMsgFinal, 0, APP_TITLE
    
End Sub

Sub PostRequest(URL, Names, Values)
'---------------------------------------------------------------------------------------
' Procedure : PostRequest
' Author    : edmoura
' Desc      : Rotina que envia os campos do formulário através do método POST 
' Input     : Link para envio, array com nome dos campos, array com valores
' Output    :
' Usage     : PathExists(url, names, values)
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
  Dim i, FormData, Name, Value
  
  'Enumerate form names And it's values
  'and built string representaion of the form data
  For i = 0 To UBound(Names)
    'URL encode source fields
    Name = URLEncode(Names(i))
    Value = URLEncode(Values(i))
    If FormData <> "" Then FormData = FormData & "&"
    FormData = FormData & Name & "=" & Value
  Next
  
  HTTPPost URL, FormData
  'IEPostStringRequest URL, FormData
End Sub

Sub HTTPPost(sUrl, sRequest)
	
	On Error Resume Next

	Dim oHTTP, oHTML, oElement
	Set oHTML = CreateObject("HTMLFile")
	Set oHTTP = CreateObject("MSXML2.ServerXMLHTTP")
	With oHTTP
		.open "POST", sUrl, false
		If Err.Number <> 0 Then
			WriteLog "Error " & Err.Number & "(0x" & hex(Err.Number) & ") " & Err.Description & "| Source " & Err.Source
			Err.Clear
			sMsgFinal = False
			Exit Sub
		End If
		.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		.setRequestHeader "Content-Length", Len(sRequest)
		.send sRequest
		If Err.Number <> 0 Then
			WriteLog "Error " & Err.Number & "(0x" & hex(Err.Number) & ") " & Err.Description & "| Source " & Err.Source
			Err.Clear
			sMsgFinal = False
			Exit Sub
		End If
		oHTML.Write .responseText
		oHTML.Close
		'oHTML.body.innerHTML = .responseText
	End With
	
	Set oElement = FindClass(oHTML, "dtycampo")
	
	sMsgFinal = True
	If Not oElement Is Nothing Then
		If oElement.innerText = "No momento nenhuma data disponível" Then
			sMsgFinal = False
			WriteLog "Sem data"
		End If
	End If
	
	If sMsgFinal Then
		WriteLog oHTML.body.innerText
		With CreateObject("ADODB.Stream")
			.Type = adTypeBinary
			.Open
			.Write oHTTP.responseBody
			.SaveToFile PATH_DEFAULT & "Consulado\response.html", 2 ' save file to desktop
			.Close
		End With
	End If
	
	Set oHTTP = Nothing
	Set oHTML = Nothing
	Set oElement = Nothing
End Sub

Sub IEPostStringRequest(sUrl, sRequest)
'---------------------------------------------------------------------------------------
' Procedure : IEPostStringRequest
' Author    : edmoura
' Desc      : Rotina que envia os dados encoded para a URL usando o IE
' Input     : Link para envio, dados do formulário
' Output    :
' Usage     : IEPostStringRequest(url, formData)
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
	Dim arrContent
	With CreateObject("InternetExplorer.Application")
		.Visible = True ' debug only
		.Navigate "http://www.consuladoportugalrjservicos.com/public_html/" ' navigate to the same domain where the target file located
		Do While .ReadyState <> 4 Or .Busy
			wscript.Sleep 10
		Loop

		With .document.parentWindow
			.execScript "var xhr = new XMLHttpRequest", "javascript" ' create XHR instance
			With .xhr
				.Open "POST", sUrl, false ' open get request
				.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
				.setRequestHeader "Content-Length", Len(sRequest)
				.send sRequest
				arrContent = .responseBody ' retrieve binary content
			End With
		End With
		'.Quit
	End With

	With CreateObject("Adodb.Stream")
		.Type = adTypeBinary
		.Open
		.Write arrContent ' put content to the stream
		.SaveToFile CreateObject("WScript.Shell").SpecialFolders.Item(&H0) & "\response.txt", 2 ' save file to desktop
		.Close
	End With
End Sub

Sub PostStringRequest(URL, FormData)
'---------------------------------------------------------------------------------------
' Procedure : IEPostStringRequest
' Author    : edmoura
' Desc      : Rotina que envia os dados encoded para a URL usando o IE
' Input     : Link para envio, dados do formulário
' Output    :
' Usage     : IEPostStringRequest(url, formData)
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
  'Create InternetExplorer
  Dim WebBrowser: Set WebBrowser = CreateObject("InternetExplorer.Application")
  
  'You can uncoment Next line To see form results As HTML
  WebBrowser.Visible = True
  
  'Send the form data To URL As POST request
  WebBrowser.Navigate URL, 2 + 4 + 8, , StringToBytes(FormData, "UTF-8"), _
    "Content-type: application/x-www-form-urlencoded" + Chr(10) + Chr(13)

  Do While WebBrowser.busy
    'Sleep 100
    DoEvents
  Loop
  'WebBrowser.Quit
End Sub
