# Quick Start - Fresh macOS Installation with Chezmoi

This guide is for setting up your dotfiles on a **fresh macOS computer** using chezmoi.

## Prerequisites

You're on a fresh macOS installation and want to replicate your dotfiles setup.

## Two Installation Methods

### Method 1: Bootstrap Script (Recommended - Fully Automated)

This is the easiest method. It installs everything automatically.

```bash
# On your fresh Mac, clone this repository
git clone <your-repo-url> ~/dotfiles

# Run the bootstrap script
cd ~/dotfiles
./bootstrap.sh
```

**What it does:**
- ✅ Installs Xcode Command Line Tools
- ✅ Installs Homebrew
- ✅ Installs chezmoi
- ✅ Installs all dependencies (lua, fonts, sketchybar, etc.)
- ✅ Applies your dotfiles with chezmoi
- ✅ Builds C event providers for sketchybar
- ✅ Sets up everything ready to use

**After bootstrap completes:**
```bash
# Restart terminal or source zsh
source ~/.zshrc

# Open tmux and install plugins (Ctrl+a then Shift+i)
tmux

# Log out and back in to start AeroSpace
```

### Method 2: Direct Chezmoi Init (For Advanced Users)

If you want chezmoi to manage everything from the start:

```bash
# Install Homebrew first (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi
brew install chezmoi

# Initialize and apply dotfiles in one command
chezmoi init --apply <your-repo-url>

# OR if you already cloned the repo:
chezmoi init --apply ~/dotfiles
```

**Then install dependencies manually:**
```bash
# Run the install script from within your applied config
~/.config/sketchybar/helpers/install

# Or run the bootstrap (it will skip already-applied dotfiles)
~/dotfiles/bootstrap.sh
```

## Understanding Chezmoi with This Repository

### How Files Are Named

This repository uses chezmoi's naming convention:

| Repository File | Applied Location |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_config/nvim/init.lua` | `~/.config/nvim/init.lua` |
| `executable_sketchybarrc` | `~/.config/sketchybar/sketchybarrc` (executable) |

- **`dot_`** prefix → hidden file (dotfile)
- **`executable_`** prefix → file is marked as executable

### Common Chezmoi Commands

```bash
# Apply latest changes from source
chezmoi apply

# See what would change (dry run)
chezmoi apply --dry-run --verbose

# Edit a file in your chezmoi source directory
chezmoi edit ~/.zshrc

# Add a new file to chezmoi
chezmoi add ~/.config/new-tool/config.yml

# Update from git and apply
cd ~/dotfiles
git pull
chezmoi apply

# Re-apply all dotfiles
chezmoi apply --force

# See differences between source and destination
chezmoi diff
```

## Fixing the "lua: no such file or directory" Error

This error means SbarLua (Lua bindings for sketchybar) is not installed.

**Quick fix:**

```bash
# Install SbarLua
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua
make install
cd -
rm -rf /tmp/SbarLua

# Reload sketchybar
sketchybar --reload
```

**Or run the bootstrap script** which handles this automatically.

## Missing Fonts/Icons?

If eza or sketchybar aren't showing icons:

```bash
# Install all required fonts
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask sf-symbols font-sf-mono font-sf-pro

# Download sketchybar-app-font
mkdir -p ~/Library/Fonts
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf

# Restart terminal
```

## Workflow: Making Changes to Your Dotfiles

### On Your First Computer (Where You Set It Up)

```bash
# Edit files directly in the chezmoi source directory
cd ~/dotfiles

# Make your changes to files (they use the dot_ and executable_ prefixes)
vim dot_zshrc

# Commit and push
git add .
git commit -m "Update zsh configuration"
git push
```

### On Your Second Computer (Fresh Install)

```bash
# Pull latest changes
cd ~/dotfiles
git pull

# Apply with chezmoi
chezmoi apply

# Or if you want to see what will change first:
chezmoi diff
chezmoi apply
```

## Syncing Between Computers

```bash
# On computer 1: Make changes and push
cd ~/dotfiles
vim dot_config/nvim/init.lua
git add .
git commit -m "Update neovim config"
git push

# On computer 2: Pull and apply
cd ~/dotfiles
git pull
chezmoi apply
```

## Why Bootstrap Script vs Manual Chezmoi Init?

**Bootstrap Script (`./bootstrap.sh`):**
- ✅ Installs ALL dependencies automatically
- ✅ Handles SbarLua installation (critical for sketchybar)
- ✅ Builds C event providers
- ✅ Installs fonts
- ✅ Best for first-time setup

**Manual Chezmoi Init:**
- ✅ More control over each step
- ✅ Follow chezmoi's standard workflow
- ⚠️ Must install dependencies separately

**Recommendation:** Use bootstrap script for fresh installs, then use chezmoi commands for daily updates.

## Directory Structure After Installation

```
~/.local/share/chezmoi/    # Chezmoi source (your dotfiles repo)
~/dotfiles/                # Your cloned repo (if using bootstrap)
~/.config/                 # Applied configuration files
~/.zshrc                   # Applied shell config
~/.local/share/sketchybar_lua/  # SbarLua installation
```

## Checklist for Fresh Install

- [ ] Run `./bootstrap.sh` or install Homebrew + chezmoi manually
- [ ] Verify sketchybar is running (check menu bar)
- [ ] Open tmux and install plugins (`Ctrl+a` then `Shift+i`)
- [ ] Check fonts are installed: `ls ~/Library/Fonts/sketchybar-app-font.ttf`
- [ ] Verify eza shows icons: `ll`
- [ ] Test neovim: `nvim`
- [ ] Log out and back in to start AeroSpace
- [ ] Run `ff` (fastfetch) to verify system info

## Still Having Issues?

### Sketchybar not starting

```bash
# Check if lua is installed
lua -v

# Check if SbarLua is installed
ls ~/.local/share/sketchybar_lua/

# Try starting manually
sketchybar

# Check logs
log show --predicate 'process == "sketchybar"' --last 5m
```

### Event providers not working

```bash
# Build event providers
cd ~/.config/sketchybar/helpers
make

# Reload sketchybar
sketchybar --reload
```

### Chezmoi conflicts

```bash
# Force apply (overwrites destination files)
chezmoi apply --force

# Remove and re-apply everything
chezmoi purge
chezmoi init --apply ~/dotfiles
```

## Getting Help

1. Check the main [README.md](README.md) for detailed documentation
2. Review sketchybar logs: `log show --predicate 'process == "sketchybar"' --last 5m`
3. Verify dependencies: `brew list`
4. Check chezmoi status: `chezmoi doctor`

---

**Happy dotfile-ing!** 🚀
