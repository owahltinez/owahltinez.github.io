@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "New-Item -ErrorAction Ignore -ItemType directory -Path ~/Bin; $LOCALBIN=(Resolve-Path ~/Bin).Path; SETX /M PATH \"$LOCALBIN;$PATH\""
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "Invoke-WebRequest https://gitlab.com/$USERNAME/initscripts/raw/master/windows/profile.ps1 -OutFile ~/Documents/profile.ps1"
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "Invoke-WebRequest https://gitlab.com/$USERNAME/initscripts/raw/master/linux/gitsetup.sh -OutFile ~/Bin/GitSetup.ps1"
cinst -y googlechrome 7zip.install putty.install scriptcs filezilla treesizefree notepadplusplus.install miniconda3 git.install paint.net nodejs.install visualstudio2015community
