@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
cinst -y googlechrome 7zip.install putty.install scriptcs filezilla treesizefree notepadplusplus.install miniconda3 git.install paint.net nodejs.install visualstudio2015community
C:\tools\Miniconda3\Scripts\conda.exe create -y -n py2 python=2.7 anaconda
C:\tools\Miniconda3\Scripts\conda.exe create -y -n py3 python=3.4 anaconda
