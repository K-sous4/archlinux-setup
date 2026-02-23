#!/bin/bash

################################################################################
# Script: check-prerequisites.sh
# Descrição: Verifica e instala pré-requisitos do sistema antes de qualquer setup
# Uso: bash scripts/check-prerequisites.sh
# Distribuições suportadas: Arch Linux, Manjaro
################################################################################

set -e

# ====================================
# INICIALIZAR LOGGING
# ====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_logging.sh"

# Log início do script
log "INFO" "═══════════════════════════════════════════════════════════"
log "INFO" "INICIANDO: check-prerequisites.sh"
log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "═══════════════════════════════════════════════════════════"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de logging locais (fallback se LOG_FILE não existir)
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
    log "INFO" "$1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
    log "SUCCESS" "$1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    log "WARNING" "$1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
    log "ERROR" "$1"
}

# Função para detectar distribuição
detect_distro() {
    if grep -q "Manjaro" /etc/os-release; then
        echo "manjaro"
    elif grep -q "Arch Linux" /etc/os-release; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# Função para verificar comando
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para instalar pacote
install_package() {
    local package=$1
    
    if command_exists "$package"; then
        log_success "$package já instalado"
        log "INFO" "Pacote $package já presente no sistema"
        return 0
    fi
    
    log_info "Instalando $package..."
    log "INFO" "INICIANDO: pacman -S $package"
    
    if sudo pacman -S --noconfirm "$package" 2>&1 | tee -a "$LOG_FILE"; then
        log_success "$package instalado com sucesso"
        log "SUCCESS" "Pacote $package instalado"
        return 0
    else
        log_error "Falha ao instalar $package"
        log "ERROR" "Falha ao instalar pacote $package"
        return 1
    fi
}

# Função para verificar permissões sudo
check_sudo() {
    log_info "Verificando permissões sudo..."
    
    if ! sudo -n true 2>/dev/null; then
        log_warn "Você será pedido para inserir sua senha para algumas operações"
        sudo -v || {
            log_error "Acesso sudo necessário. Aborte."
            exit 1
        }
    fi
    log_success "Permissões sudo OK"
}

# Função para verificar conectividade
check_connectivity() {
    log_info "Verificando conectividade com internet..."
    
    if ping -c 1 8.8.8.8 &> /dev/null; then
        log_success "Internet OK"
        return 0
    else
        log_warn "Sem conectividade com internet"
        return 1
    fi
}

# Função para atualizar sistema
update_system() {
    log_info "Atualizando sistema..."
    log "INFO" "INICIANDO: pacman -Syu (isso pode levar vários minutos)"
    
    if sudo pacman -Syu --noconfirm 2>&1 | tee -a "$LOG_FILE"; then
        log_success "Sistema atualizado"
        log "SUCCESS" "pacman -Syu concluído"
        return 0
    else
        log_error "Falha ao atualizar sistema"
        log "ERROR" "pacman -Syu falhou"
        return 1
    fi
}

# Função para instalar ferramentas essenciais
install_essentials() {
    log_info "Instalando ferramentas essenciais..."
    log "INFO" "Ferramentas essenciais: base-devel, git, curl, wget, unzip, openssh, sudo, vi, which"
    
    local essentials=(
        "base-devel"      # Build tools (gcc, make, etc)
        "git"             # Version control
        "curl"            # Download files
        "wget"            # Download files (alternativa)
        "unzip"           # Extract archives
        "openssh"         # SSH/SCP
        "sudo"            # Elevated privileges
        "vi"              # Editor
        "which"           # Locate commands
    )
    
    for pkg in "${essentials[@]}"; do
        log "DEBUG" "Verificando pacote essencial: $pkg"
        if ! command_exists "$pkg"; then
            install_package "$pkg" || log_warn "Falha ao instalar $pkg (não crítico)"
        else
            log_success "$pkg já instalado"
        fi
    done
    
    log "SUCCESS" "Instalação de ferramentas essenciais concluída"
}

# Função para instalar ferramentas modernas
install_modern_tools() {
    log_info "Instalando ferramentas modernas..."
    log "INFO" "Ferramentas modernas: fzf, ripgrep, fd, bat, exa, htop, neofetch, jq"
    
    local modern_tools=(
        "fzf"             # Fuzzy finder
        "ripgrep"         # Grep moderno (rg)
        "fd"              # Find moderno
        "bat"             # Cat com highlighting
        "exa"             # Ls moderno
        "htop"            # Monitor processos
        "neofetch"        # Info sistema
        "jq"              # JSON processor
    )
    
    for pkg in "${modern_tools[@]}"; do
        log "DEBUG" "Verificando ferramenta moderna: $pkg"
        if ! command_exists "$pkg"; then
            install_package "$pkg" || log_warn "Falha ao instalar $pkg (opcional)"
        else
            log_success "$pkg já instalado"
        fi
    done
    
    log "SUCCESS" "Instalação de ferramentas modernas concluída"
}

# Função para verificar variáveis de ambiente
check_environment() {
    log_info "Verificando variáveis de ambiente..."
    
    # Verificar if $HOME está configurado
    if [ -z "$HOME" ]; then
        log_error "HOME não está configurado"
        return 1
    fi
    log_success "HOME=$HOME"
    
    # Verificar if $USER está configurado
    if [ -z "$USER" ]; then
        log_error "USER não está configurado"
        return 1
    fi
    log_success "USER=$USER"
    
    return 0
}

# Função para verificar espaço em disco
check_disk_space() {
    log_info "Verificando espaço em disco..."
    
    local available_gb=$(df "$HOME" | tail -1 | awk '{print $4/1024/1024}')
    local required_gb=5
    
    if (( $(echo "$available_gb > $required_gb" | bc -l) )); then
        log_success "Espaço em disco: ${available_gb%.*}GB (mínimo: ${required_gb}GB)"
        return 0
    else
        log_error "Espaço insuficiente: ${available_gb%.*}GB (mínimo: ${required_gb}GB)"
        return 1
    fi
}

# Função para criar estrutura de diretórios
create_directories() {
    log_info "Criando estrutura de diretórios..."
    
    local dirs=(
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share"
        "$HOME/Projects"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir" || log_warn "Falha ao criar $dir"
    done
    
    log_success "Diretórios criados"
}

# Função principal
main() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Verificação de Pré-requisitos do Sistema  ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # Detectar distribuição
    local distro=$(detect_distro)
    if [ "$distro" = "unknown" ]; then
        log_error "Distribuição não suportada. Use Arch Linux ou Manjaro."
        exit 1
    fi
    log_success "Distribuição detectada: $distro"
    echo ""
    
    # Executar verificações
    check_sudo || exit 1
    echo ""
    
    check_connectivity || log_warn "Sem internet - algumas instalações podem falhar"
    echo ""
    
    check_environment || exit 1
    echo ""
    
    check_disk_space || {
        log_warn "Espaço baixo - continue por sua conta e risco"
    }
    echo ""
    
    # Atualizar sistema
    log_info "Atualizando sistema? (recomendado) (s/n)"
    read -r response
    if [[ "$response" =~ ^[Ss]$ ]]; then
        update_system
        echo ""
    fi
    
    # Instalar essenciais
    log_info "Instalando ferramentas essenciais? (recomendado) (s/n)"
    read -r response
    if [[ "$response" =~ ^[Ss]$ ]]; then
        install_essentials
        echo ""
    fi
    
    # Instalar ferramentas modernas
    log_info "Instalar ferramentas modernas (fzf, ripgrep, etc)? (opcional) (s/n)"
    read -r response
    if [[ "$response" =~ ^[Ss]$ ]]; then
        install_modern_tools
        echo ""
    fi
    
    # Criar diretórios
    create_directories
    echo ""
    
    # Resumo final
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}✓ Pré-requisitos verificados com sucesso!${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    log "INFO" "═══════════════════════════════════════════════════════════"
    log "SUCCESS" "check-prerequisites.sh CONCLUÍDO COM SUCESSO"
    log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    log "INFO" "═══════════════════════════════════════════════════════════"
    
    log_info "Próximas etapas:"
    echo "  1. Executar: bash scripts/install-terminal.sh (opcional - Alacritty + Zsh + P10k)"
    echo "  2. Executar: bash scripts/install-lunarvim.sh (opcional - LunarVim IDE)"
    echo "  3. Executar: bash scripts/install-docker.sh (opcional - Docker)"
    echo "  4. Executar: bash scripts/install-portainer.sh (opcional - Portainer)"
    echo ""
}

# Executar
main "$@"
