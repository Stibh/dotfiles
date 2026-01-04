# macOS Dotfiles

A comprehensive macOS development environment managed with [chezmoi](https://www.chezmoi.io/), featuring a custom sketchybar configuration, AeroSpace window management, and a modern terminal setup.

## Features

- **🎨 Custom Status Bar**: Sketchybar with Lua configuration, custom C event providers for CPU/memory/network monitoring
- **🪟 Window Management**: AeroSpace tiling window manager with workspace integration
- **⌨️ Terminal Setup**: Tmux with Dracula theme, oh-my-zsh, and custom aliases
- **✏️ Editor**: Neovim with Kickstart.nvim configuration
- **🔤 Custom Fonts**: FiraCode Nerd Font, SF Symbols, and sketchybar-app-font
- **📦 Modern CLI Tools**: eza (ls replacement), fastfetch, fzf, and more

## Screenshots

The setup includes:
- Custom sketchybar with workspaces, app icons, CPU/memory/network graphs, volume, WiFi, and media controls
- AeroSpace integration for workspace switching
- Dracula-themed tmux with powerline status
- Transparent Neovim with modern plugin setup

## Fresh Installation

On a fresh macOS installation:

```bash
# Install chezmoi
brew install chezmoi

# Apply dotfiles
chezmoi init --apply <your-repo-url>

# Run install script (installs SbarLua and builds event providers)
~/.local/share/chezmoi/install.sh
```

That's it.

### Post-Installation Steps

After the bootstrap script completes:

1. **Restart your terminal** or source your new configuration:
   ```bash
   source ~/.zshrc
   ```

2. **Install tmux plugins**:
   - Open tmux: `tmux`
   - Press `Ctrl+a` then `Shift+i` to install plugins
   - Wait for installation to complete

3. **Start AeroSpace**:
   - Log out and log back in (AeroSpace will auto-start)
   - Or manually start: `open -a AeroSpace`

4. **Verify sketchybar**:
   - Check your menu bar for the custom status bar
   - If not visible, run: `sketchybar`

## Manual Installation

If you prefer to install step-by-step or the bootstrap script fails:

### 1. Install Prerequisites

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Core Tools

```bash
# Install chezmoi
brew install chezmoi

# Install core dependencies
brew install lua neovim tmux fzf eza fastfetch
```

### 3. Install Sketchybar

```bash
# Install sketchybar and dependencies
brew tap FelixKratz/formulae
brew install sketchybar switchaudio-osx nowplaying-cli

# Install SbarLua (Lua bindings)
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua && make install && cd -
rm -rf /tmp/SbarLua
```

### 4. Install Fonts

```bash
# Tap fonts repository
brew tap homebrew/cask-fonts

# Install Nerd Fonts
brew install --cask font-fira-code-nerd-font

# Install SF fonts
brew install --cask sf-symbols font-sf-mono font-sf-pro

# Download sketchybar-app-font
mkdir -p ~/Library/Fonts
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf
```

### 5. Install Window Manager

```bash
# Install AeroSpace
brew install --cask nikitabobko/tap/aerospace

# Install borders (for window highlighting)
brew tap FelixKratz/formulae
brew install borders
```

### 6. Apply Dotfiles

```bash
# Initialize chezmoi with this repository
chezmoi init --apply ~/dotfiles

# Or from a Git URL
chezmoi init --apply <your-repo-url>
```

### 7. Build Sketchybar Event Providers

```bash
# Build C event providers
cd ~/.config/sketchybar/helpers
make
```

### 8. Install oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 9. Install Tmux Plugin Manager

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Troubleshooting

### "lua: no such file or directory" error

This error occurs when SbarLua is not installed. Fix:

```bash
# Install SbarLua
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua && make install && cd -
rm -rf /tmp/SbarLua

# Reload sketchybar
sketchybar --reload
```

### Sketchybar not showing icons

Make sure all fonts are installed:

```bash
# Check if fonts are installed
ls ~/Library/Fonts/sketchybar-app-font.ttf

# If missing, download it
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf

# Reload sketchybar
sketchybar --reload
```

### Event providers not working (CPU/memory/network graphs not showing)

Build the C event providers:

```bash
cd ~/.config/sketchybar/helpers
make

# Reload sketchybar
sketchybar --reload
```

### eza not showing icons

Make sure FiraCode Nerd Font is installed:

```bash
brew install --cask font-fira-code-nerd-font

# Restart your terminal
```

### Tmux plugins not loading

Install plugins manually:

```bash
# Open tmux
tmux

# Press Ctrl+a then Shift+i to install plugins
# (Ctrl+a is the prefix, then press Shift+i)
```

## Updating

### Update dotfiles

```bash
# Pull latest changes
cd ~/dotfiles
git pull

# Apply updates
chezmoi apply
```

### Update packages

```bash
# Update Homebrew packages
brew update && brew upgrade

# Update oh-my-zsh
omz update
```

## Configuration

### Sketchybar

Configuration files are in `~/.config/sketchybar/`:
- `sketchybarrc` - Main entry point
- `init.lua` - Lua configuration
- `settings.lua` - Font and color settings
- `items/` - Individual widgets
- `helpers/` - C event providers and app icons

Reload after changes:
```bash
sketchybar --reload
```

### AeroSpace

Configuration: `~/.config/aerospace/aerospace.toml`

Restart after changes:
```bash
aerospace reload-config
```

### Tmux

Configuration: `~/.config/tmux/tmux.conf`

Reload after changes:
```bash
tmux source ~/.config/tmux/tmux.conf
```

### Neovim

Configuration: `~/.config/nvim/`

Kickstart.nvim-based setup with Lua plugins.

## Included Tools

### Aliases

```bash
# Editor
vi, vim → nvim

# File listing with icons
l    → eza with icons and colors
ll   → eza long format with git status
la   → eza with hidden files
lla  → eza long format with hidden files

# System info
ff   → fastfetch

# Tmux session manager
tmx  → Custom tmux session picker with fzf
```

### Tmux Key Bindings

- **Prefix**: `Ctrl+a` (instead of default `Ctrl+b`)
- **Split vertical**: `Prefix + |`
- **Split horizontal**: `Prefix + -`
- **Install plugins**: `Prefix + Shift+i`

## Dependencies

### Required

- macOS (this setup is macOS-specific)
- Xcode Command Line Tools
- Homebrew

### Installed by Bootstrap

- lua
- neovim
- tmux
- fzf
- eza
- fastfetch
- sketchybar
- SbarLua
- AeroSpace
- borders
- switchaudio-osx
- nowplaying-cli
- oh-my-zsh
- tmux plugin manager (TPM)

### Fonts

- FiraCode Nerd Font Mono
- SF Symbols
- SF Mono
- SF Pro
- sketchybar-app-font

## Structure

```
~/dotfiles/
├── bootstrap.sh              # Fresh installation script
├── dot_config/
│   ├── sketchybar/           # Status bar configuration
│   │   ├── sketchybarrc      # Main entry point
│   │   ├── init.lua          # Lua configuration
│   │   ├── settings.lua      # Settings and fonts
│   │   ├── items/            # Widgets
│   │   └── helpers/          # C event providers
│   ├── nvim/                 # Neovim configuration
│   ├── tmux/                 # Tmux configuration
│   ├── aerospace/            # Window manager config
│   └── fastfetch/            # System info config
├── dot_zshrc                 # Shell configuration
└── bin/                      # Custom scripts
```

## Credits

- [chezmoi](https://www.chezmoi.io/) - Dotfile manager
- [sketchybar](https://github.com/FelixKratz/SketchyBar) - Custom status bar
- [SbarLua](https://github.com/FelixKratz/SbarLua) - Lua bindings for sketchybar
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) - Tiling window manager
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Neovim configuration
- [oh-my-zsh](https://ohmyz.sh/) - Zsh framework
- [Dracula Theme](https://draculatheme.com/) - Color scheme

## License

Personal dotfiles - use at your own risk and customize to your needs!
