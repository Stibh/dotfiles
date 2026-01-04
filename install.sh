#!/bin/bash
set -e

echo "Installing SbarLua..."
rm -rf /tmp/SbarLua
git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
cd /tmp/SbarLua
make install
cd -
rm -rf /tmp/SbarLua

echo "Building event providers..."
cd ~/.config/sketchybar/helpers
make

echo "✓ Done. Run: sketchybar --reload"
