$PackagesList = @(
"Microsoft.WindowsTerminal",
"Microsoft.PowerToys",
"Microsoft.VisualStudioCode",
"Google.Chrome",
"Google.Drive",
"Zoom.Zoom",
"VideoLAN.VLC",
"SlackTechnologies.Slack",
"7zip.7zip",
"Postman.Postman"
)

$VSCodeExtensionsList = @(
# Theme
"GitHub.github-vscode-theme",
"pkief.material-product-icons",
"PKief.material-icon-theme",
# Remote WSL
"ms-vscode-remote.remote-wsl",
# Docker and kubernetes
"ms-azuretools.vscode-docker",
"ms-kubernetes-tools.vscode-kubernetes-tools",
# Powershell
"ms-vscode.powershell",
# Terraform
"hashicorp.terraform",
"erd0s.terraform-autocomplete",
"pjmiravalle.terraform-advanced-syntax-highlighting",
# Search in JSON
"weijunyu.vscode-json-path",
# CSV coloration and RBQL support
"mechatroner.rainbow-csv",
# YAML and k8s stubs support
"redhat.vscode-yaml",
# XML linter
"dotjoshjohnson.xml",
# Python and associated language server
"ms-python.python",
"ms-python.vscode-pylance",
# Go
"golang.go",
# Shellcheck
"timonwong.shellcheck",
# Jinja templating
"samuelcolvin.jinjahtml",
# Bats support
"jetmartin.bats",
# Open Policy Agent
"tsandall.opa",
# Bridgecrew checkov
"bridgecrew.checkov",
# Markdown linter	
"davidanson.vscode-markdownlint",
# Asciidoctor
"asciidoctor.asciidoctor-vscode"
)

$wslboxFolder = "$([Environment]::GetFolderPath("MyDocuments"))\wslbox"


function InstallWinGet() {
	$hasPackageManager = Get-AppPackage -name "Microsoft.DesktopAppInstaller"

	if(!$hasPackageManager)
	{
		$releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		$releases = Invoke-RestMethod -uri "$($releases_url)"
		$latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1
	
		Add-AppxPackage -Path $latestRelease.browser_download_url
	}
}

function InstallPackages() {

    foreach ($Package in $PackagesList) {
        winget install -e --id $Package
    }
}

function InstallWSLArchlinux() {
	$filename = "Arch_Online.zip"


	$releases_url = "https://api.github.com/repos/yuk7/ArchWSL/releases/latest"

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$releases = Invoke-RestMethod -Uri "$($releases_url)"
	$latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("$filename") } | Select-Object -First 1

	New-Item -Path "$wslboxFolder" -ItemType Directory | Out-Null
	Set-Location -Path "$wslboxFolder"

	Invoke-RestMethod -Uri $latestRelease.browser_download_url -OutFile $filename
	Expand-Archive -Path "$filename" -DestinationPath "$wslboxFolder" | Out-Null
	
	Remove-Item -Path "$filename"
}

function InstallVSCodeExtensions() {

    foreach ($Extension in $VSCodeExtensionsList) {
        code --install-extension $Extension
    }
}


InstallWinget
InstallPackages
InstallWSLArchlinux
InstallVSCodeExtensions