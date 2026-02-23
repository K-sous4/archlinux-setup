#!/bin/bash

# Auto Setup - Script automático executado após clonar o repositório
# Uso: bash auto-setup.sh
# Ou: chmod +x auto-setup.sh && ./auto-setup.sh

set -e

# ====================================
# CONFIGURAÇÃO DE LOGGING
# ====================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$SCRIPT_DIR/.setup-logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/auto-setup_${TIMESTAMP}.log"
PROGRESS_FILE="$LOG_DIR/setup-progress.txt"

# Criar diretório de logs
mkdir -p "$LOG_DIR"

# Função para logar
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_step() {
    local step=$1
    local total=$2
    local message=$3
    local status=$4
    echo "$step/$total | $message | $status" >> "$PROGRESS_FILE"
    echo -e "${BLUE}[$step/$total] $message - $status${NC}"
}

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "\n${PURPLE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} $1"
    echo -e "${PURPLE}╚════════════════════════════════════════════╝${NC}\n"
    log "INFO" "$1"
}

progress_bar() {
    local current=$1
    local total=$2
    local width=30
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' '-'
    printf "] %d/%d\n" "$current" "$total"
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

# Função para verificar comando
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para atualizar chaves do Arch
update_arch_keyring() {
    log_step "PRE" "$TOTAL_STEPS" "Verificar chaves do Arch Linux" "EM ANDAMENTO"
    print_info "Verificando chaves do Arch Linux..."
    
    # Passo 1: Atualizar o pacote archlinux-keyring
    if sudo pacman -Sy archlinux-keyring --noconfirm >> "$LOG_FILE" 2>&1; then
        print_success "Pacote archlinux-keyring atualizado"
    else
        print_warning "Aviso ao atualizar archlinux-keyring"
    fi
    
    # Passo 2: Sincronizar chaves
    print_info "Sincronizando chaves do pacman..."
    if sudo pacman-key --init >> "$LOG_FILE" 2>&1; then
        print_info "Chaves inicializadas"
    fi
    
    if sudo pacman-key --populate archlinux >> "$LOG_FILE" 2>&1; then
        print_success "Chaves do Arch Linux populadas/sincronizadas"
        log_step "PRE" "$TOTAL_STEPS" "Verificar chaves do Arch Linux" "✓ CONCLUÍDO"
        return 0
    else
        log_step "PRE" "$TOTAL_STEPS" "Verificar chaves do Arch Linux" "⚠ Com avisos"
        print_warning "Aviso ao popular chaves, tentando atualizar keyring..."
        
        # Tentar solucionar problemas comuns
        if sudo pacman -Scc --noconfirm >> "$LOG_FILE" 2>&1; then
            print_info "Cache pacman limpo"
        fi
        
        # Tentar novamente
        if sudo pacman -Sy archlinux-keyring --noconfirm >> "$LOG_FILE" 2>&1; then
            print_success "Chaves do Arch Linux atualizadas (após limpeza)"
            return 0
        else
            print_warning "Falha ao atualizar chaves (continuando mesmo assim...)"
            echo -e "${YELLOW}⚠ Se tiver problemas depois, execute:${NC}"
            echo "  sudo pacman-key --init"
            echo "  sudo pacman-key --populate archlinux"
            echo "  sudo pacman -Sy archlinux-keyring"
            return 1
        fi
    fi
}


# Função para executar com timeout e log
run_script() {
    local script=$1
    local description=$2
    local step=$3
    local total=$4
    local use_sudo=${5:-false}  # Parâmetro opcional: true para executar com sudo
    
    log_step "$step" "$total" "$description" "INICIANDO"
    
    if [[ -f "$script" ]]; then
        if [[ "$use_sudo" == true ]]; then
            if sudo bash "$script" 2>> "$LOG_FILE"; then
                log_step "$step" "$total" "$description" "✓ CONCLUÍDO"
                print_success "$description"
                return 0
            else
                log_step "$step" "$total" "$description" "✗ FALHA"
                print_error "$description falhou (veja $LOG_FILE para detalhes)"
                return 1
            fi
        else
            if bash "$script" 2>> "$LOG_FILE"; then
                log_step "$step" "$total" "$description" "✓ CONCLUÍDO"
                print_success "$description"
                return 0
            else
                log_step "$step" "$total" "$description" "✗ FALHA"
                print_error "$description falhou (veja $LOG_FILE para detalhes)"
                return 1
            fi
        fi
    else
        log_step "$step" "$total" "$description" "⚠ NÃO ENCONTRADO"
        print_warning "Script $script não encontrado"
        return 1
    fi
}

# ====================================
# INÍCIO
# ====================================

# ====================================
# INÍCIO
# ====================================

# Verificar sudo disponível (necessário para vários scripts)
if ! sudo -n true 2>/dev/null; then
    print_info "Você será pedido para inserir sua senha para operações privilegiadas"
    if ! sudo -v; then
        print_error "Acesso sudo necessário para continuar"
        exit 1
    fi
fi

echo -e "${CYAN}═════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  ARCH LINUX / MANJARO - AUTO SETUP${NC}"
echo -e "${CYAN}  Iniciado: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${CYAN}  Log: $LOG_FILE${NC}"
echo -e "${CYAN}═════════════════════════════════════════════════════════${NC}"
echo ""

print_header "� VERIFICAÇÃO PRÉ-INSTALAÇÃO"

print_info "Verificando integridade das chaves do Arch Linux...\\nIsso é importante para evitar problemas na instalação."
update_arch_keyring
echo ""

print_header "📋 PLANEJAMENTO DE INSTALAÇÃO"

echo -e "${YELLOW}Este script irá executar:${NC}"
echo "  1️⃣  Verificar pré-requisitos do sistema"
echo "  2️⃣  Detectar distribuição (Arch/Manjaro)"
echo "  3️⃣  Remover bloatware (se Manjaro)"
echo "  4️⃣  Atualizar sistema"
echo "  4️⃣.5️⃣ Verificar chaves do Arch Linux"
echo "  5️⃣  Instalar Terminal (Alacritty + Zsh + Powerlevel10k)"
echo "  6️⃣  Instalar/atualizar packages"
echo "  7️⃣  Aplicar configurações"
echo ""
echo -e "${CYAN}Tempo estimado: 30-90 minutos${NC}"
echo ""

read -p "Continuar? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    print_warning "Cancelado pelo usuário"
    exit 0
fi

# Inicializar arquivo de progresso
echo "=== Auto Setup Progress ===" > "$PROGRESS_FILE"
echo "Iniciado em: $(date)" >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

TOTAL_STEPS=7
CURRENT_STEP=0

# ====================================
# PASSO 1: VERIFICAR PRÉ-REQUISITOS
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))
run_script "scripts/check-prerequisites.sh" "Verificar pré-requisitos" "$CURRENT_STEP" "$TOTAL_STEPS" || true

# ====================================
# PASSO 2: DETECTAR DISTRIBUIÇÃO
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))
log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Detectar distribuição" "EM ANDAMENTO"

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
    log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Detectar distribuição" "✓ Manjaro"
    print_success "Manjaro detectado"
elif [[ "$OS" == "arch" ]]; then
    IS_MANJARO=false
    log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Detectar distribuição" "✓ Arch Linux"
    print_success "Arch Linux detectado"
else
    print_warning "Distribuição desconhecida: $OS"
fi

# ====================================
# PASSO 3: DEBLOAT MANJARO (se aplicável)
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))

if [[ $IS_MANJARO == true ]]; then
    log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Remover bloatware (Manjaro)" "EM ANDAMENTO"
    
    read -p "Deseja remover aplicações pré-instaladas desnecessárias? (s/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        run_script "scripts/debloat-manjaro.sh" "Remover bloatware" "$CURRENT_STEP" "$TOTAL_STEPS" true || print_warning "Debloat falhou, continuando..."
    else
        log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Remover bloatware" "⊘ Pulado"
        print_info "Bloatware não será removido"
    fi
else
    log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Remover bloatware" "⊘ N/A (Arch)"
    print_info "Bloatware não aplicável em Arch Linux"
fi

# ====================================
# PASSO 4: ATUALIZAR SISTEMA
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))
log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Atualizar sistema" "EM ANDAMENTO"

echo "Atualizando sistema com pacman..."
if sudo pacman -Syu --noconfirm >> "$LOG_FILE" 2>&1; then
    log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Atualizar sistema" "✓ CONCLUÍDO"
    print_success "Sistema atualizado"
else
    log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Atualizar sistema" "⚠ Avisos"
    print_warning "Atualização do sistema teve avisos (veja log)"
fi

# ====================================
# PASSO 4.5: VERIFICAR CHAVES DO ARCH
# ====================================

echo ""
print_info "Verificando integridade do keyring do Arch Linux..."
update_arch_keyring
echo ""

# ====================================
# PASSO 5: INSTALAR TERMINAL
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))
run_script "scripts/install-terminal.sh" "Configurar Terminal (Alacritty + Zsh + P10k)" "$CURRENT_STEP" "$TOTAL_STEPS" true || print_warning "Terminal setup falhou, continuando..."

# ====================================
# PASSO 6: INSTALAR PACKAGES
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))
log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Instalar packages" "EM ANDAMENTO"

if [[ ! -f "packages/pacman-packages.txt" ]]; then
    print_warning "Arquivos de packages não encontrados"
    print_info "Executando export-packages.sh..."
    run_script "scripts/export-packages.sh" "Exportar lista de packages" "$CURRENT_STEP" "$TOTAL_STEPS" || print_warning "Export falhou"
else
    read -p "Deseja reinstalar packages do repositório? (s/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        run_script "scripts/install-packages.sh" "Instalar packages" "$CURRENT_STEP" "$TOTAL_STEPS" true || print_warning "Install packages falhou"
    else
        log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Instalar packages" "⊘ Pulado"
    fi
fi

# ====================================
# PASSO 7: APLICAR CONFIGURAÇÕES
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))
log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Aplicar configurações" "EM ANDAMENTO"

if [[ -f "scripts/setup.sh" ]]; then
    bash "scripts/setup.sh" <<< "1" 2>> "$LOG_FILE" || print_warning "Setup.sh teve avisos"
    log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Aplicar configurações" "✓ CONCLUÍDO"
    print_success "Configurações aplicadas"
else
    print_warning "Script setup.sh não encontrado"
fi

# ====================================
# FINALIZAÇÃO
# ====================================

echo "" >> "$PROGRESS_FILE"
echo "Concluído em: $(date)" >> "$PROGRESS_FILE"

print_header "✨ SETUP COMPLETO!"

echo -e "${GREEN}═════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ Instalação finalizada com sucesso!${NC}"
echo -e "${GREEN}═════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo "  1. Verifique o terminal: abra ${BLUE}alacritty${NC}"
echo "  2. Customize Powerlevel10k: ${BLUE}p10k configure${NC}"
echo "  3. Recarregue o shell: ${BLUE}exec zsh${NC} ou faça logout/login"
echo ""

echo -e "${YELLOW}💡 Dicas:${NC}"
echo "  • Nerd Font (para ícones): https://www.nerdfonts.com/"
echo "  • Exportar suas configs: ${BLUE}bash makefile.sh export${NC}"
echo "  • Sincronizar com GitHub: ${BLUE}bash makefile.sh commit${NC}"
echo "  • Ver status: ${BLUE}bash makefile.sh status${NC}"
echo ""

echo -e "${CYAN}🔧 Recursos opcionais:${NC}"
echo "  • LunarVim IDE: ${BLUE}bash scripts/install-lunarvim.sh${NC}"
echo "  • Docker & Portainer: ${BLUE}bash scripts/install-docker.sh${NC}"
echo "                        ${BLUE}bash scripts/install-portainer.sh${NC}"
echo ""

echo -e "${BLUE}📋 Log completo salvo em: $LOG_FILE${NC}"
echo -e "${BLUE}📊 Progresso salvo em: $PROGRESS_FILE${NC}"
