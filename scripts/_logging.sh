#!/bin/bash

# ====================================
# BIBLIOTECA DE LOGGING COMPARTILHADA
# ====================================
# Arquivo auxiliar para logging em subscripts
#
# Uso:
#   source "scripts/_logging.sh"
#   log "INFO" "Mensagem"
#   log "SUCCESS" "Sucesso!"
#   log "ERROR" "Erro!"
#   log "WARNING" "Aviso!"
#
# Variáveis esperadas (definidas por auto-setup.sh):
#   - LOG_FILE: Caminho do arquivo de log
#   - LOG_DIR: Diretório de logs

# Se LOG_FILE não foi definido, criar função de log simples
if [[ -z "$LOG_FILE" ]]; then
    log() {
        local level=$1
        shift
        local message="$@"
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$timestamp] [$level] $message"
    }
else
    # Logger completo que grava em arquivo
    log() {
        local level=$1
        shift
        local message="$@"
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
    }
fi

# Cores para output (apenas terminal, não no log)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Funções auxiliares com cores
log_success() {
    echo -e "${GREEN}✓${NC} $*"
    log "SUCCESS" "$*"
}

log_error() {
    echo -e "${RED}✗${NC} $*"
    log "ERROR" "$*"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $*"
    log "WARNING" "$*"
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $*"
    log "INFO" "$*"
}

# Função para executar comando e logar
run_command() {
    local description=$1
    shift
    local command="$@"
    
    log_info "Executando: $description"
    log "DEBUG" "Comando: $command"
    
    if eval "$command" >> "$LOG_FILE" 2>&1; then
        log_success "$description completado"
        return 0
    else
        local exit_code=$?
        log_error "$description falhou (exit code: $exit_code)"
        return $exit_code
    fi
}

# Setup completado
log "INFO" "Logger inicializado (LOG_FILE=$LOG_FILE)"
