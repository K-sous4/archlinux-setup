#!/bin/bash

################################################################################
# Script: check-prerequisites.sh
# Descrição: Verifica e instala pré-requisitos do sistema antes de qualquer setup
# Uso: bash scripts/check-prerequisites.sh
# Distribuições suportadas: Arch Linux, Manjaro
################################################################################

# Ativar modo debug se DEBUG=1
[[ "$DEBUG" == "1" ]] && set -x

# ====================================
# DIAGNÓSTICO INICIAL
# ====================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 check-prerequisites.sh iniciando..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "• PID: $$"
echo "• User: $USER"
echo "• PWD: $PWD"
echo "• LOG_FILE: $LOG_FILE"
echo "• LOG_DIR: $LOG_DIR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ====================================
# INICIALIZAR LOGGING
# ====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_logging.sh"

# Log início do script
log "INFO" "═══════════════════════════════════════════════════════════"
log "INFO" "INICIANDO: check-prerequisites.sh"
log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "PID: $$"
log "INFO" "═══════════════════════════════════════════════════════════"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações de modo (padrão: automático)
INTERACTIVE_MODE="${INTERACTIVE_MODE:-0}"
SKIP_UPDATE="${SKIP_UPDATE:-0}"
SKIP_ESSENTIALS="${SKIP_ESSENTIALS:-0}"
SKIP_MODERN_TOOLS="${SKIP_MODERN_TOOLS:-0}"
SKIP_SUDO_CHECK="${SKIP_SUDO_CHECK:-0}"

log "INFO" "Modo interativo: $INTERACTIVE_MODE, Skip update: $SKIP_UPDATE, Skip essentials: $SKIP_ESSENTIALS"

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
    log "DEBUG" "install_package() chamado com: $package"
    
    if command_exists "$package"; then
        log_success "$package já instalado"
        log "INFO" "Pacote $package já presente no sistema"
        return 0
    fi
    
    log_info "Instalando $package..."
    log "DEBUG" "INICIANDO: pacman -S $package"
    log "INFO" "Executando: sudo pacman -S --noconfirm $package"
    
    if sudo pacman -S --noconfirm "$package" 2>&1 | tee -a "$LOG_FILE"; then
        log_success "$package instalado com sucesso"
        log "SUCCESS" "Pacote $package instalado"
        log "DEBUG" "install_package($package) completado com sucesso"
        return 0
    else
        local exit_code=$?
        log_error "Falha ao instalar $package (exit code: $exit_code)"
        log "ERROR" "Falha ao instalar pacote $package (exit code: $exit_code)"
        log "DEBUG" "install_package($package) falhou"
        return $exit_code
    fi
}

# Função para verificar permissões sudo
check_sudo() {
    log_info "Verificando permissões sudo..."
    log "DEBUG" "SKIP_SUDO_CHECK=$SKIP_SUDO_CHECK"
    
    if [[ "$SKIP_SUDO_CHECK" == "1" ]]; then
        log_warn "Verificação de sudo desabilitada"
        return 0
    fi
    
    log "DEBUG" "Tentando verificar sudo sem senha..."
    if ! sudo -n true 2>/dev/null; then
        log_warn "Sudo requer senha. Solicitando..."
        timeout 30 sudo -v || {
            log_error "Acesso sudo necessário ou expirou timeout de 30s"
            log "ERROR" "Falha ao obter permissões sudo"
            exit 1
        }
    fi
    log_success "Permissões sudo OK"
    log "DEBUG" "Sudo verificado com sucesso"
}

# Função para verificar conectividade
check_connectivity() {
    log_info "Verificando conectividade com internet..."
    log "DEBUG" "Enviando ping para 8.8.8.8 (timeout: 10s)..."
    
    if timeout 10 ping -c 1 8.8.8.8 &> /dev/null; then
        log_success "Internet OK"
        log "DEBUG" "Conectividade verificada com sucesso"
        return 0
    else
        log_warn "Sem conectividade com internet (timeout ou sem resposta)"
        log "WARNING" "Sem internet - algumas instalações podem falhar"
        return 1
    fi
}

# Função para atualizar sistema
update_system() {
    log_info "Atualizando sistema..."
    log "INFO" "INICIANDO: pacman -Sy (sincronizar índice de pacotes)"
    log "DEBUG" "Este processo pode levar vários minutos..."
    
    if sudo pacman -Sy --noconfirm 2>&1 | tee -a "$LOG_FILE"; then
        log_success "Sistema atualizado"
        log "SUCCESS" "pacman -Sy concluído com sucesso"
        return 0
    else
        log_error "Falha ao atualizar sistema"
        log "ERROR" "pacman -Sy falhou com exit code: $?"
        return 1
    fi
}

# Função para instalar ferramentas essenciais
install_essentials() {
    log_info "Instalando ferramentas essenciais..."
    log "INFO" "Ferramentas essenciais: base-devel, git, curl, wget, unzip, openssh, sudo, vi, which"
    log "DEBUG" "Este processo pode levar vários minutos..."
    
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
    
    local count=0
    local total=${#essentials[@]}
    
    for pkg in "${essentials[@]}"; do
        ((count++))
        log "DEBUG" "[$count/$total] Verificando pacote essencial: $pkg"
        if ! command_exists "$pkg"; then
            log "DEBUG" "  └─ $pkg não encontrado, instalando..."
            install_package "$pkg" || log_warn "Falha ao instalar $pkg (não crítico)"
        else
            log "DEBUG" "  └─ $pkg já instalado"
            log_success "$pkg já estava disponível"
        fi
    done
    
    log "SUCCESS" "Instalação de ferramentas essenciais concluída"
    log "INFO" "Todos os pacotes essenciais processados"
}

# Função para instalar ferramentas modernas
install_modern_tools() {
    log_info "Instalando ferramentas modernas..."
    log "INFO" "Ferramentas modernas: fzf, ripgrep, fd, bat, exa, htop, neofetch, jq"
    log "DEBUG" "Este processo pode levar vários minutos..."
    
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
    
    local count=0
    local total=${#modern_tools[@]}
    
    for pkg in "${modern_tools[@]}"; do
        ((count++))
        log "DEBUG" "[$count/$total] Verificando ferramenta moderna: $pkg"
        if ! command_exists "$pkg"; then
            log "DEBUG" "  └─ $pkg não encontrado, instalando..."
            install_package "$pkg" || log_warn "Falha ao instalar $pkg (opcional)"
        else
            log "DEBUG" "  └─ $pkg já instalado"
            log_success "$pkg já estava disponível"
        fi
    done
    
    log "SUCCESS" "Instalação de ferramentas modernas concluída"
    log "INFO" "Todas as ferramentas modernas foram processadas"
}

# Função para verificar variáveis de ambiente
check_environment() {
    log_info "Verificando variáveis de ambiente..."
    log "DEBUG" "Verificando variáveis de ambiente obrigatórias..."
    
    # Verificar if $HOME está configurado
    if [ -z "$HOME" ]; then
        log_error "HOME não está configurado"
        log "ERROR" "Variável HOME não definida"
        return 1
    fi
    log_success "HOME=$HOME"
    log "DEBUG" "  ✓ HOME configurado"
    
    # Verificar if $USER está configurado
    if [ -z "$USER" ]; then
        log_error "USER não está configurado"
        log "ERROR" "Variável USER não definida"
        return 1
    fi
    log_success "USER=$USER"
    log "DEBUG" "  ✓ USER configurado"
    
    log "SUCCESS" "Variáveis de ambiente OK"
    return 0
}

# Função para verificar espaço em disco
check_disk_space() {
    log_info "Verificando espaço em disco..."
    log "DEBUG" "Verificando espaço em: $HOME"
    
    local available_gb=$(df "$HOME" | tail -1 | awk '{print $4/1024/1024}')
    local required_gb=5
    
    log "DEBUG" "Espaço disponível: ${available_gb%.*}GB, Requerido: ${required_gb}GB"
    
    if (( $(echo "$available_gb > $required_gb" | bc -l) )); then
        log_success "Espaço em disco: ${available_gb%.*}GB (mínimo: ${required_gb}GB)"
        log "DEBUG" "Espaço em disco OK"
        return 0
    else
        log_error "Espaço insuficiente: ${available_gb%.*}GB (mínimo: ${required_gb}GB)"
        log "ERROR" "Espaço em disco insuficiente"
        return 1
    fi
}

# Função para criar estrutura de diretórios
create_directories() {
    log_info "Criando estrutura de diretórios..."
    log "DEBUG" "Criando diretórios essenciais para o usuário..."
    
    local dirs=(
        "$HOME/.config"
        "$HOME/.local/bin"
        "$HOME/.local/share"
        "$HOME/Projects"
    )
    
    local count=0
    for dir in "${dirs[@]}"; do
        ((count++))
        log "DEBUG" "[$count/${#dirs[@]}] Criando/verificando: $dir"
        if mkdir -p "$dir" 2>&1 | tee -a "$LOG_FILE"; then
            log "DEBUG" "  ✓ $dir okay"
        else
            log_warn "Falha ao criar $dir"
        fi
    done
    
    log_success "Diretórios criados"
    log "SUCCESS" "Estrutura de diretórios criada com sucesso"
}

# Função principal
main() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Verificação de Pré-requisitos do Sistema  ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    log "DEBUG" "Iniciando sequência de verificações"
    
    # Detectar distribuição
    log "DEBUG" "Detectando distribuição..."
    local distro=$(detect_distro)
    if [ "$distro" = "unknown" ]; then
        log_error "Distribuição não suportada. Use Arch Linux ou Manjaro."
        log "ERROR" "Distribuição desconhecida"
        exit 1
    fi
    log_success "Distribuição detectada: $distro"
    echo ""
    
    # Verificar sudo (com timeout)
    log "DEBUG" "=== ETAPA 1: Verificação de sudo ==="
    check_sudo || exit 1
    echo ""
    
    # Verificar conectividade (com timeout)
    log "DEBUG" "=== ETAPA 2: Verificação de conectividade ==="
    check_connectivity || log_warn "Continuando sem internet..."
    echo ""
    
    # Verificar ambiente
    log "DEBUG" "=== ETAPA 3: Verificação de ambiente ==="
    check_environment || exit 1
    echo ""
    
    # Verificar espaço em disco
    log "DEBUG" "=== ETAPA 4: Verificação de espaço em disco ==="
    check_disk_space || {
        log_warn "Espaço baixo - continue por sua conta e risco"
    }
    echo ""
    
    # Atualizar sistema (automático ou skip)
    log "DEBUG" "=== ETAPA 5: Atualização de sistema ==="
    if [[ "$SKIP_UPDATE" != "1" ]]; then
        log_info "Atualizando pacman (isso pode levar vários minutos)..."
        log "DEBUG" "Executando: pacman -Sy (apenas atualizar índice)"
        update_system || log_warn "Falha ao atualizar (continuando mesmo assim)"
        echo ""
    else
        log_warn "Atualização de sistema desabilitada (SKIP_UPDATE=1)"
    fi
    
    # Instalar essenciais (automático ou skip)
    log "DEBUG" "=== ETAPA 6: Instalação de ferramentas essenciais ==="
    if [[ "$SKIP_ESSENTIALS" != "1" ]]; then
        install_essentials
        echo ""
    else
        log_warn "Instalação de essenciais desabilitada (SKIP_ESSENTIALS=1)"
    fi
    
    # Instalar ferramentas modernas (automático ou skip)
    log "DEBUG" "=== ETAPA 7: Instalação de ferramentas modernas ==="
    if [[ "$SKIP_MODERN_TOOLS" != "1" ]]; then
        install_modern_tools
        echo ""
    else
        log_warn "Instalação de ferramentas modernas desabilitada (SKIP_MODERN_TOOLS=1)"
    fi
    
    # Criar diretórios
    log "DEBUG" "=== ETAPA 8: Criação de diretórios ==="
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
log "DEBUG" "Executando função main()"
main "$@"
log "DEBUG" "Script terminado com sucesso"
