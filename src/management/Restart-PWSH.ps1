function Restart-PWSH {
    [CmdletBinding(PositionalBinding = $False)]
    Param() 

    Start-Process -FilePath "pwsh.exe" -Verb 'Open'
    Stop-Process -Id $PID
}