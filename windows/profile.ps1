# Useful aliases
function l { Get-ChildItem -Force $args }
function npp { start notepad++ }
function Invoke-Admin { Start-Process $([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName) -Verb runAs }