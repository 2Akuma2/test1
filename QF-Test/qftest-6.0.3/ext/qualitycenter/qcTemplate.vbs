'=========================================================================================
' Execute QF-Test using the given options and perform upload of the run-log to the CurrenRun.
'
' testrun	 : The Testrun object.
' test	         : The test-case or test-set.
' suite          : The path to the test-suite file.
' runLogFile     : Optional name of the run-log.
' timeout	 : Optional timeout of test-execution.
' uploadResult   : Optional 1 for uploading the run-log, 0 for not uploading the run-log.
' qftestExe	 : Optional path to qftest-executable.
' runOptions     : Optional runOptions for qftest-run, e.g. "-report.warnings".
' runMode	 : Optional runMode, e.g. "-batch" or "-batch -calldaemon".
'=========================================================================================
  
Public Function executeQFTest (ByRef testrun, ByRef test, ByRef suite, ByRef runLogFile, ByRef timeout, ByRef uploadResult, ByRef qftestExe, ByRef runOptions, ByRef runMode )

  cmdString = ""

  '==================================================================================
  ' Default Options

  defaultRunMode = "-batch"
  defaultRunOptions = ""
  defaultRunLogFile = "" 
  qftestCall = "qftest.exe"
  thisTimeout = -1
  defaultUploadResult = 1

  '==================================================================================
  ' Evaluate given parameters

  If runMode <> "" Then
    cmdString = runMode
  Else
    cmdString = defaultRunMode 
    runMode = defaultRunMode
  End If

  If runOptions <> "" Then
    cmdString = cmdString & " " & runOptions
  Else
    cmdString = cmdString & " " & defaultRunOptions
  End If

  If runLogFile <> "" Then
    cmdString = cmdString & " -runlog """ & runLogFile & """" 
  Else
    cmdString = cmdString & " -runlog """ & defaultRunLogFile & """"
  End If

  If test <> "" and runMode = "-batch" Then
    cmdString = cmdString & " -test """ & test  & """"
  End If

  If suite <> "" Then
    cmdString = cmdString & " """ & suite & """"
    If test <> "" and InStr(runMode, "-calldaemon") > 0 Then
      cmdString = cmdString & "#""" & test & """"
    End If
  End If

  If qftestExe <> "" Then
    qftestCall = qftestExe
  End If

  If timeout <> "" Then
    thisTimeout = cInt(timeout)
  End If

  '==================================================================================
  ' Launch QF-Test with the given parameters

  TDOutput.Print "Launch -> " & qftestCall & " " & cmdString

  Dim status
  status = XTools.run (qftestCall, cmdString , thisTimeout, FALSE)  

  TDOutput.Print "... QF-Test terminated with " & status & "."  
  
  '==================================================================================
  ' Uploading the run-log.

  If uploadResult <> "" Then
   If uploadResult = 1 Then
      uploadStatus = doUploadRunLog (testrun, runLogFile)
   End If
  Else:
    If defaultUploadResult = 1 Then
      uploadStatus = doUploadRunLog (testrun, runLogFile)
    End If
  End If

  '==================================================================================
  ' Handle run-time errors.

  If Err.Number <> 0 Then
    TDOutput.Print "Run-time error [" & Err.Number & "] : " & Err.Description
  End If

  TDOutput.Print "Codes --> Tests: " & status

  executeQFTest = status
End Function


'=========================================================================================
' Upload of the run-log file.
' testrun: The CurrentRun object
' runLogFile: The file name of the run-log to be uploaded.
'=========================================================================================

Public Function doUploadRunLog (byRef testrun, byRef runLogFile)
    TDOutput.Print "Create attachments..."

    Set objFso = CreateObject("Scripting.FileSystemObject")
    content = objFso.GetFile(runLogFile)
    res = "-1"

    If content <> "" Then
      Dim attachF, attI
      Set attachF = testrun.Attachments 
      Set attI = attachF.AddItem(Null) 
      attI.FileName = runLogFile
      attI.Type = 1
      attI.Post
      set attachF = nothing
      set attI = nothing
      TDOutput.Print "... attachements created."
      res = "1"
    Else:
      TDOutput.Print "Couldn't find run-log file '" & runLogFile & "'!"
    End if  
 
    doUploadRunLog = res
End Function