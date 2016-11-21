'---------------------------------------------------------------------------------------
' Name      : Automação Consulado
' Author    : edmoura
' Desc      : Script para acessar o site do Consulado
' Date      : 2016-09-28
' Changed   : 2016-10-03
'---------------------------------------------------------------------------------------
' Copyright (C) 2016
'---------------------------------------------------------------------------------------

Option Explicit ' Force explicit variable declaration

'*************************************( CONSTANTS )*************************************

Const APP_TITLE = "Automação Consulado"
Const PATH_DEFAULT = "C:\Users\ADMIN\Desktop\"
Const INTERVAL = 60 ' Em segundos
Const USER_CPF = "USER_CPF" 'Substituir por dados reais
Const USER_NAME = "USER_NAME"
Const USER_PASS = "USER_PASS"
Const vbFromUnicode = 128
Const vbUnicode = 64
Const ForReading = 1
Const ForAppending = 8
Const adTypeBinary = 1
Const adTypeText = 2
Const adModeReadWrite = 3
Const adSaveCreateNotExist = 1
Const adSaveCreateOverWrite = 2


'*************************************( VARIABLES )*************************************

Dim sMsgFinal, sAutent

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

Sub WriteLog(sLogFileLine) 
	Dim sLogFileName, dateStamp, objFsoLog, logOutput
    dateStamp = Now()
	
	sLogFileName = PATH_DEFAULT & "Consulado\log.txt"
    Set objFsoLog = CreateObject("Scripting.FileSystemObject") 
    Set logOutput = objFsoLog.OpenTextFile(sLogFileName, ForAppending, True)

    logOutput.WriteLine cstr(dateStamp) & " -" & vbTab & sLogFileLine 
    logOutput.Close

    Set logOutput = Nothing 
    Set objFsoLog = Nothing

End Sub

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
' Output    : Dados convertido
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

Sub SaveFile(sName, sInput)

    Dim bString
    
    If TypeName(sInput) = "String" Then
        bString = True
    Else
        bString = False
    End If
    
    With CreateObject("ADODB.Stream")
        If bString Then
            .Type = adTypeText
        Else
            .Type = adTypeBinary
        End If
        .Open
        If bString Then
            .WriteText sInput
        Else
            .Write sInput
        End If
        .SaveToFile PATH_DEFAULT & "Consulado\" & sName, adSaveCreateOverWrite
        .Close
    End With

End Sub

Function TimeStamp()
    Dim t 
    t = Now
    timeStamp = Year(t) & "-" & _
    Right("0" & Month(t),2)  & "-" & _
    Right("0" & Day(t),2)  & "_" & _  
    Right("0" & Hour(t),2) & _
    Right("0" & Minute(t),2) '    '& _    Right("0" & Second(t),2) 
End Function

Function FindClass(domnode, sclass)
	Dim els, mnode, at, nodes

    Set els = domnode.getElementsByTagName("*")
    For Each mnode In els
        If mnode.NodeType = 1 Then
            For Each at In mnode.Attributes
                If at.Name = "class" And at.Value = sclass Then
                    If mnode.innerText = "No momento nenhuma data disponível" Then
                        FindClass = True
                        Exit Function
                    End If
                End If
            Next
        End If
    Next
    FindClass = False
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
	sAutent = ""
	sMsgFinal = False

	REM PostRequest "http://www.consuladoportugalrjservicos.com/public_html/exec", _
		REM Array("modulo", "acao"), _
		REM Array("modulo.servicos", "servico900")
	
	'modulo=modulo.login&acao=login001&txtcpf=USER_CPF&txtusuario=USER_NAME&txtsenha=USER_PASS
	'modulo=modulo.servicos&acao=servico997
	'modulo=modulo.servicos&acao=servico900
	
	'Casamentos com pacto antenupcial entre português(a) e estrangeiro (a).
	'modulo=modulo.servicos&acao=servico902&opcao=&idpedido=376535&indexboleto=0
	
	'Requerimento Cartão Cidadão Normal
	'modulo=modulo.servicos&acao=servico902&opcao=&idpedido=376520&indexboleto=0
	
	'Nacionalidade para menor de 14 anos filho(a) de pai e/ou mãe português(a) sem procuração
	'modulo=modulo.servicos&acao=servico902&opcao=&idpedido=376537&indexboleto=0

	'modulo=modulo.servicos&acao=servico912&idpedido=376520&rbtndia=13%2F10%2F2016
	'modulo=modulo.servicos&acao=servico914&agendardia=11%2F10%2F2016&idpedido=376520&rbtnfaixa=1
	'modulo=modulo.servicos&acao=servico914&agendardia=11%2F10%2F2016&idpedido=376520&rbtnhora=16
	
	
	sAutent = PostRequest(sAutent)
	WriteLog sAutent
	PostRequestFull Array("modulo", "acao", "txtcpf", "txtusuario", "txtsenha"), _
		Array("modulo.login", "login001", USER_CPF, USER_NAME, USER_PASS)
	
	Do
		PostRequestFull Array("modulo", "acao", "opcao", "idpedido", "indexboleto"), _
			Array("modulo.servicos", "servico902", "", "376520", "0")
		If sMsgFinal = False Then WScript.Sleep INTERVAL*1000
	Loop Until sMsgFinal

    ' Mostra mensagem de finalização
    If sMsgFinal Then
        sMsgFinal = "Script finalizado com sucesso."
    Else
        sMsgFinal = "Script finalizado com erro:" & vbCrLf & sMsgFinal
    End If
	
    MsgBox sMsgFinal, 0, APP_TITLE
    
End Sub

Sub PostRequestFull(Names, Values)
'---------------------------------------------------------------------------------------
' Procedure : PostRequestFull
' Author    : edmoura
' Desc      : Rotina que envia os campos do formulário através do método POST 
' Input     : Link para envio, array com nome dos campos, array com valores
' Output    :
' Usage     : PostRequestFull(names, values)
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
	Dim i, FormData, Name, Value, sResponse
    Dim hDoc, hElems, hElem
	Dim sFile, lFile

	'Enumerate form names and its values
	'and built string representation of the form data
	For i = 0 To UBound(Names)
		'URL encode source fields
		Name = URLEncode(Names(i))
		Value = URLEncode(Values(i))
		If FormData <> "" Then FormData = FormData & "&"
		FormData = FormData & Name & "=" & Value
	Next

	'sResponse = PostRequest(FormData)
	
	'read in the file
    lFile = FreeFile
    sFile = PATH_DEFAULT & "Consulado\Consulado_Data.html"
    Open sFile For Input As lFile
    sResponse = Input$(LOF(lFile), lFile)
	
	If sAutent <> "" Then
		sMsgFinal = False
		Set hDoc = CreateObject("HTMLFile")
		
		hDoc.Write sResponse
		hDoc.Close
		
		i = 0
		sResponse = ""
		
		'loop through  tags
		If FindClass(hDoc, "dtycampo") Then
			sResponse = "Sem data"
			WriteLog sResponse
		Else
			Set hElems = hDoc.getElementsByName("rbtndia")
			If Not hElems Is Nothing Then
				sMsgFinal = True
				For Each hElem In hElems
					i = i + 1
					sResponse = sResponse & hElem.Value & vbCrLf
					WriteLog "Data " & i & ": " & hElem.Value
				Next hElem
				
				Call FazerAgendamento()
				SaveFile "data.txt", sResponse
			End If
		End If
    End If
	
    Set hDoc = Nothing
    Set hElems = Nothing
	
	'HTTPPost URL, FormData
	'IEPostStringRequest URL, FormData
End Sub

Function PostRequest(sRequest)

    Dim oHTTP
    Dim sUrl, bCookie, iPos
    
    If Len(sAutent) <= 0 Then
        bCookie = False
    Else
        bCookie = True
    End If
    
    If bCookie Then
        sUrl = "http://www.consuladoportugalrjservicos.com/public_html/exec"
    Else
        sUrl = "http://www.consuladoportugalrjservicos.com/public_html"
    End If

    Set oHTTP = CreateObject("WinHttp.WinHttpRequest.5.1")
    With oHTTP
        .Open "POST", sUrl, False
        .setRequestHeader "Connection", "keep-alive"
        .setRequestHeader "Content-Length", Len(sRequest)
        .setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        '.setRequestHeader "Cache-Control", "max-age=0"
        '.setRequestHeader "Origin", "http://www.consuladoportugalrjservicos.com"
        '.setRequestHeader "Upgrade-Insecure-Requests", "1"
        '.setRequestHeader "User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36"
        '.setRequestHeader "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
        '.setRequestHeader "Accept-Encoding", "gzip, deflate"
        '.setRequestHeader "Accept-Language", "en-US,en;q=0.8,pt;q=0.6,pt-PT;q=0.4"
        If bCookie Then .setRequestHeader "Cookie", sAutent
		
		On Error Resume Next
		
        .send sRequest
		If Err.Number <> 0 Then
			WriteLog "Error " & Err.Number & "(0x" & hex(Err.Number) & ") " & Err.Description & "| Source " & Err.Source
			Err.Clear
			sMsgFinal = False
			PostRequest = ""
		else
			If bCookie Then
				PostRequest = .responseText
			Else
				iPos = InStr(1, .getResponseHeader("Set-Cookie"), ";") - 1
				PostRequest = Left(.getResponseHeader("Set-Cookie"), iPos)
			End If
		End If
    End With
    
    Set oHTTP = Nothing

End Function

Sub FazerAgendamento()
    
    Dim sResponse
	
    sResponse = PostRequest("modulo=modulo.servicos&acao=servico914&agendardia=20%2F10%2F2016&idpedido=376520&rbtnhora=19")

    SaveFile "response" & TimeStamp() & ".html", sResponse

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
