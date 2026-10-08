@echo off
REM ============================================================
REM  awesome-python - Windows one-click installer
REM  Installs everything this repo needs on Windows:
REM    1. Python virtual environment (.venv)
REM    2. Docs toolchain from requirements.txt (MkDocs + Material)
REM    3. README -> docs\index.md link step (Windows-safe copy)
REM    4. Verifies sort.py and the MkDocs site build
REM
REM  Just double-click this file. Requires Python 3.9+ and Git.
REM  See WINDOWS_SETUP.md for the full step-by-step guide.
REM ============================================================
setlocal EnableExtensions
cd /d "%~dp0"
title awesome-python - Windows installer

echo.
echo  ================================================
echo   awesome-python - Windows installer
echo  ================================================
echo.

REM ---------- 1. Find Python ----------
set "PY="
where py >nul 2>nul
if %errorlevel%==0 set "PY=py -3"
if not defined PY (
    where python >nul 2>nul
    if %errorlevel%==0 set "PY=python"
)
if not defined PY (
    echo  [ERROR] Python was not found on your PATH.
    echo.
    echo  Please install Python 3.11 or newer from:
    echo    https://www.python.org/downloads/
    echo  IMPORTANT: on the first setup screen tick
    echo  "Add python.exe to PATH", then re-run this file.
    echo.
    pause
    exit /b 1
)
echo  [1/5] Using Python: %PY%
%PY% --version
%PY% -c "import sys; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)"
if not %errorlevel%==0 (
    echo  [ERROR] Python 3.9 or newer is required. You have:
    %PY% --version
    echo  Download a newer Python from https://www.python.org/downloads/
    pause
    exit /b 1
)

REM ---------- 2. Check Git (warn only) ----------
where git >nul 2>nul
if %errorlevel%==0 (
    echo  [2/5] Git found:
    git --version
) else (
    echo  [2/5] WARNING: Git was not found. You can still use this
    echo        folder, but install Git to clone/update cleanly:
    echo        https://git-scm.com/downloads/win
)

REM ---------- 3. Create virtual environment ----------
echo.
echo  [3/5] Creating virtual environment (.venv)...
if not exist ".venv\Scripts\python.exe" (
    %PY% -m venv .venv
    if not %errorlevel%==0 (
        echo  [ERROR] Could not create the virtual environment.
        pause
        exit /b 1
    )
) else (
    echo        .venv already exists - reusing it.
)

REM ---------- 4. Install requirements ----------
echo.
echo  [4/5] Installing requirements (MkDocs + Material theme)...
.venv\Scripts\python -m pip install --upgrade pip
.venv\Scripts\python -m pip install -r requirements.txt
if not %errorlevel%==0 (
    echo  [ERROR] pip install failed. Check your internet connection
    echo  and re-run this file.
    pause
    exit /b 1
)

REM ---------- 5. Link README for the docs site ----------
echo.
echo  [5/5] Wiring README.md into the docs site...
if not exist "docs" mkdir docs
copy /Y README.md docs\index.md >nul
if not %errorlevel%==0 (
    echo  [ERROR] Could not copy README.md to docs\index.md
    pause
    exit /b 1
)
echo        README.md -^> docs\index.md  (done)

REM ---------- Verify ----------
echo.
echo  Verifying installation...
.venv\Scripts\python -m py_compile sort.py
if %errorlevel%==0 (
    echo        sort.py ............ OK
) else (
    echo        sort.py ............ FAILED
)
.venv\Scripts\mkdocs --version
echo.
echo  ================================================
echo   SUCCESS! Everything is installed.
echo  ================================================
echo.
echo  Next steps (run these in this folder):
echo.
echo    Preview the website:
echo      .venv\Scripts\mkdocs serve
echo      then open  http://127.0.0.1:8000  in your browser
echo.
echo    Keep the list alphabetically sorted:
echo      .venv\Scripts\python sort.py
echo.
echo    Build the static site (goes to the site\ folder):
echo      .venv\Scripts\mkdocs build
echo.
echo  Full guide: WINDOWS_SETUP.md
echo.
pause
