#!/bin/bash

# Script para instalar e configurar Terminal moderno
# Instala: Alacritty, Zsh, Powerlevel10k
# Uso: bash scripts/install-terminal.sh

set -e

# ====================================
# INICIALIZAR LOGGING
# ====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_logging.sh"

# Log início do script
log "INFO" "═══════════════════════════════════════════════════════════"
log "INFO" "INICIANDO: install-terminal.sh"
log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "═══════════════════════════════════════════════════════════"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "\n${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${PURPLE}▶ $1${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    log "INFO" "▶ $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
    log "SUCCESS" "$1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    log "ERROR" "$1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    log "WARNING" "$1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
    log "INFO" "$1"
}

# ====================================
# VERIFICAÇÕES
# ====================================

if [[ $EUID -ne 0 ]]; then
   print_error "Este script precisa de sudo"
   echo "Uso: sudo bash scripts/install-terminal.sh"
   exit 1
fi

print_header "🖥️ INSTALAÇÃO DE TERMINAL MODERNO"

# ====================================
# INSTALAR ALACRITTY
# ====================================

print_header "Installation: Alacritty"

if command -v alacritty &> /dev/null; then
    print_warning "Alacritty já está instalado"
else
    print_info "Instalando Alacritty..."
    log "INFO" "INICIANDO: pacman -S alacritty"
    pacman -S --noconfirm alacritty 2>&1 | tee -a "$LOG_FILE"
    print_success "Alacritty instalado"
fi

# Copiar configuração se existir
if [[ -f "configs/alacritty/alacritty.yml" ]]; then
    print_info "Copiando configuração do Alacritty..."
    mkdir -p ~/.config/alacritty
    cp configs/alacritty/alacritty.yml ~/.config/alacritty/ 2>/dev/null || true
    print_success "Configuração do Alacritty copiada"
elif [[ ! -d ~/.config/alacritty ]]; then
    print_info "Criando configuração padrão do Alacritty..."
    mkdir -p ~/.config/alacritty
    cat > ~/.config/alacritty/alacritty.yml << 'EOF'
# Alacritty - GPU accelerated terminal emulator
# Configuração otimizada para desenvolvimento

colors:
  primary:
    background: '#1e1e2e'
    foreground: '#cdd6f4'
  cursor:
    text: '#1e1e2e'
    cursor: '#f5f5f5'
  normal:
    black:   '#45475a'
    red:     '#f38181'
    green:   '#a6e3a1'
    yellow:  '#f9e2af'
    blue:    '#89b4fa'
    magenta: '#f5c2e7'
    cyan:    '#89dceb'
    white:   '#bac2de'

font:
  normal:
    family: "JetBrains Mono"
    style: Regular
  size: 12.0

window:
  padding:
    x: 10
    y: 10
  opacity: 0.95

bell:
  animation: EaseOutExpo
  duration: 0

selection:
  save_to_clipboard: true
EOF
    print_success "Configuração padrão do Alacritty criada"
fi

# ====================================
# INSTALAR ZSH
# ====================================

print_header "Installation: Zsh + Oh My Zsh"

if command -v zsh &> /dev/null; then
    print_warning "Zsh já está instalado"
else
    print_info "Instalando Zsh..."
    log "INFO" "INICIANDO: pacman -S zsh"
    pacman -S --noconfirm zsh 2>&1 | tee -a "$LOG_FILE"
    print_success "Zsh instalado"
fi

# Instalar Oh My Zsh
if [[ -d ~/.oh-my-zsh ]]; then
    print_warning "Oh My Zsh já está instalado"
else
    print_info "Instalando Oh My Zsh..."
    log "INFO" "INICIANDO: git clone ohmyzsh repository"
    
    # Usar git para instalar
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh 2>&1 | tee -a "$LOG_FILE" || true
    
    # Copiar template padrão se não existir
    if [[ ! -f ~/.zshrc ]]; then
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    fi
    
    print_success "Oh My Zsh instalado"
fi

# ====================================
# INSTALAR POWERLEVEL10K
# ====================================

print_header "Installation: Powerlevel10k"

if [[ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    print_warning "Powerlevel10k já está instalado"
else
    print_info "Instalando Powerlevel10k..."
    log "INFO" "INICIANDO: instalação Powerlevel10k"
    
    if pacman -Q powerlevel10k &> /dev/null; then
        print_success "Powerlevel10k instalado (pacman)"
        log "SUCCESS" "Powerlevel10k encontrado no pacman"
    else
        # Instalar via git
        log "INFO" "INICIANDO: git clone powerlevel10k repository"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            ~/.oh-my-zsh/custom/themes/powerlevel10k 2>&1 | tee -a "$LOG_FILE"
        print_success "Powerlevel10k instalado (git)"
    fi
fi

# ====================================
# INSTALAR PLUGINS ZSH
# ====================================

print_header "Installation: Zsh Plugins"

# Syntax highlighting
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
    print_info "Instalando zsh-syntax-highlighting..."
    log "INFO" "INICIANDO: pacman -S zsh-syntax-highlighting"
    pacman -S --noconfirm zsh-syntax-highlighting 2>&1 | tee -a "$LOG_FILE" || true
    
    # Copiar para oh-my-zsh se necessário
    if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        cp -r /usr/share/zsh/plugins/zsh-syntax-highlighting/* \
            ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/ 2>/dev/null || true
    fi
    print_success "zsh-syntax-highlighting instalado"
else
    print_warning "zsh-syntax-highlighting já existe"
fi

# Autosuggestions
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    print_info "Instalando zsh-autosuggestions..."
    log "INFO" "INICIANDO: pacman -S zsh-autosuggestions"
    pacman -S --noconfirm zsh-autosuggestions 2>&1 | tee -a "$LOG_FILE" || true
    
    if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        cp -r /usr/share/zsh/plugins/zsh-autosuggestions/* \
            ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/ 2>/dev/null || true
    fi
    print_success "zsh-autosuggestions instalado"
else
    print_warning "zsh-autosuggestions já existe"
fi

# ====================================
# CONFIGURAR ZSHRC
# ====================================

print_header "Configurando .zshrc"

# Aplicar configuração do repositório se existir
if [[ -f "dotfiles/.zshrc.example" ]]; then
    print_info "Aplicando configuração do repositório..."
    cp dotfiles/.zshrc.example ~/.zshrc
    print_success ".zshrc configurado"
else
    # Usar padrão minimamente configurado
    cat >> ~/.zshrc << 'EOF'

# ==========================================
# POWERLEVEL10K SETUP
# ==========================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git arch extract docker sudo colorize colored-man-pages history-substring-search)

source $ZSH/oh-my-zsh.sh

# ==========================================
# ALIAS
# ==========================================
alias ll='ls -lah --color=auto'
alias la='ls -lA --color=auto'
alias ls='ls --color=auto'

# ==========================================
# POWERLEVEL10K CONFIG
# ==========================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
    print_success ".zshrc configurado com padrões"
fi

# ====================================
# INSTALAR FERRAMENTAS RECOMENDADAS
# ====================================

print_header "Installation: Ferramentas Recomendadas"

TOOLS=(
    "fzf:Fuzzy Finder"
    "ripgrep:Grep moderno"
    "fd:Find moderno"
    "bat:Cat com highlighting"
    "exa:Ls moderno"
    "htop:Monitor de processos"
    "neofetch:Info do sistema"
)

for tool_info in "${TOOLS[@]}"; do
    tool="${tool_info%%:*}"
    desc="${tool_info##*:}"
    
    if command -v "$tool" &> /dev/null; then
        print_warning "$desc já instalado"
    else
        print_info "Instalando $desc ($tool)..."
        pacman -S --noconfirm "$tool" || print_warning "Falha ao instalar $tool"
    fi
done

# ====================================
# CONFIGURAR COMO SHELL PADRÃO
# ====================================

print_header "Configuração Final"

if [[ $SHELL != */zsh ]]; then
    print_info "Definindo Zsh como shell padrão..."
    chsh -s /usr/bin/zsh
    print_success "Zsh definido como shell padrão"
    print_warning "Execute 'exit' e abra um novo terminal"
else
    print_success "Zsh já é o shell padrão"
fi

# ====================================
# FINALIZAÇÃO
# ====================================

print_header "✨ Terminal Configurado!"

echo -e "${YELLOW}Próximos passos:${NC}"
echo "  1. Digite: ${BLUE}exit${NC} (para usar o novo shell)"
echo "  2. Customize o Powerlevel10k:"
echo "     ${BLUE}p10k configure${NC}"
echo "  3. Abra Alacritty:"
echo "     ${BLUE}alacritty &${NC}"
echo ""
echo -e "${YELLOW}Instalado:${NC}"
echo "  ✓ Alacritty (terminal GPU acelerado)"
echo "  ✓ Zsh (shell interativo)"
echo "  ✓ Oh My Zsh (framework)"
echo "  ✓ Powerlevel10k (prompt visual)"
echo "  ✓ Plugins Zsh (syntax, autosuggestions)"
echo "  ✓ Ferramentas modernas (fzf, ripgrep, fd, bat, exa, htop, neofetch)"
echo ""

print_success "Setup de terminal completo! 🚀"

log "INFO" "═══════════════════════════════════════════════════════════"
log "SUCCESS" "install-terminal.sh CONCLUÍDO COM SUCESSO"
log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "═══════════════════════════════════════════════════════════"
