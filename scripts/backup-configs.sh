#!/bin/bash

# Script para fazer backup de configurações principais
# Uso: bash scripts/backup-configs.sh

echo "💾 Fazendo backup de configurações..."
echo ""

# Criar timestamp para backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup de dotfiles
echo "📝 Fazendo backup de dotfiles..."

# Lista de dotfiles a fazer backup
DOTFILES=(
    ".bashrc"
    ".bash_profile"
    ".zshrc"
    ".zsh_profile"
    ".profile"
    ".aliases"
    ".bash_aliases"
    ".tmux.conf"
    ".dircolors"
)

for dotfile in "${DOTFILES[@]}"; do
    if [[ -f "$HOME/$dotfile" ]]; then
        cp "$HOME/$dotfile" "dotfiles/$dotfile" 2>/dev/null && \
            echo "  ✓ $dotfile"
    fi
done

# Backup de configurações de aplicações comuns
echo ""
echo "⚙️  Fazendo backup de configurações de aplicações..."

CONFIG_APPS=(
    "alacritty"
    "kitty"
    "nvim"
    "neovim"
    "vim"
    "tmux"
    "fish"
    "zsh"
    "dunst"
    "polybar"
    "i3"
    "sway"
    "foot"
    "transmission-daemon"
)

for app in "${CONFIG_APPS[@]}"; do
    if [[ -d "$HOME/.config/$app" ]]; then
        mkdir -p "configs/$app"
        cp -r "$HOME/.config/$app"/* "configs/$app/" 2>/dev/null && \
            echo "  ✓ $app"
    fi
done

# Backup de configurações locais específicas
echo ""
echo "🔧 Criando arquivo de configuração local..."
{
    echo "# Local Configuration Backup - $TIMESTAMP"
    echo ""
    echo "# Hostname"
    echo "HOSTNAME=$(hostname)"
    echo ""
    echo "# Usuário"
    echo "USERNAME=$USER"
    echo ""
    echo "# Shell"
    echo "SHELL=$SHELL"
    echo ""
    echo "# Desktop Environment"
    echo "DESKTOP_SESSION=${DESKTOP_SESSION:-none}"
    echo ""
} > "configs/system-config.env"

echo "✓ Configurações locais salvas"

echo ""
echo "✨ Backup concluído!"
echo ""
echo "Próximas ações:"
echo "1. Revise os arquivos em dotfiles/ e configs/"
echo "2. git add ."
echo "3. git commit -m 'Backup of configurations - $TIMESTAMP'"
echo "4. git push"
