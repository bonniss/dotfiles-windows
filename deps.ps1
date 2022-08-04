# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}


### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force


### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Yellow"
Get-PackageProvider NuGet -Force | Out-Null
# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted


### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force


### Chocolatey
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# System
choco install -y 7zip                            --limit-output
choco install -y sharex                          --limit-output
choco install -y figma                           --limit-output
choco install -y notepadplusplus                 --limit-output
choco install -y powertoys                       --limit-output
choco install -y microsoft-windows-terminal      --limit-output
choco install -y mobaxterm                       --limit-output
choco install -y vlc                             --limit-output
choco install -y winscp                          --limit-output
choco install -y skype                           --limit-output
choco install -y paint.net                       --limit-output
choco install -y vscode                          --limit-output
choco install -y vim                             --limit-output
choco install -y winmerge                        --limit-output

# Langs and runtime
choco install -y nuget.commandline    --limit-output
choco install -y git.install          --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
choco install -y nvm.portable         --limit-output
choco install -y python               --limit-output
choco install -y julia                --limit-output
choco install -y ruby                 --limit-output
choco install -y golang               --limit-output
choco install -y hugo                 --limit-output
choco install -y dotnetcore-sdk       --limit-output
choco install -y laragon.install      --limit-output
# / A universal document converter
choco install -y pandoc               --limit-output
# / Youtube downloader
choco install -y youtube-dl           --limit-output

# Fonts
choco install -y sourcecodepro        --limit-output

# Databases
choco install -y mongodb                   --limit-output
choco install -y mongodb-database-tools    --limit-output
choco install -y mongodb-compass           --limit-output
choco install -y postgresql                --limit-output
choco install -y sqlite                    --limit-output
choco install -y dbeaver                   --limit-output

# Optional
# choco install GoogleChrome        --limit-output; <# pin; evergreen #> choco pin add --name GoogleChrome        --limit-output
# choco install GoogleChrome.Canary --limit-output; <# pin; evergreen #> choco pin add --name GoogleChrome.Canary --limit-output
# choco install Firefox             --limit-output; <# pin; evergreen #> choco pin add --name Firefox             --limit-output
# choco install Opera               --limit-output; <# pin; evergreen #> choco pin add --name Opera               --limit-output
# choco install atom                --limit-output; <# pin; evergreen #> choco pin add --name Atom                --limit-output
# choco install Fiddler             --limit-output

Refresh-Environment

nvm on
$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion
Remove-Variable nodeLtsVersion

gem pristine --all --env-shebang

### Windows Features
Write-Host "Installing Windows Features..." -ForegroundColor "Yellow"
# IIS Base Configuration
# Enable-WindowsOptionalFeature -Online -All -FeatureName `
#     "IIS-BasicAuthentication", `
#     "IIS-DefaultDocument", `
#     "IIS-DirectoryBrowsing", `
#     "IIS-HttpCompressionDynamic", `
#     "IIS-HttpCompressionStatic", `
#     "IIS-HttpErrors", `
#     "IIS-HttpLogging", `
#     "IIS-ISAPIExtensions", `
#     "IIS-ISAPIFilter", `
#     "IIS-ManagementConsole", `
#     "IIS-RequestFiltering", `
#     "IIS-StaticContent", `
#     "IIS-WebSockets", `
#     "IIS-WindowsAuthentication" `
#     -NoRestart | Out-Null

# ASP.NET Base Configuration
# Enable-WindowsOptionalFeature -Online -All -FeatureName `
#     "NetFx3", `
#     "NetFx4-AdvSrvs", `
#     "NetFx4Extended-ASPNET45", `
#     "IIS-NetFxExtensibility", `
#     "IIS-NetFxExtensibility45", `
#     "IIS-ASPNET", `
#     "IIS-ASPNET45" `
#     -NoRestart | Out-Null

# Web Platform Installer for remaining Windows features
# webpicmd /Install /AcceptEula /Products:"UrlRewrite2"

### Node Packages
Write-Host "Installing Node Packages..." -ForegroundColor "Yellow"
if (which npm) {
    npm update npm
    npm install -g cowsay
}

### Janus for vim
Write-Host "Installing Janus..." -ForegroundColor "Yellow"
if ((which curl) -and (which vim) -and (which rake) -and (which bash)) {
    curl.exe -L https://bit.ly/janus-bootstrap | bash
}
