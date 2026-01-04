# macOS Dotfiles

Personal macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Sketchybar**: Custom status bar with Lua configuration
- **AeroSpace**: Tiling window manager
- **Neovim**: Text editor configuration
- **Tmux**: Terminal multiplexer with Dracula theme
- **Zsh**: Shell with oh-my-zsh
- **Modern CLI tools**: eza, fzf, fastfetch

## Fresh Installation

On a fresh macOS machine:

```bash
# Install chezmoi
brew install chezmoi

# Initialize and apply dotfiles (installs everything automatically)
chezmoi init --apply https://github.com/yourusername/dotfiles.git
```

That's it. Chezmoi will automatically:
- Install all required packages (lua, neovim, tmux, etc.)
- Install all fonts (FiraCode Nerd Font, SF Symbols, etc.)
- Install sketchybar and SbarLua
- Build event providers
- Apply all configuration files

## What Gets Installed

**Packages:**
- lua, neovim, tmux, fzf, eza, fastfetch
- switchaudio-osx, nowplaying-cli
- sketchybar, borders (from FelixKratz/formulae)
- AeroSpace (window manager)

**Fonts:**
- FiraCode Nerd Font
- SF Symbols, SF Mono, SF Pro
- sketchybar-app-font

**Built from source:**
- SbarLua (Lua bindings for sketchybar)
- Sketchybar event providers (CPU, memory, network monitors)

## Post-Installation

```bash
# Restart terminal
exec zsh

# Install tmux plugins (open tmux, press Ctrl+a then Shift+i)
tmux

# Log out and back in to start AeroSpace
```

## Updating

```bash
# Pull latest changes and apply
chezmoi update
```

## Manual Installation

If you prefer to install dependencies manually:

```bash
brew install chezmoi lua neovim tmux fzf eza fastfetch switchaudio-osx nowplaying-cli
brew tap FelixKratz/formulae && brew install sketchybar borders
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font sf-symbols font-sf-mono font-sf-pro nikitabobko/tap/aerospace
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o ~/Library/Fonts/sketchybar-app-font.ttf
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua && make install && rm -rf /tmp/SbarLua

chezmoi init --apply <repo-url>
cd ~/.config/sketchybar/helpers && make
```

## Troubleshooting

**"lua: no such file or directory"**
- SbarLua isn't installed. Run: `~/.config/sketchybar/helpers/install`

**Icons not showing**
- Fonts not installed. Run: `brew install --cask font-fira-code-nerd-font sf-symbols`
- Download sketchybar-app-font manually

**Event providers not working**
- Build them: `cd ~/.config/sketchybar/helpers && make`

## Configuration

- Sketchybar: `~/.config/sketchybar/`
- Neovim: `~/.config/nvim/`
- Tmux: `~/.config/tmux/`
- AeroSpace: `~/.config/aerospace/`
- Zsh: `~/.zshrc`

## Aliases

```bash
vi, vim    → nvim
l, ll, la  → eza with icons
ff         → fastfetch
tmx        → tmux session picker
```

## Tmux Prefix

Prefix is `Ctrl+a` (not default `Ctrl+b`)
