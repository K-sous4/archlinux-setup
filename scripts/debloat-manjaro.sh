#!/bin/bash

# Script para debloat do Manjaro
# Remove aplicações pré-instaladas desnecessárias
# Uso: bash scripts/debloat-manjaro.sh
# 
# NOTA: Este script remove GNOME games e aplicações comuns de bloatware.
#       Se você usa alguma delas, comente a linha correspondente antes de executar!

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
    # Email & Communication
    "thunderbird"           # Cliente de email pesado
    "kmail"                 # Cliente de email (alternativa ao Thunderbird)
    "kontact"               # Groupware pesado
    "krfb"                  # Desktop sharing (opcional)
    "krdc"                  # Remote desktop (opcional)
    
    # Audio & Media
    "audacious"             # Player de áudio desnecessário
    "kmix"                  # Mixer de áudio duplicado
    
    # Desktop Environment Specific
    "bluedevil"             # Bluetooth (removível se não usar)
    "kde-connect"           # KDE Connect (removível)
    "ksysguard"             # Monitor de sistema duplicado
    "kscreensaver"          # Screensaver desnecessário
    "kwallet"               # Gerenciador de senhas (opcional)
    "kdeplasma-addons"      # Addons extras do Plasma (opcional)
    "plasmoidviewer"        # Viewer de widgets (dev tool)
    "konquerer"             # Navegador de arquivo antigo
    
    # GNOME Games (bloatware comum)
    "gnome-chess"           # Jogo de xadrez do GNOME
    "gnome-mines"           # Jogo Minas do GNOME
    "gnome-sudoku"          # Jogo Sudoku do GNOME
    "gnome-2048"            # Jogo 2048 do GNOME
    "gnome-taquin"          # Jogo de blocos Taquin do GNOME
    "quadrapassel"          # Jogo Tetris-like do GNOME
    "solitaire"             # Jogo de paciência do GNOME
    "gnome-mahjongg"        # Jogo Mahjongg do GNOME
    "gnome-klotski"         # Jogo de deslizar blocos
    "gnome-tetravex"        # Jogo de quebra-cabeça
    "iagno"                 # Jogo Othello/Reversi do GNOME
    "five-or-more"          # Jogo Five or More do GNOME
    
    # GNOME Utilities & Apps
    "evolution"             # Client de email GNOME (se não usa)
    "evolution-data-server" # Backend Evolution (se não usa)
    "gnome-maps"            # Mapas do GNOME (se não precisa)
    "gnome-music"           # Player de músic GNOME (pode usar alternativa)
    "gnome-weather"         # Aplicativo de clima GNOME
    "gnome-calendar"        # Calendário GNOME (se não usa)
    "gnome-clocks"          # Relógios/alarmes GNOME
    "gnome-contacts"        # Contatos GNOME (se não usa)
    "totem"                 # Player de vídeo GNOME (pode usar VLC)
    "yelp"                  # Help viewer GNOME
    "gnome-books"           # Leitor de e-books
    "gnome-documents"       # Visualizador de documentos
    "paper"                 # Document Viewer (antigo)
    "gnome-tour"            # Tour inicial do GNOME
    
    # Calculadora (pode usar alternativa)
    "kcalc"                 # Calculadora KDE
    # "gnome-calculator"    # Decomenta se não quiser calculadora
    
    # Outras utilidades opcionais
    "articulator"           # Teste de entrada de áudio
    "libsodium"             # Pode ser removido se não usa apps que precisam
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
echo ""
echo "📝 Customizando bloatware:"
echo "  Se você usa alguma das aplicações removidas:"
echo "  1. Edite este arquivo: nano scripts/debloat-manjaro.sh"
echo "  2. Comente (#) a linha da aplicação que quer manter"
echo "  3. Execute novamente"
echo ""

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
