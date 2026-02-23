#!/bin/bash

# Auto Setup - Script automático executado após clonar o repositório
# Uso: bash auto-setup.sh
# Ou: chmod +x auto-setup.sh && ./auto-setup.sh
# 
# MODO AUTOMÁTICO: Instala TUDO na primeira execução
# Se tiver erros, mostra output detalhado
#
# ====================================
# LOGGING DOS SUBSCRIPTS
# ====================================
# Variáveis de ambiente exportadas para subscripts:
#  - LOG_FILE:  Caminho do arquivo de log principal
#  - LOG_DIR:   Diretório de logs
#
# Exemplo de uso em subscripts:
#
#   # No início do subscript, opcional - funções de logging
#   if [[ -z "$LOG_FILE" ]]; then
#       log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }
#   else
#       log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
#   fi
#
#   # Usar logging
#   log "INFO: Iniciando processo..."
#   log "SUCCESS: Instalação completa!"
#   log "ERROR: Algo deu errado"
#
# TODO output dos subscripts será redirecionado automaticamente para:
#   - STDOUT/STDERR → $LOG_FILE
#   - Erros críticos → $ERROR_LOG

# ====================================
# INICIALIZAR VARIÁVEIS ANTES DE 'set -e'
# ====================================

# MODO: 'auto' (padrão - instala tudo) ou 'interactive' (pergunta tudo)
AUTO_MODE="${AUTO_MODE:-auto}"
INSTALL_ALL="${INSTALL_ALL:-true}"  # Instalar todas opções por padrão

# Variável para rastrear se houve erros
HAS_ERRORS=false

# ====================================
# CONFIGURAÇÃO DE LOGGING (INÍCIO ANTECIPADO)
# ====================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$SCRIPT_DIR/.setup-logs"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR/auto-setup_${TIMESTAMP}.log"
PROGRESS_FILE="$LOG_DIR/setup-progress.txt"
ERROR_LOG="$LOG_DIR/errors_${TIMESTAMP}.log"

# Criar diretório de logs e inicializar arquivo
if ! mkdir -p "$LOG_DIR" 2>/dev/null; then
    echo "❌ ERRO CRÍTICO: Não foi possível criar diretório de logs: $LOG_DIR"
    echo "   Verifique permissões e espaço em disco"
    exit 1
fi

# Inicializar log com timestamp
if ! {
    echo "═════════════════════════════════════════════════════════"
    echo "  AUTO SETUP LOG - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "═════════════════════════════════════════════════════════"
    echo ""
    echo "📂 LOG_DIR: $LOG_DIR"
    echo "📄 LOG_FILE: $LOG_FILE"
    echo "⚠️  ERROR_LOG: $ERROR_LOG"
    echo ""
} > "$LOG_FILE" 2>&1; then
    echo "❌ ERRO CRÍTICO: Não foi possível criar arquivo de log: $LOG_FILE"
    exit 1
fi

echo "✓ Logs inicializados em: $LOG_DIR"

# Agora é seguro usar 'set -e' após logs estarem configurados
set -e

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

# Função para capturar e exibir erros detalhados
store_error() {
    local step=$1
    local description=$2
    local error_output=$3
    
    HAS_ERRORS=true
    
    echo "" >> "$ERROR_LOG"
    echo "═══════════════════════════════════════════════════" >> "$ERROR_LOG"
    echo "Erro em: $description (Passo $step)" >> "$ERROR_LOG"
    echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "$ERROR_LOG"
    echo "═══════════════════════════════════════════════════" >> "$ERROR_LOG"
    echo "$error_output" >> "$ERROR_LOG"
    echo "" >> "$ERROR_LOG"
    
    print_error "$description falhou"
}

# Função para exibir todos os erros capturados
show_error_summary() {
    if [[ "$HAS_ERRORS" == true ]] && [[ -f "$ERROR_LOG" ]]; then
        echo ""
        echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║${NC}         ⚠️  ERROS ENCONTRADOS              "
        echo -e "${RED}╚════════════════════════════════════════════╝${NC}"
        echo ""
        cat "$ERROR_LOG"
        echo ""
        echo -e "${YELLOW}💡 Dica: Veja o log completo em: $LOG_FILE${NC}"
    fi
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


# Função para executar com timeout e logging completo
# Os subscripts podem usar LOG_FILE, LOG_DIR e importar funções de logging
run_script() {
    local script=$1
    local description=$2
    local step=$3
    local total=$4
    local use_sudo=${5:-false}  # Parâmetro opcional: true para executar com sudo
    
    log_step "$step" "$total" "$description" "INICIANDO"
    
    if [[ -f "$script" ]]; then
        # Log início do subscript
        log "INFO" "► Executando subscript: $script"
        log "DEBUG" "LOG_FILE=$LOG_FILE, LOG_DIR=$LOG_DIR"
        
        local exit_code=0
        local temp_error="/tmp/script_error_$$.txt"
        
        if [[ "$use_sudo" == true ]]; then
            # Executar com sudo, exportando variáveis, capturando erros
            export LOG_FILE="$LOG_FILE"
            export LOG_DIR="$LOG_DIR"
            
            if ! sudo -E bash "$script" >> "$LOG_FILE" 2>"$temp_error"; then
                exit_code=$?
                log_step "$step" "$total" "$description" "✗ FALHA"
                log "ERROR" "Subscript falhou: $script (exit code: $exit_code)"
                
                # Capturar erro se arquivo existir
                if [[ -f "$temp_error" ]] && [[ -s "$temp_error" ]]; then
                    local error_output=$(cat "$temp_error")
                    store_error "$step" "$description" "$error_output"
                fi
                rm -f "$temp_error"
                return $exit_code
            fi
        else
            # Executar sem sudo, exportando variáveis, capturando erros
            export LOG_FILE="$LOG_FILE"
            export LOG_DIR="$LOG_DIR"
            
            if ! bash "$script" >> "$LOG_FILE" 2>"$temp_error"; then
                exit_code=$?
                log_step "$step" "$total" "$description" "✗ FALHA"
                log "ERROR" "Subscript falhou: $script (exit code: $exit_code)"
                
                # Capturar erro se arquivo existir
                if [[ -f "$temp_error" ]] && [[ -s "$temp_error" ]]; then
                    local error_output=$(cat "$temp_error")
                    store_error "$step" "$description" "$error_output"
                fi
                rm -f "$temp_error"
                return $exit_code
            fi
        fi
        
        rm -f "$temp_error"
        log_step "$step" "$total" "$description" "✓ CONCLUÍDO"
        log "INFO" "◄ Subscript concluído com sucesso: $script"
        print_success "$description"
        return 0
    else
        log_step "$step" "$total" "$description" "⚠ NÃO ENCONTRADO"
        log "ERROR" "Script não encontrado: $script"
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

# Log os detalhes iniciais
log "INFO" "═════════════════════════════════════════════════════════"
log "INFO" "ARCH LINUX / MANJARO - AUTO SETUP"
log "INFO" "Iniciado: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "Log: $LOG_FILE"
log "INFO" "Modo: $AUTO_MODE (INSTALL_ALL=$INSTALL_ALL)"
log "INFO" "═════════════════════════════════════════════════════════"
log "INFO" ""

echo -e "${CYAN}═════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  ARCH LINUX / MANJARO - AUTO SETUP${NC}"
echo -e "${CYAN}  Iniciado: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${CYAN}  Log: $LOG_FILE${NC}"
echo -e "${CYAN}═════════════════════════════════════════════════════════${NC}"
echo ""

print_header "VERIFICAÇÃO PRÉ-INSTALAÇÃO"

log "INFO" "Iniciando verificação de pré-requisitos..."

print_info "Verificando integridade das chaves do Arch Linux...\\nIsso é importante para evitar problemas na instalação."
update_arch_keyring
echo ""

print_header "📋 PLANEJAMENTO DE INSTALAÇÃO"

log "INFO" "Plano de execução:"
log "INFO" "  1. Verificar pré-requisitos do sistema"
log "INFO" "  2. Detectar distribuição (Arch/Manjaro)"
log "INFO" "  3. Remover bloatware (se Manjaro)"
log "INFO" "  4. Atualizar sistema"
log "INFO" "  4.5. Verificar chaves do Arch Linux"
log "INFO" "  5. Instalar Terminal (Alacritty + Zsh + P10k)"
log "INFO" "  6. Instalar/atualizar packages"
log "INFO" "  7. Aplicar configurações"
log "INFO" "Tempo estimado: 30-90 minutos"
log "INFO" "Modo automático: $INSTALL_ALL"

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
echo -e "${YELLOW}Modo: ${INSTALL_ALL} (automático - instala TUDO)${NC}"
echo ""

if [[ "$INSTALL_ALL" != true ]]; then
    read -p "Continuar? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_warning "Cancelado pelo usuário"
        log "WARNING" "Setup cancelado pelo usuário"
        exit 0
    fi
else
    print_info "Modo automático ativado - iniciando instalação..."
    log "INFO" "Modo automático ativado - iniciando instalação em breve..."
fi

# Inicializar arquivo de progresso
echo "=== Auto Setup Progress ===" > "$PROGRESS_FILE"
echo "Iniciado em: $(date)" >> "$PROGRESS_FILE"
echo "Modo: $INSTALL_ALL" >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

log "INFO" "Inicializando progresso..."
log "INFO" ""

TOTAL_STEPS=7
CURRENT_STEP=0

log "INFO" "═════════════════════════════════════════════════════════"
log "INFO" "INICIANDO 7 PASSOS DE INSTALAÇÃO"
log "INFO" "═════════════════════════════════════════════════════════"
log "INFO" ""

# ====================================
# PASSO 1: VERIFICAR PRÉ-REQUISITOS
# ====================================

CURRENT_STEP=$((CURRENT_STEP + 1))
log "INFO" "[$CURRENT_STEP/$TOTAL_STEPS] PASSO 1: Verificar pré-requisitos"
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
    
    if [[ "$INSTALL_ALL" == true ]]; then
        print_info "Modo automático: Removendo bloatware..."
        run_script "scripts/debloat-manjaro.sh" "Remover bloatware" "$CURRENT_STEP" "$TOTAL_STEPS" true || true
    else
        # Modo interativo
        read -p "Deseja remover aplicações pré-instaladas desnecessárias? (s/n) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            run_script "scripts/debloat-manjaro.sh" "Remover bloatware" "$CURRENT_STEP" "$TOTAL_STEPS" true || true
        else
            log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Remover bloatware" "⊘ Pulado"
            print_info "Bloatware não será removido"
        fi
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
    run_script "scripts/export-packages.sh" "Exportar lista de packages" "$CURRENT_STEP" "$TOTAL_STEPS" || true
else
    if [[ "$INSTALL_ALL" == true ]]; then
        print_info "Modo automático: Instalando packages..."
        run_script "scripts/install-packages.sh" "Instalar packages" "$CURRENT_STEP" "$TOTAL_STEPS" true || true
    else
        # Modo interativo
        read -p "Deseja reinstalar packages do repositório? (s/n) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            run_script "scripts/install-packages.sh" "Instalar packages" "$CURRENT_STEP" "$TOTAL_STEPS" true || true
        else
            log_step "$CURRENT_STEP" "$TOTAL_STEPS" "Instalar packages" "⊘ Pulado"
        fi
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

log "INFO" ""
log "INFO" "═════════════════════════════════════════════════════════"
log "INFO" "SETUP FINALIZADO"
log "INFO" "Conclusão: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "═════════════════════════════════════════════════════════"
log "INFO" ""

# Verificar e reportar arquivos de log criados
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📂 VERIFICAÇÃO DE LOGS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

if [[ -d "$LOG_DIR" ]]; then
    echo -e "${GREEN}✓ Diretório de logs encontrado${NC}"
    echo -e "  Localização: ${CYAN}$LOG_DIR${NC}"
    echo ""
    
    # Listar arquivos e tamanho
    echo -e "${YELLOW}📋 Arquivos de log:${NC}"
    if ls -lh "$LOG_DIR"/* 2>/dev/null | tail -n +2 > /dev/null; then
        ls -lh "$LOG_DIR"/* 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
    else
        echo "  ❌ Nenhum arquivo de log encontrado!"
    fi
    echo ""
    
    # Verificar tamanho total
    local log_size=$(du -sh "$LOG_DIR" 2>/dev/null | awk '{print $1}')
    echo -e "${YELLOW}💾 Tamanho total:${NC} $log_size"
    echo ""
    
    # Mostrar quantidade de linhas no arquivo principal
    if [[ -f "$LOG_FILE" ]]; then
        local line_count=$(wc -l < "$LOG_FILE" 2>/dev/null || echo "0")
        echo -e "${YELLOW}📝 Linhas no log principal:${NC} $line_count linhas"
    fi
else
    echo -e "${RED}✗ ERRO: Diretório de logs NÃO FOI CRIADO${NC}"
    echo -e "  Localização esperada: ${CYAN}$LOG_DIR${NC}"
    echo -e "  Verifique permissões de arquivo!"
fi

echo ""
echo -e "${BLUE}Para visualizar os logs:${NC}"
echo -e "  ${CYAN}cat $LOG_FILE${NC}"
echo -e "  ${CYAN}tail -f $LOG_FILE${NC} (monitorar em tempo real)"
echo ""

# Mostrar resumo de erros (se houver)
show_error_summary

print_header "✨ SETUP COMPLETO!"

echo -e "${GREEN}═════════════════════════════════════════════════════════${NC}"
if [[ "$HAS_ERRORS" == true ]]; then
    echo -e "${YELLOW}  ⚠️  Instalação finalizada COM ERROS${NC}"
else
    echo -e "${GREEN}  ✓ Instalação finalizada com sucesso!${NC}"
fi
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

echo -e "${BLUE}📋 Logs e Progresso:${NC}"
echo "  • Log completo: $LOG_FILE"
echo "  • Progresso: $PROGRESS_FILE"
if [[ -f "$ERROR_LOG" ]]; then
    echo "  • Erros: $ERROR_LOG"
fi
echo ""
