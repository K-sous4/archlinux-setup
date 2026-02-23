#!/bin/bash

# Script para debloat do Manjaro
# Remove aplicações pré-instaladas desnecessárias
# Uso: bash scripts/debloat-manjaro.sh

set -e

echo "🧹 Debloat Manjaro - Removendo bloatware..."
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_removing() {
    echo -e "${YELLOW}Removendo:${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1 removido"
}

# Verificar se é root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Este script precisa ser executado com sudo"
   echo "Uso: sudo bash scripts/debloat-manjaro.sh"
   exit 1
fi

# ====================================
# APLICAÇÕES DE BLOATWARE COMUNS
# ====================================

BLOATWARE=(
    "thunderbird"           # Cliente de email pesado
    "audacious"             # Player de áudio desnecessário
    "bluedevil"             # Bluetooth (removível se não usar)
    "kde-connect"           # KDE Connect (removível)
    "ksysguard"             # Monitor de sistema duplicado
    "kscreensaver"          # Screensaver desnecessário
    "kmix"                  # Mixer de áudio duplicado
    "kwallet"               # Gerenciador de senhas (opcional)
    "kdeplasma-addons"      # Addons extras do Plasma (opcional)
    "plasmoidviewer"        # Viewer de widgets (dev tool)
    "konquerer"             # Navegador de arquivo antigo
    "kmail"                 # Cliente de email (alternativa ao Thunderbird)
    "kontact"               # Groupware pesado
    "krfb"                  # Desktop sharing (opcional)
    "krdc"                  # Remote desktop (opcional)
    "kcalc"                 # Calculadora (pode usar gnome-calc)
)

# ====================================
# REMOVER BLOATWARE
# ====================================

echo "Removendo aplicações desnecessárias..."
echo ""

for app in "${BLOATWARE[@]}"; do
    if pacman -Q "$app" &> /dev/null; then
        print_removing "$app"
        pacman -R --noconfirm "$app" 2>/dev/null || true
        print_success "$app"
    fi
done

# ====================================
# LIMPEZA
# ====================================

echo ""
echo "🧹 Limpando cache..."

# Remover caches órfãs
pacman -Scc --noconfirm || true

# Remover dependências órfãs
ORPHANS=$(pacman -Qdtq)
if [[ -n "$ORPHANS" ]]; then
    echo "$ORPHANS" | pacman -R --cascade --noconfirm - 2>/dev/null || true
    echo "✓ Dependências órfãs removidas"
fi

# ====================================
# OTIMIZAÇÕES OPCIONAIS
# ====================================

echo ""
echo "⚙️  Otimizações:"

# Desabilitar alguns serviços por padrão (opcional)
echo "Serviços que podem ser desabilitados (opcional):"
echo "  sudo systemctl disable bluetooth.service  # Se não usar Bluetooth"
echo "  sudo systemctl disable sddm-plymouth.service  # Se não quiser animação de login"
echo ""

# ====================================
# FINALIZAÇÃO
# ====================================

echo "✨ Debloat Manjaro concluído!"
echo ""
echo "Aplicações removidas: ${#BLOATWARE[@]}"
echo ""
echo "Dica: Para remover mais aplicações, edite este script"
echo "      e adicione novos nomes na array BLOATWARE"
