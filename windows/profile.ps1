# Useful aliases
Set-Alias wget Invoke-WebRequest
function _elevate { Start-Process powershell -Verb runAs }; Set-Alias elevate _elevate;
