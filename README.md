# pwshellexe

A simple PowerShell utility to convert `.ps1` scripts to standalone `.exe` files with a modern GUI. No admin rights required.

---

## ✨ Features

- **Modern, user-friendly GUI** for converting PowerShell scripts to EXE
- **No admin rights required**
- **Auto-updates** from GitHub
- **Portable** – run as EXE or script
- **Open Source** – MIT licensed

---

## 🛠️ Quick Start

**Run directly from PowerShell (no install needed):**

```powershell
iwr https://raw.githubusercontent.com/DevAesthetic/pwshellexe/main/pwshellexe.ps1 -UseBasicParsing | iex
```

---

## 📦 Installation (Recommended)

**Install globally with one command:**

```powershell
iwr https://raw.githubusercontent.com/DevAesthetic/pwshellexe/main/install.ps1 -UseBasicParsing | iex
```

After install, you can use the command from any terminal:

```powershell
pwshellexe run
```

---

## 📚 How it works

- On first run, downloads the latest `pwshellexe.ps1` from this repo.
- Launches a modern GUI for converting `.ps1` scripts to `.exe`.
- No elevation or admin prompts—works for all users.


**Enjoy converting your PowerShell scripts to EXEs with ease!**
