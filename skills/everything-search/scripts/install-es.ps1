[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateSet('Auto', 'x64', 'x86', 'ARM64', 'ARM')]
    [string]$Architecture = 'Auto',

    [string]$InstallDirectory = (Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps'),

    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    throw 'ES is available only for Windows.'
}

if ($Architecture -eq 'Auto') {
    $Architecture = switch ([Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()) {
        'X64' { 'x64' }
        'X86' { 'x86' }
        'Arm64' { 'ARM64' }
        'Arm' { 'ARM' }
        default { throw "Unsupported Windows architecture: $_" }
    }
}

$destinationDirectory = [IO.Path]::GetFullPath($InstallDirectory)
$destination = Join-Path $destinationDirectory 'es.exe'

if ((Test-Path -LiteralPath $destination) -and -not $Force) {
    Write-Output "ES is already installed at $destination. Use -Force to replace it."
    return
}

if (-not $PSCmdlet.ShouldProcess($destination, 'Resolve, download, verify, and install the latest official voidtools ES release')) {
    return
}

$release = Invoke-RestMethod `
    -Uri 'https://api.github.com/repos/voidtools/ES/releases/latest' `
    -Headers @{ 'User-Agent' = 'everything-search-agent-skill' }

$asset = @($release.assets) | Where-Object { $_.name -match "\.$([regex]::Escape($Architecture))\.zip$" } | Select-Object -First 1
if (-not $asset) {
    throw "The latest voidtools/ES release has no $Architecture asset."
}

if ($asset.browser_download_url -notlike 'https://github.com/voidtools/ES/releases/download/*') {
    throw "Unexpected download URL: $($asset.browser_download_url)"
}

if ($asset.digest -notmatch '^sha256:([0-9a-fA-F]{64})$') {
    throw 'The release asset does not provide a SHA-256 digest; refusing an unverified installation.'
}
$expectedHash = $Matches[1].ToLowerInvariant()

$temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) ("everything-search-skill-" + [guid]::NewGuid().ToString('N'))
$archive = Join-Path $temporaryRoot $asset.name
$expanded = Join-Path $temporaryRoot 'expanded'

try {
    New-Item -ItemType Directory -Path $temporaryRoot, $expanded -Force | Out-Null
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive -Headers @{ 'User-Agent' = 'everything-search-agent-skill' }

    $actualHash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $expectedHash) {
        throw "SHA-256 mismatch for $($asset.name)."
    }

    Expand-Archive -LiteralPath $archive -DestinationPath $expanded -Force
    $downloadedEs = Get-ChildItem -LiteralPath $expanded -Recurse -Filter es.exe -File | Select-Object -First 1
    if (-not $downloadedEs) {
        throw 'The verified release archive does not contain es.exe.'
    }

    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    Copy-Item -LiteralPath $downloadedEs.FullName -Destination $destination -Force
    Unblock-File -LiteralPath $destination -ErrorAction SilentlyContinue

    Write-Output "Installed ES $($release.tag_name) ($Architecture) to $destination"
    if (-not (Get-Command es.exe -ErrorAction SilentlyContinue)) {
        Write-Warning 'The installation directory is not currently on PATH. Add it to PATH or invoke es.exe by its full path.'
    }
}
finally {
    if (Test-Path -LiteralPath $temporaryRoot) {
        Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
    }
}
