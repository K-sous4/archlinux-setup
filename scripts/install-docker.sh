#!/bin/bash

################################################################################
# Script: install-docker.sh
# Descrição: Instala Docker e Docker Compose no Arch Linux / Manjaro
# Uso: bash scripts/install-docker.sh
# Requer: sudo
################################################################################

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de logging
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Função para verificar comando
command_exists() {
    command -v "$1" >/dev/null 2>&1
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

# Função para instalar pacote
install_package() {
    local package=$1
    
    log_info "Instalando $package..."
    
    if sudo pacman -S --noconfirm "$package" 2>/dev/null; then
        log_success "$package instalado com sucesso"
        return 0
    else
        log_error "Falha ao instalar $package"
        return 1
    fi
}

# Função para instalar Docker
install_docker() {
    log_info "Instalando Docker..."
    
    if command_exists docker; then
        log_warn "Docker já instalado: $(docker --version)"
        return 0
    fi
    
    # Instalar pacotes necessários
    install_package "docker" || {
        log_error "Falha ao instalar Docker"
        return 1
    }
    
    log_success "Docker instalado"
}

# Função para instalar Docker Compose
install_docker_compose() {
    log_info "Instalando Docker Compose..."
    
    if command_exists docker-compose; then
        log_warn "Docker Compose já instalado: $(docker-compose --version)"
        return 0
    fi
    
    # Tentar instalar via pacman (método preferido no Arch)
    install_package "docker-compose" || {
        log_warn "Docker Compose não disponível via pacman, instalando via pip..."
        
        # Instalar pip se necessário
        if ! command_exists pip; then
            install_package "python-pip" || {
                log_error "Falha ao instalar Python pip"
                return 1
            }
        fi
        
        # Instalar docker-compose via pip
        pip install --user docker-compose || {
            log_error "Falha ao instalar docker-compose via pip"
            return 1
        }
    }
    
    log_success "Docker Compose instalado"
}

# Função para iniciar e habilitar Docker
enable_docker() {
    log_info "Iniciando serviço Docker..."
    
    # Iniciar Docker
    sudo systemctl start docker || {
        log_error "Falha ao iniciar Docker"
        return 1
    }
    log_success "Docker iniciado"
    
    # Habilitar no boot
    sudo systemctl enable docker || {
        log_error "Falha ao habilitar Docker no boot"
        return 1
    }
    log_success "Docker habilitado no boot"
}

# Função para adicionar usuário ao grupo docker
add_user_to_docker() {
    local user=$USER
    
    log_info "Adicionando `$user` ao grupo docker..."
    
    # Criar grupo docker se não existe
    if ! getent group docker >/dev/null; then
        log_info "Criando grupo docker..."
        sudo groupadd docker || log_warn "Grupo docker pode já existir"
    fi
    
    # Adicionar usuário ao grupo
    sudo usermod -aG docker "$user" || {
        log_error "Falha ao adicionar usuário ao grupo docker"
        return 1
    }
    
    log_success "Usuário $user adicionado ao grupo docker"
    log_warn "IMPORTANTE: Faça logout e login para aplicar mudanças de grupo"
    log_warn "Ou execute: newgrp docker"
}

# Função para testar Docker
test_docker() {
    log_info "Testando Docker..."
    
    # Ativar grupo docker temporariamente
    newgrp docker <<EOF
docker ps 2>/dev/null && {
    log_success "Docker funcionando corretamente"
    return 0
} || {
    log_warn "Aguarde aplicação de permissões (execute: newgrp docker)"
    return 1
}
EOF
}

# Função para instalar buildx (opcional - para builds multi-arch)
install_buildx() {
    log_info "Instalar Docker Buildx (para builds multi-arquitectura)? (s/n)"
    read -r response
    
    if [[ "$response" =~ ^[Ss]$ ]]; then
        log_info "Instalando Docker Buildx..."
        
        install_package "docker-buildx" || {
            log_warn "Docker Buildx não disponível via pacman (opcional)"
        }
    fi
}

# Função principal
main() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Instalação do Docker & Docker Compose    ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # Verificar distribuição
    local distro=$(detect_distro)
    if [ "$distro" = "unknown" ]; then
        log_error "Distribuição não suportada. Use Arch Linux ou Manjaro."
        exit 1
    fi
    log_success "Distribuição detectada: $distro"
    echo ""
    
    # Verificar sudo
    if ! sudo -n true 2>/dev/null; then
        log_info "Você será pedido para inserir sua senha:"
        sudo -v || {
            log_error "Acesso sudo necessário"
            exit 1
        }
    fi
    echo ""
    
    # Instalar Docker
    install_docker || exit 1
    echo ""
    
    # Instalar Docker Compose
    install_docker_compose || exit 1
    echo ""
    
    # Iniciar Docker
    enable_docker || exit 1
    echo ""
    
    # Adicionar usuário ao grupo docker
    add_user_to_docker || exit 1
    echo ""
    
    # Instalar buildx (opcional)
    install_buildx
    echo ""
    
    # Informações finais
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}✓ Docker instalado com sucesso!${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    log_success "Versões instaladas:"
    docker --version
    docker-compose --version
    echo ""
    
    log_warn "IMPORTANTE: Você precisa fazer logout e login para usar Docker sem sudo"
    log_warn "Ou execute: newgrp docker"
    echo ""
    
    log_info "Próximas etapas:"
    echo "  1. Fazer logout/login ou executar: newgrp docker"
    echo "  2. Testar com: docker run hello-world"
    echo "  3. Opcional: bash scripts/install-portainer.sh (Portainer UI)"
    echo ""
}

# Executar
main "$@"
