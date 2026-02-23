#!/bin/bash

# Auto Setup - Script automático executado após clonar o repositório
# Uso: bash auto-setup.sh
# Ou: chmod +x auto-setup.sh && ./auto-setup.sh

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "\n${PURPLE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} $1"
    echo -e "${PURPLE}╚════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ====================================
# INÍCIO
# ====================================

print_header "🔧 ARCH LINUX / MANJARO - AUTO SETUP CONFIGURAÇÃO"

echo -e "${YELLOW}Este script irá:${NC}"
echo "  → Detectar distribuição (Arch/Manjaro)"
echo "  → Remover bloatware (se Manjaro)"
echo "  → Instalar e configurar Alacritty"
echo "  → Instalar e configurar Zsh + Powerlevel10k"
echo "  → Instalar ferramentas recomendadas"
echo "  → Aplicar configurações do repositório"
echo ""

read -p "Continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    print_warning "Cancelado"
    exit 0
fi

# ====================================
# DETECTAR DISTRIBUIÇÃO
# ====================================

print_header "📍 Detectando Distribuição"

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS="$ID"
    OS_PRETTY="$PRETTY_NAME"
else
    print_error "Não foi possível detectar distribuição"
    exit 1
fi

print_info "Distribuição: $OS_PRETTY"

if [[ "$OS" == "manjaro" ]]; then
    IS_MANJARO=true
    print_success "Manjaro detectado"
elif [[ "$OS" == "arch" ]]; then
    IS_MANJARO=false
    print_success "Arch Linux detectado"
else
    print_warning "Distribuição desconhecida: $OS"
    print_warning "Tentando continuar..."
fi

# ====================================
# DEBLOAT MANJARO (se aplicável)
# ====================================

if [[ $IS_MANJARO == true ]]; then
    print_header "🧹 Removendo Bloatware do Manjaro"
    
    read -p "Deseja remover aplicações pré-instaladas desnecessárias? (s/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        if [[ -f "scripts/debloat-manjaro.sh" ]]; then
            bash scripts/debloat-manjaro.sh
            print_success "Debloat concluído"
        else
            print_warning "Script debloat não encontrado"
        fi
    fi
fi

# ====================================
# ATUALIZAR SISTEMA
# ====================================

print_header "🔄 Atualizando Sistema"

sudo pacman -Syu --noconfirm
print_success "Sistema atualizado"

# ====================================
# INSTALAR TERMINAL (ALACRITTY + ZSH + POWERLEVEL10K)
# ====================================

print_header "🖥️ Configurando Terminal"

if [[ -f "scripts/install-terminal.sh" ]]; then
    bash scripts/install-terminal.sh
    print_success "Terminal configurado"
else
    print_warning "Script install-terminal.sh não encontrado"
    print_info "Execute manualmente: bash scripts/install-terminal.sh"
fi

# ====================================
# INSTALAR PACKAGES
# ====================================

print_header "📦 Instalando Packages"

# Primeiro, esportar se não tiver
if [[ ! -f "packages/pacman-packages.txt" ]]; then
    print_warning "Arquivos de packages não encontrados"
    print_info "Executando export-packages.sh..."
    
    bash scripts/export-packages.sh
else
    read -p "Deseja reinstalar packages do repositório? (s/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        sudo bash scripts/install-packages.sh
        print_success "Packages instalados"
    fi
fi

# ====================================
# RESTAURAR CONFIGURAÇÕES
# ====================================

print_header "⚙️ Aplicando Configurações"

bash scripts/setup.sh <<< "1"

# ====================================
# FINALIZAÇÃO
# ====================================

print_header "✨ Setup Completo!"

echo -e "${GREEN}Próximos passos:${NC}"
echo "  1. Verifique se o Alacritty está configurado corretamente"
echo "  2. Customize Powerlevel10k: ${BLUE}p10k configure${NC}"
echo "  3. Recarregue o shell: ${BLUE}exec zsh${NC}"
echo "  4. Instale Nerd Font para melhor visualização (opcional)"
echo ""
echo -e "${YELLOW}Dicas:${NC}"
echo "  • Para exportar suas configs: ${BLUE}bash makefile.sh export${NC}"
echo "  • Para sincronizar: ${BLUE}bash makefile.sh commit${NC}"
echo "  • Para ver status: ${BLUE}bash makefile.sh status${NC}"
echo ""

print_success "Tudo pronto! 🚀"
