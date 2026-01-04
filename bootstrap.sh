#!/bin/bash

# Dotfiles Bootstrap Script for Fresh macOS Installation
# This script installs all dependencies and sets up the dotfiles using chezmoi

set -e  # Exit on error

echo "🚀 Starting dotfiles bootstrap for fresh macOS installation..."
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only!"
    exit 1
fi

# Step 1: Install Xcode Command Line Tools
print_step "Installing Xcode Command Line Tools (required for building C programs)..."
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    echo "Please complete the Xcode Command Line Tools installation dialog."
    echo "Press any key after installation is complete..."
    read -n 1 -s
else
    echo "   ✓ Xcode Command Line Tools already installed"
fi

# Step 2: Install Homebrew
print_step "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "   ✓ Homebrew already installed"
fi

# Step 3: Install chezmoi
print_step "Installing chezmoi..."
if ! command -v chezmoi &>/dev/null; then
    brew install chezmoi
else
    echo "   ✓ chezmoi already installed"
fi

# Step 4: Install core dependencies
print_step "Installing core dependencies..."
brew install lua
brew install neovim
brew install tmux
brew install fzf
brew install eza
brew install fastfetch

# Step 5: Install oh-my-zsh
print_step "Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "   ✓ oh-my-zsh already installed"
fi

# Step 6: Install sketchybar and dependencies
print_step "Installing sketchybar and dependencies..."
brew tap FelixKratz/formulae
brew install sketchybar
brew install switchaudio-osx
brew install nowplaying-cli

# Step 7: Install AeroSpace window manager
print_step "Installing AeroSpace window manager..."
brew install --cask nikitabobko/tap/aerospace

# Step 8: Install borders (for AeroSpace integration)
print_step "Installing borders..."
if ! command -v borders &>/dev/null; then
    brew tap FelixKratz/formulae
    brew install borders
else
    echo "   ✓ borders already installed"
fi

# Step 9: Install fonts
print_step "Installing fonts..."

# Install Nerd Fonts tap
brew tap homebrew/cask-fonts

# Install FiraCode Nerd Font
brew install --cask font-fira-code-nerd-font

# Install SF Symbols, SF Mono, SF Pro
brew install --cask sf-symbols
brew install --cask font-sf-mono
brew install --cask font-sf-pro

# Download sketchybar-app-font
print_step "Downloading sketchybar-app-font..."
mkdir -p "$HOME/Library/Fonts"
if [ ! -f "$HOME/Library/Fonts/sketchybar-app-font.ttf" ]; then
    curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o "$HOME/Library/Fonts/sketchybar-app-font.ttf"
    echo "   ✓ sketchybar-app-font downloaded"
else
    echo "   ✓ sketchybar-app-font already installed"
fi

# Step 10: Install SbarLua (Lua bindings for sketchybar)
print_step "Installing SbarLua (Lua bindings for sketchybar)..."
if [ ! -d "$HOME/.local/share/sketchybar_lua" ]; then
    git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
    cd /tmp/SbarLua/
    make install
    cd -
    rm -rf /tmp/SbarLua/
    echo "   ✓ SbarLua installed"
else
    echo "   ✓ SbarLua already installed"
fi

# Step 11: Apply dotfiles with chezmoi
print_step "Initializing chezmoi with your dotfiles..."
echo ""
echo "This will apply your dotfiles from this repository."
echo "If you cloned this repo, we'll initialize chezmoi from the current directory."
echo ""

# Determine source directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d "$DOTFILES_DIR/.git" ]; then
    print_step "Initializing chezmoi from local repository..."
    chezmoi init --apply "$DOTFILES_DIR"
else
    print_warning "Not a git repository. Please provide your dotfiles repository URL:"
    read -p "Repository URL: " REPO_URL
    chezmoi init --apply "$REPO_URL"
fi

# Step 12: Build sketchybar C event providers
print_step "Building sketchybar C event providers..."
SKETCHYBAR_HELPERS="$HOME/.config/sketchybar/helpers"
if [ -d "$SKETCHYBAR_HELPERS" ]; then
    cd "$SKETCHYBAR_HELPERS"
    if [ -f "makefile" ]; then
        make
        echo "   ✓ Event providers compiled"
    else
        print_warning "makefile not found in $SKETCHYBAR_HELPERS"
    fi
    cd -
else
    print_warning "Sketchybar helpers directory not found at $SKETCHYBAR_HELPERS"
fi

# Step 13: Install tmux plugin manager (TPM)
print_step "Installing tmux plugin manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "   ✓ TPM installed"
    echo "   NOTE: Open tmux and press 'prefix + I' (Ctrl+a then Shift+i) to install plugins"
else
    echo "   ✓ TPM already installed"
fi

# Step 14: Start services
print_step "Starting services..."

# Start sketchybar
if command -v sketchybar &>/dev/null; then
    sketchybar --reload
    echo "   ✓ sketchybar started"
fi

# Start AeroSpace (if not running)
if command -v aerospace &>/dev/null; then
    # AeroSpace will auto-start on next login
    echo "   ✓ AeroSpace installed (will start on next login)"
fi

# Final steps
echo ""
echo -e "${GREEN}✨ Bootstrap complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open tmux and press 'Ctrl+a' then 'Shift+i' to install tmux plugins"
echo "  3. Log out and log back in to start AeroSpace window manager"
echo "  4. Verify sketchybar is running in your menu bar"
echo ""
echo "Installed tools:"
echo "  • chezmoi - Dotfile manager"
echo "  • neovim - Text editor (alias: vi, vim)"
echo "  • tmux - Terminal multiplexer"
echo "  • eza - Modern ls with icons"
echo "  • sketchybar - Status bar with Lua configuration"
echo "  • AeroSpace - Tiling window manager"
echo "  • fastfetch - System info (alias: ff)"
echo ""
echo "Run 'chezmoi update' to pull the latest dotfiles changes."
echo ""
