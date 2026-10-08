<#
.SYNOPSIS
  awesome-python - Windows installer (PowerShell edition).

.DESCRIPTION
  Installs everything this repo needs on Windows:
    1. Python virtual environment (.venv)
    2. Docs toolchain from requirements.txt (MkDocs + Material)
    3. README.md -> docs/index.md wiring (Windows-safe copy)
    4. Verifies sort.py and the MkDocs install

  Requires Python 3.9+ (3.11+ recommended) and optionally Git.

.EXAMPLE
  Right-click -> "Run with PowerShell", or from a terminal in this folder:
    powershell -ExecutionPolicy Bypass -File .\Install.ps1
#>
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

function Step($msg) { Write-Host "`n== $msg" -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "   OK: $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "   WARNING: $msg" -ForegroundColor Yellow }
function Fail($msg) { Write-Host "`n   ERROR: $msg" -ForegroundColor Red; exit 1 }

Write-Host "`n================================================" -ForegroundColor Magenta
Write-Host " awesome-python - Windows installer" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta

# ---------- 1. Find Python ----------
Step "[1/5] Locating Python..."
$py = $null
if (Get-Command py -ErrorAction SilentlyContinue) {
    $py = 'py'; $pyArgs = @('-3')
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $py = 'python'; $pyArgs = @()
} else {
    Fail "Python was not found on your PATH.`nInstall Python 3.11+ from https://www.python.org/downloads/`nIMPORTANT: tick `"Add python.exe to PATH`" on the first setup screen, then re-run this script."
}
$version = & $py @pyArgs --version 2>&1
Write-Host "   Using: $py ($version)"
& $py @pyArgs -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)"
if ($LASTEXITCODE -ne 0) { Fail "Python 3.9+ is required, found: $version`nDownload a newer Python from https://www.python.org/downloads/" }
Ok "$version"

# ---------- 2. Check Git (warn only) ----------
Step "[2/5] Checking for Git..."
if (Get-Command git -ErrorAction SilentlyContinue) {
    Ok ((git --version) -join ' ')
} else {
    Warn "Git was not found. Install it from https://git-scm.com/downloads/win to clone/update this repo cleanly."
}

# ---------- 3. Create virtual environment ----------
Step "[3/5] Creating virtual environment (.venv)..."
if (-not (Test-Path '.\.venv\Scripts\python.exe')) {
    & $py @pyArgs -m venv .venv
    if ($LASTEXITCODE -ne 0) { Fail "Could not create the virtual environment." }
    Ok "Created .venv"
} else {
    Ok ".venv already exists - reusing it"
}
$venvPython = '.\.venv\Scripts\python.exe'
$venvMkdocs = '.\.venv\Scripts\mkdocs.exe'

# ---------- 4. Install requirements ----------
Step "[4/5] Installing requirements (MkDocs + Material theme)..."
& $venvPython -m pip install --upgrade pip
& $venvPython -m pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) { Fail "pip install failed. Check your internet connection and re-run this script." }
Ok "requirements installed"

# ---------- 5. Wire README into the docs site ----------
Step "[5/5] Wiring README.md into the docs site..."
if (-not (Test-Path '.\docs')) { New-Item -ItemType Directory -Path '.\docs' | Out-Null }
Copy-Item -Force '.\README.md' '.\docs\index.md'
Ok "README.md -> docs\index.md"

# ---------- Verify ----------
Step "Verifying installation..."
& $venvPython -m py_compile sort.py
if ($LASTEXITCODE -ne 0) { Fail "sort.py failed to compile." }
Ok "sort.py compiles"
& $venvMkdocs --version
Ok "MkDocs runs"

Write-Host "`n================================================" -ForegroundColor Green
Write-Host " SUCCESS! Everything is installed." -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green
Write-Host "Next steps (run these in this folder):`n"
Write-Host "  Preview the website:" -ForegroundColor Yellow
Write-Host "    .\.venv\Scripts\mkdocs serve"
Write-Host "    then open http://127.0.0.1:8000 in your browser`n"
Write-Host "  Keep the list alphabetically sorted:" -ForegroundColor Yellow
Write-Host "    .\.venv\Scripts\python sort.py`n"
Write-Host "  Build the static site (goes to the site\ folder):" -ForegroundColor Yellow
Write-Host "    .\.venv\Scripts\mkdocs build`n"
Write-Host "Full guide: WINDOWS_SETUP.md`n"
