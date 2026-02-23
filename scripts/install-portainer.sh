#!/bin/bash

################################################################################
# Script: install-portainer.sh
# Descrição: Instala Portainer - Interface web para gerenciar Docker
# Uso: bash scripts/install-portainer.sh
# Requer: Docker já instalado e rodando
# Acesso: http://localhost:9000 (padrão)
################################################################################

set -e

# ====================================
# INICIALIZAR LOGGING
# ====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_logging.sh" 2>/dev/null || true

log "INFO" "═══════════════════════════════════════════════════════════"
log "INFO" "INICIANDO: install-portainer.sh"
log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "═══════════════════════════════════════════════════════════"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Funções de logging
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
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_highlight() {
    echo -e "${MAGENTA}→${NC} $1"
}

# Função para verificar comando
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para verificar Docker
check_docker() {
    log_info "Verificando Docker..."
    
    if ! command_exists docker; then
        log_error "Docker não instalado. Execute: bash scripts/install-docker.sh"
        exit 1
    fi
    log_success "Docker instalado"
    
    # Verificar se Docker está rodando
    if ! docker ps &>/dev/null; then
        log_error "Docker não está rodando. Inicie com: sudo systemctl start docker"
        exit 1
    fi
    log_success "Docker rodando"
}

# Função para verificar Portainer existente
check_existing_portainer() {
    log_info "Verificando Portainer existente..."
    
    # Verificar se container existe
    if docker ps -a --format '{{.Names}}' | grep -q "^portainer$"; then
        log_warn "Container Portainer já existe"
        
        log_info "O que fazer?"
        echo "  1) Remover e reinstalar"
        echo "  2) Manter existente"
        read -r choice
        
        case $choice in
            1)
                log_info "Removendo Portainer existente..."
                docker stop portainer 2>/dev/null || true
                docker rm portainer 2>/dev/null || true
                log_success "Portainer removido"
                ;;
            2)
                log_info "Mantendo Portainer existente"
                docker start portainer || true
                return 1  # Sinaliza que já existe
                ;;
            *)
                log_error "Opção inválida"
                exit 1
                ;;
        esac
    fi
    
    return 0
}

# Função para criar volume Portainer
create_volume() {
    log_info "Criando volume Portainer..."
    
    if docker volume ls | grep -q portainer_data; then
        log_warn "Volume portainer_data já existe"
    else
        docker volume create portainer_data || {
            log_error "Falha ao criar volume"
            exit 1
        }
        log_success "Volume portainer_data criado"
    fi
}

# Função para fazer pull da imagem Portainer
pull_portainer_image() {
    log_info "Fazendo pull da imagem Portainer..."
    
    local portainer_image="portainer/portainer-ce:latest"
    
    docker pull "$portainer_image" || {
        log_error "Falha ao baixar Portainer"
        exit 1
    }
    
    log_success "Imagem Portainer baixada"
}

# Função para instalar Portainer community edition
install_portainer_ce() {
    log_info "Instalando Portainer Community Edition..."
    
    docker run -d \
        --name portainer \
        --restart=always \
        -p 8000:8000 \
        -p 9000:9000 \
        -p 9443:9443 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer-ce:latest || {
        log_error "Falha ao iniciar container Portainer"
        return 1
    }
    
    log_success "Portainer iniciando..."
}

# Função para instalar Portainer business edition (opcional)
install_portainer_be() {
    log_info "Portainer Business Edition (pago - precisa de licença)?"
    read -r choice
    
    if [[ "$choice" =~ ^[Ss]$ ]]; then
        log_info "Removendo Portainer CE..."
        docker stop portainer 2>/dev/null || true
        docker rm portainer 2>/dev/null || true
        
        log_info "Fazendo pull de Portainer BE..."
        docker pull portainer/portainer:latest || {
            log_error "Falha ao baixar Portainer BE"
            return 1
        }
        
        log_info "Instalando Portainer BE..."
        docker run -d \
            --name portainer \
            --restart=always \
            -p 8000:8000 \
            -p 9000:9000 \
            -p 9443:9443 \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer_data:/data \
            portainer/portainer:latest || {
            log_error "Falha ao iniciar Portainer BE"
            return 1
        }
        
        log_success "Portainer BE instalado"
    fi
}

# Função para aguardar Portainer iniciar
wait_for_portainer() {
    log_info "Aguardando Portainer iniciar..."
    
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s http://localhost:9000 >/dev/null 2>&1; then
            log_success "Portainer iniciado com sucesso!"
            return 0
        fi
        
        attempt=$((attempt + 1))
        echo -ne "\r  Tentativa $attempt/$max_attempts..."
        sleep 1
    done
    
    echo ""
    log_warn "Portainer pode estar ainda inicializando (tente novamente em alguns segundos)"
}

# Função para exibir informações de acesso
show_access_info() {
    log_info "Portainer está acessível em:"
    echo ""
    log_highlight "Web Interface: http://localhost:9000"
    log_highlight "HTTPS (opcional): https://localhost:9443"
    log_highlight "Edge Agent Port: localhost:8000"
    echo ""
    
    log_info "Instrução de primeira vez:"
    echo "  1. Abra http://localhost:9000 no navegador"
    echo "  2. Crie usuário admin"
    echo "  3. Defina senha"
    echo "  4. Conecte ao Docker local"
    echo ""
}

# Função para criar docker-compose.yml
create_docker_compose_file() {
    log_info "Criar arquivo docker-compose.yml? (s/n)"
    read -r response
    
    if [[ "$response" =~ ^[Ss]$ ]]; then
        local compose_file="${PWD}/configs/portainer/docker-compose.yml"
        
        mkdir -p "$(dirname "$compose_file")"
        
        cat > "$compose_file" <<'EOF'
version: '3.8'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    security_opt:
      - no-new-privileges:true
    networks:
      - portainer
    ports:
      - "8000:8000"
      - "9000:9000"
      - "9443:9443"
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - portainer_data:/data
    environment:
      - "TZ=America/Sao_Paulo"  # Ajuste conforme necessário
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"

networks:
  portainer:
    driver: bridge

volumes:
  portainer_data:
    driver: local
EOF
        
        log_success "docker-compose.yml criado em: $compose_file"
        
        log_info "Usar docker-compose.yml para iniciar? (s/n)"
        read -r use_compose
        
        if [[ "$use_compose" =~ ^[Ss]$ ]]; then
            log_info "Parando container Portainer anterior..."
            docker stop portainer 2>/dev/null || true
            docker rm portainer 2>/dev/null || true
            
            log_info "Iniciando Portainer via docker-compose..."
            cd "$(dirname "$compose_file")"
            docker-compose up -d || {
                log_error "Falha ao iniciar com docker-compose"
                return 1
            }
            
            log_success "Portainer iniciado via docker-compose"
        fi
    fi
}

# Função principal
main() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║        Instalação do Portainer          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # Verificar Docker
    check_docker
    echo ""
    
    # Verificar Portainer existente
    if ! check_existing_portainer; then
        log_info "Portainer já em execução"
        show_access_info
        exit 0
    fi
    echo ""
    
    # Criar volume
    create_volume
    echo ""
    
    # Pull imagem
    pull_portainer_image
    echo ""
    
    # Instalar Portainer CE
    if ! install_portainer_ce; then
        log_error "Falha na instalação do Portainer"
        exit 1
    fi
    echo ""
    
    # Perguntar sobre Portainer BE (opcional)
    install_portainer_be
    echo ""
    
    # Aguardar inicialização
    wait_for_portainer
    echo ""
    
    # Exibir informações
    show_access_info
    
    # Criar docker-compose.yml (opcional)
    create_docker_compose_file
    echo ""
    
    # Resumo final
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}✓ Portainer instalado com sucesso!${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    log_info "Status do container:"
    docker ps --filter "name=portainer" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
}

# Executar
main "$@"
