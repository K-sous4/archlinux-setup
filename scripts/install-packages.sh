#!/bin/bash

# Script para instalar packages salvos
# Funciona com: Arch Linux, Manjaro
# Uso: bash scripts/install-packages.sh

set -e

# ====================================
# INICIALIZAR LOGGING
# ====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_logging.sh" 2>/dev/null || true

log "INFO" "═══════════════════════════════════════════════════════════"
log "INFO" "INICIANDO: install-packages.sh"
log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "═══════════════════════════════════════════════════════════"

echo "🚀 Iniciando instalação de packages..."
echo ""
log "INFO" "Iniciando instalação de packages"

# Detectar distribuição
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO="$ID"
else
    DISTRO="unknown"
fi

echo "📍 Distribuição: $DISTRO"
echo ""

# Verificar se tem acesso de root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Este script precisa ser executado com sudo"
   echo "Uso: sudo bash scripts/install-packages.sh"
   exit 1
fi

# Verificar se os arquivos de packages existem
if [[ ! -f "packages/pacman-packages.txt" ]]; then
    echo "❌ Arquivo packages/pacman-packages.txt não encontrado!"
    echo "Execute primeiro: bash scripts/export-packages.sh"
    exit 1
fi

# Atualizar sistema
echo "🔄 Atualizando sistema..."
pacman -Syu --noconfirm

# Instalar pacman packages
if [[ -s "packages/pacman-packages.txt" ]]; then
    echo ""
    echo "📦 Instalando pacman packages..."
    pacman -S --noconfirm $(cat packages/pacman-packages.txt | tr '\n' ' ')
    echo "✓ Pacman packages instalados"
fi

# Instalar AUR packages (precisa de yay ou paru)
if [[ -s "packages/aur-packages.txt" ]]; then
    echo ""
    if command -v yay &> /dev/null; then
        echo "🗂️  Instalando AUR packages com yay..."
        yay -S --noconfirm $(cat packages/aur-packages.txt | tr '\n' ' ')
        echo "✓ AUR packages instalados"
    elif command -v paru &> /dev/null; then
        echo "🗂️  Instalando AUR packages com paru..."
        paru -S --noconfirm $(cat packages/aur-packages.txt | tr '\n' ' ')
        echo "✓ AUR packages instalados"
    else
        echo "⚠️  Nenhum AUR helper encontrado (yay/paru)"
        echo "   Para usar este recurso, instale yay: git clone https://aur.archlinux.org/yay-bin.git"
    fi
fi

# Instalar pip packages
if [[ -s "packages/pip-packages.txt" ]]; then
    echo ""
    if command -v pip &> /dev/null; then
        echo "🐍 Instalando pip packages..."
        pip install -r packages/pip-packages.txt
        echo "✓ Pip packages instalados"
    else
        echo "⚠️  pip não encontrado"
    fi
fi

# Instalar npm packages
if [[ -s "packages/npm-packages.txt" ]]; then
    echo ""
    if command -v npm &> /dev/null; then
        echo "📚 Instalando npm packages..."
        while IFS= read -r package; do
            npm install -g "$package"
        done < packages/npm-packages.txt
        echo "✓ Npm packages instalados"
    else
        echo "⚠️  npm não encontrado"
    fi
fi

echo ""
echo "✨ Instalação concluída!"
