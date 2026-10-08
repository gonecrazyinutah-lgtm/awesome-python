# Windows Setup Guide — awesome-python

> **What is this repo?** `awesome-python` is a curated **list** (a big `README.md`)
> of Python libraries — it is not a package you `pip install`. "Everything it needs"
> on Windows is: **Python + Git + the docs toolchain** (MkDocs) so you can read,
> preview, edit, sort, and contribute to the list. This guide installs all of that.

---

## Option A: Automatic install (recommended)

If you already have **Python 3.11+** and **Git** installed, just:

1. Open this folder in File Explorer.
2. **Double-click `install.bat`** — that's it.

Or with PowerShell (right-click → *Run with PowerShell*, or from a terminal in this folder):

```powershell
powershell -ExecutionPolicy Bypass -File .\Install.ps1
```

The installer will:

- [x] Create a virtual environment (`.venv`)
- [x] Install `requirements.txt` (MkDocs + Material theme)
- [x] Wire `README.md` → `docs\index.md` for the docs site
- [x] Verify `sort.py` and the MkDocs build work

Then jump to [Daily commands](#daily-commands).

---

## Option B: Step-by-step from scratch

### Step 1 — Install Python

1. Download **Python 3.11 or newer** (64-bit) from
   [python.org/downloads](https://www.python.org/downloads/).
2. Run the installer. **IMPORTANT:** on the very first screen, tick
   ✅ **"Add python.exe to PATH"** (or "Add Python to environment variables"),
   then click *Install Now*.
3. Verify — open **PowerShell** or **Command Prompt** and run:

   ```powershell
   py --version
   python --version
   ```

   You should see something like `Python 3.12.x`. If you get
   *"not recognized"*, reinstall and don't skip the PATH checkbox.

### Step 2 — Install Git for Windows

1. Download from [git-scm.com/downloads/win](https://git-scm.com/downloads/win).
2. Run the installer, accept the defaults (make sure
   *"Git from the command line…"* stays enabled).
3. Verify:

   ```powershell
   git --version
   ```

### Step 3 — Get this repository

```powershell
git clone https://github.com/gonecrazyinutah-lgtm/awesome-python.git
cd awesome-python
```

(Or download the ZIP from GitHub and extract it.)

### Step 4 — Run the installer

Double-click **`install.bat`**, or in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install.ps1
```

Manual equivalent (if you prefer doing it by hand):

```powershell
py -3 -m venv .venv
.\.venv\Scripts\python -m pip install --upgrade pip
.\.venv\Scripts\python -m pip install -r requirements.txt
Copy-Item README.md docs\index.md   # Windows version of `make site_link`
```

> **Note:** the `Makefile` (`make site_preview`, …) is for macOS/Linux.
> On Windows, use the `.venv\Scripts\mkdocs` commands below instead —
> they do exactly the same thing. (`docs\index.md` is git-ignored, so the
> copy never pollutes your commits.)

---

## Daily commands

Run these from the repo folder in PowerShell / Command Prompt:

| What | Command |
|---|---|
| Preview the website locally | `.\.venv\Scripts\mkdocs serve` → open http://127.0.0.1:8000 |
| Build the static site | `.\.venv\Scripts\mkdocs build` (output goes to `site\`) |
| Keep entries alphabetically sorted | `.\.venv\Scripts\python sort.py` |
| Activate the venv (optional) | `.\.venv\Scripts\Activate.ps1` |

After editing `README.md`, re-copy it before previewing/building:

```powershell
Copy-Item README.md docs\index.md
.\.venv\Scripts\mkdocs serve
```

## Contributing a new library

1. Read [`CONTRIBUTING.md`](CONTRIBUTING.md) (acceptance criteria + entry format).
2. Add your entry to `README.md` in the right category, alphabetical order.
3. Run `.\.venv\Scripts\python sort.py` to auto-fix ordering.
4. Preview with `.\.venv\Scripts\mkdocs serve`, then commit & push.

Entry format:

```markdown
- [project-name](https://github.com/owner/repo) - Concise description ending with period.
```

---

## Troubleshooting

**`py` / `python` is not recognized**
Python isn't on your PATH. Reinstall Python and tick ✅ *"Add python.exe
to PATH"*. Then close and reopen your terminal.

**`... cannot be loaded because running scripts is disabled` (PowerShell)**
Run the bypass form once (safe — it only applies to that one command):

```powershell
powershell -ExecutionPolicy Bypass -File .\Install.ps1
```

**`pip install` fails / times out**
Check your internet connection and proxy/VPN, then re-run `install.bat`
(it safely resumes — it reuses the existing `.venv`).

**`mkdocs serve` says the port is in use**
Another preview is already running. Stop it with `Ctrl+C`, or use another port:

```powershell
.\.venv\Scripts\mkdocs serve -a 127.0.0.1:8001
```

**Weird characters when running `sort.py`**
Fixed — `sort.py` now forces UTF-8 on all platforms. Always run it via
the venv Python (`.\.venv\Scripts\python sort.py`).

**`docs\index.md` shows up in `git status`?**
It shouldn't — it's in `.gitignore`. If it does, run:
`git rm --cached docs\index.md`.

---

## What got installed, and where

| Item | Location |
|---|---|
| Virtual environment | `.venv\` (Python + pip, isolated from your system) |
| MkDocs + Material theme | inside `.venv\Lib\site-packages` |
| Preview content | `docs\index.md` (auto-copy of `README.md`, git-ignored) |
| Built website | `site\` (created by `mkdocs build`, git-ignored) |

To uninstall everything, just delete the `.venv\` and `site\` folders —
your system Python is untouched.
