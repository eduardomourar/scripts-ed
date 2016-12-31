'---------------------------------------------------------------------------------------
' Name      : Acessar Página
' Author    : eduardmourar
' Desc      : Script para acessar o site
' Date      : 2016-09-28
' Changed   : 2016-12-31
'---------------------------------------------------------------------------------------
' Copyright (C) 2016
'---------------------------------------------------------------------------------------

Option Explicit ' Force explicit variable declaration

'*************************************( CONSTANTS )*************************************

Const APP_TITLE = "Acessar Página"
Const PATH_DEFAULT = "C:\Users\ADMIN\Desktop\"
Const USER_CPF = "USER_CPF" 'Substituir por dados reais
Const USER_NAME = "USER_NAME"
Const USER_PASS = "USER_PASS"
Const INTERVAL = 60 ' Em segundos
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
' Author    : eduardmourar
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
' Author    : eduardmourar
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
' Author    : eduardmourar
' Desc      : Rotina principal do programa
' Input     :
' Output    :
' Usage     : Main()
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
	sAutent = ""
	sMsgFinal = False
	
	Call FazerAgendamento()

    ' Mostra mensagem de finalização
    If sMsgFinal Then
        sMsgFinal = "Script finalizado com sucesso."
    Else
        sMsgFinal = "Script finalizado com erro:" & vbCrLf & sMsgFinal
    End If
	
    MsgBox sMsgFinal, 0, APP_TITLE
    
End Sub

Function PostRequestFull(Names, Values)
'---------------------------------------------------------------------------------------
' Procedure : PostRequestFull
' Author    : eduardmourar
' Desc      : Rotina que envia os campos do formulário através do método POST 
' Input     : Link para envio, array com nome dos campos, array com valores
' Output    :
' Usage     : PostRequestFull(names, values)
' Date      : 2016-09-28
'---------------------------------------------------------------------------------------
'
	Dim i, FormData, Name, Value

	'Enumerate form names and its values and built string representation of the form data
	For i = 0 To UBound(Names)
		'URL encode source fields
		Name = URLEncode(Names(i))
		Value = URLEncode(Values(i))
		If FormData <> "" Then FormData = FormData & "&"
		FormData = FormData & Name & "=" & Value
	Next

	PostRequestFull = PostRequest(FormData)
	
End Function

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
	
	sAutent = PostRequest(sAutent)
	WriteLog sAutent
	sResponse = PostRequestFull(Array("modulo", "acao", "txtcpf", "txtusuario", "txtsenha"), _
		Array("modulo.login", "login001", USER_CPF, USER_NAME, USER_PASS))
		
	'Tabela de equivalência do campo rbtnhora
	'rbtnhora	1		2		3		4		5		6		7		8		9		10		11		12		13		14		15		16		17		18		19		20		21		22		23		24		25		26		27		28		29		30		31		32		33
	'Horário	08:00	08:15	08:30	08:45	09:00	09:15	09:30	09:45	10:00	10:15	10:30	10:45	11:00	11:15	11:30	11:45	12:00	12:15	12:30	12:45	13:00	13:15	13:30	13:45	14:00	14:15	14:30	14:45	15:00	15:15	15:30	15:45	16:00

	' Lista de serviços agendados
	sResponse = PostRequestFull(Array("modulo", "acao"), _
		Array("modulo.servicos", "servico900"))

	' Passaporte Normal (com entrega de Cartão de Cidadão)
	'sResponse = PostRequestFull(Array("modulo", "acao", "idservico", "idsrv", "agendardia", "rbtnhora"), _
	'	Array("modulo.servicos", "servico1902", "21", "30", "30/11/2016", "22"))

    SaveFile "response" & TimeStamp() & ".html", sResponse

End Sub
