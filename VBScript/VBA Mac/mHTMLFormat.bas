Attribute VB_Name = "mHTMLFormat"
Sub CatalogFormat()
    ImageDirMac = Range("Image.Folder")
    If Right(ImageDirMac, 1) <> "/" Then ImageDirMac = ImageDirMac & "/"
    ImageDir = "Macintosh HD" & Replace(ImageDirMac, "/", ":")

    MaxLen = Range("MaxLength")

    For Each W In Workbooks
        If W.Sheets(1).Range("A1") = "Path" Then
            W.Activate
            If MsgBox("Is this the file to be formatted?", vbYesNo + vbQuestion, "Is this the file?") = vbYes Then GoTo FileFound
        End If
    Next
    
    ThisWorkbook.Activate
    MsgBox "Unable to find the data file.", vbCritical, "File not found"
    End

FileFound:
    
    '---------------------------------------------------------------------

    ImageCol = Rows(1).Find("Image").Column  'the image column #

    Application.ScreenUpdating = False


    'Reads thru the CSV, Makes a new character string for a new page name and puts it in Column S, ending with ".html", based on the contents of the Title in Col. B.
    'As an example:               Vivid Briana'S 5oz Blazing Plug    (in Column B)
    'Would put into Column S as:  Vivid-Brianas-5oz-Blazing-Plug.html

    For Each ProdName In Range("B2", Range("B65536").End(xlUp))
        HTML = ""
        CHAR = 0  'the character to check - must be alphanumeric
        
        Application.StatusBar = ProdName.Row
        
        While Len(HTML) < MaxLen And CHAR <= MaxLen
            CHAR = CHAR + 1
        
            CharCheck = UCase(Mid(ProdName, CHAR, 1))  'the character being checked

            If CharCheck Like "[A-Z]" Or IsNumeric(CharCheck) Then  'alphanumeric?
                HTML = HTML & Mid(ProdName, CHAR, 1)
            ElseIf CharCheck = " " Then   'if a space, convert it to a dash
                HTML = HTML & "-"
            End If
            
            HTML = Application.Substitute(HTML, "--", "-") ' " - " will cause 3 dashes. This line of code will keep that from happening
        Wend
    

        If HTML <> "" Then
            'check previous rows for another item with matching HTML - Add a 1,2,etc if necessary
            If Not Range(Cells(ProdName.Row - 1, Columns("S").Column), Cells(ProdName.Row - 1, Columns("S").Column)).Find(HTML & ".html", LookAt:=xlWhole) Is Nothing Then
                CNT = 1
                'increment CNT until a previous match isn't found
                While Not Range(Cells(ProdName.Row - 1, Columns("S").Column), Cells(ProdName.Row - 1, Columns("S").Column)).Find(HTML & "-" & CNT & ".html", LookAt:=xlWhole) Is Nothing
                    CNT = CNT + 1
                Wend
                
                Cells(ProdName.Row, Columns("S").Column).Value = HTML & "-" & CNT & ".html"  'add a # to the end
            Else
                Cells(ProdName.Row, Columns("S").Column).Value = HTML & ".html"  'no previous matching items found
            End If
            
            'IMAGES----------------------------------------------
                
    
            'As an example:
            'Col G has 9982.jpg
            'Change the Data in Column G to Vivid-Brianas-Blazing-Plug.jpg
            'And rename the image in the Folder "9982.jpg" to "Vivid-Brianas-Blazing-Plug.jpg"

            'Note: We may have duplicate names, similar to what you did in a recent macro you wrote for us. You may have to add a "-2" or "-3" etc to the end of some of them. (Don't worry about exceeding the "Maximum length" by 2 characters, no biggie).

            Image = FolderExists(ImageDir & Cells(ProdName.Row, ImageCol)) ' Image = Dir(ImageDir & Cells(ProdName.Row, ImageCol))  'find the original image

            If Image = True Then
                Image = Cells(ProdName.Row, ImageCol)
                If FolderExists(ImageDir & HTML & ".JPG") = True Then
                    'new image already exists
                    Cells(ProdName.Row, ImageCol).AddComment "Unable to rename " & Cells(ProdName.Row, ImageCol).Value & Chr(10) & "Image already exists."
                    Cells(ProdName.Row, ImageCol).Value = HTML & ".JPG"
                    Cells(ProdName.Row, ImageCol).Interior.ColorIndex = 5
                End If

                'found the image
                Name ImageDirMac & Image As ImageDirMac & HTML & ".JPG"  'rename the image to match HTML string
                Cells(ProdName.Row, ImageCol).Value = HTML & ".JPG"
            Else
                'image not found. rename it anyway but put a comment with the old name and color it yellow
                Cells(ProdName.Row, ImageCol).AddComment "Was " & Cells(ProdName.Row, ImageCol).Value
                Cells(ProdName.Row, ImageCol).Value = HTML & ".JPG"
                Cells(ProdName.Row, ImageCol).Interior.ColorIndex = 6
            End If
            
        End If
        
    Next
    
    Application.StatusBar = False

End Sub

Function FolderExists(strPath As String) As Boolean
'---------------------------------------------------------------------------------------
' Procedure : FolderExists
' Author    : eduardomourar@gmail.com
' Desc      : Function to check if a path (folder or file) exists
' Input     : Path to file or folder to check
' Output    : True if path exists or else False
' Usage     : FolderToCheck = FolderExists(strPath)
' Date      : 2016-12-08
'---------------------------------------------------------------------------------------
'
    Dim strScript As String
    Dim strTest As String

    If Val(Application.Version) < 15 Then
        ' If on Office 2011 Mac, use AppleScript through MacScript function to avoid
        ' long names issues, due to limit is max 32 characters including the extension
        strScript = "tell application " & Chr(34) & "System Events" & Chr(34) & _
            "to return exists disk item (" & Chr(34) & strPath & Chr(34) & " as string)"
        FolderExists = MacScript(strScript)
    Else
        On Error Resume Next
        strTest = Dir(strPath, vbDirectory)
        On Error GoTo 0
        If Not strTest = vbNullString Then FolderExists = True
    End If
End Function
