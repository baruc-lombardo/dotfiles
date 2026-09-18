[CmdletBinding()]
param([switch]$SkipToolInstall, [switch]$Force)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Link-ManagedFile([string]$source, [string]$target) {
  New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
  if (Test-Path -LiteralPath $target) {
    $item = Get-Item -LiteralPath $target -Force
    if ($item.LinkType -and $item.Target -contains $source) { return }
    if (-not $Force) { Write-Warning "Leaving existing file: $target. Use -Force to manage it here."; return }
    Move-Item -LiteralPath $target -Destination "$target.backup-$stamp"
  }
  try { New-Item -ItemType SymbolicLink -Path $target -Target $source | Out-Null }
  catch { Copy-Item -LiteralPath $source -Destination $target -Force }
}

if (-not $SkipToolInstall) {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { winget install --id OpenJS.NodeJS.LTS --exact --accept-package-agreements --accept-source-agreements }
  if (-not (Get-Command pi -ErrorAction SilentlyContinue)) { Invoke-RestMethod 'https://pi.dev/install.ps1' | Invoke-Expression }
  if (-not (Get-Command codex -ErrorAction SilentlyContinue)) { npm install --global @openai/codex }
  if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { npm install --global @anthropic-ai/claude-code }
}

$homeDirectory = [Environment]::GetFolderPath('UserProfile')
Link-ManagedFile (Join-Path $repoRoot 'AGENTS.md') (Join-Path $homeDirectory '.pi\agent\AGENTS.md')
Link-ManagedFile (Join-Path $repoRoot 'AGENTS.md') (Join-Path $homeDirectory '.codex\AGENTS.md')
Link-ManagedFile (Join-Path $repoRoot 'AGENTS.md') (Join-Path $homeDirectory '.claude\CLAUDE.md')
Write-Host 'Setup complete. Sign in separately with pi, codex, and claude.'
