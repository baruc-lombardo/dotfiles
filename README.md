# dotfiles

Portable Windows setup for Pi, Codex, and Claude Code.

## New machine

```powershell
git clone https://github.com/baruc-lombardo/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
Set-ExecutionPolicy -Scope Process Bypass
.\bootstrap.ps1
```

The bootstrap installs missing Pi, Codex, and Claude Code CLIs, then links the shared guidance file into each tool. Existing guidance files are preserved unless you use `-Force`.

Sign in to each tool separately. Credentials, API keys, sessions, histories, and caches are intentionally not stored in this repository.
