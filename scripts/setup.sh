#!/bin/bash

# Script principal de setup para novo PC com Arch Linux
# Este script automatiza o processo de instalação e configuração
# Uso: bash scripts/setup.sh

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções auxiliares
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}▶ $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Menu de opções
show_menu() {
    echo -e "\n${BLUE}Escolha o que deseja fazer:${NC}"
    echo "1) Instalação completa (packages + dotfiles + configs)"
    echo "2) Instalar apenas packages"
    echo "3) Restaurar apenas dotfiles"
    echo "4) Restaurar apenas configurações de apps"
    echo "5) Sair"
    echo ""
}

# ====================================
# INÍCIO DO SCRIPT
# ====================================

print_header "ARCH LINUX SETUP - Configuração de Novo PC"

echo -e "Data: $(date)"
echo -e "Usuário: $USER"
echo -e "Shell: $SHELL"
echo ""

# Verificar dependências
check_dependencies() {
    print_header "Verificando dependências"
    
    if ! command -v git &> /dev/null; then
        print_error "git não encontrado"
        exit 1
    fi
    print_success "git encontrado"
    
    if ! command -v pacman &> /dev/null; then
        print_error "pacman não encontrado - não está no Arch Linux?"
        exit 1
    fi
    print_success "pacman encontrado"
}

# Função para instalar packages
install_packages_func() {
    print_header "Instalando Packages"
    
    if ! sudo bash scripts/install-packages.sh; then
        print_error "Falha ao instalar packages"
        return 1
    fi
    print_success "Packages instalados com sucesso"
}

# Função para restaurar dotfiles
restore_dotfiles() {
    print_header "Restaurando Dotfiles"
    
    if [[ ! -d "dotfiles" ]]; then
        print_error "Diretório dotfiles não encontrado"
        return 1
    fi
    
    for dotfile in dotfiles/{.bashrc,.zshrc,.profile,.aliases,.bash_aliases,.tmux.conf,.dircolors}; do
        if [[ -f "$dotfile" ]]; then
            filename=$(basename "$dotfile")
            cp "$dotfile" "$HOME/$filename"
            print_success "Restaurado: $filename"
        fi
    done
}

# Função para restaurar configurações de apps
restore_configs() {
    print_header "Restaurando Configurações de Aplicações"
    
    if [[ ! -d "configs" ]]; then
        print_error "Diretório configs não encontrado"
        return 1
    fi
    
    mkdir -p "$HOME/.config"
    
    for config_dir in configs/*/; do
        if [[ -d "$config_dir" ]]; then
            app_name=$(basename "$config_dir")
            if [[ "$app_name" != "." && "$app_name" != ".." ]]; then
                mkdir -p "$HOME/.config/$app_name"
                cp -r "$config_dir"* "$HOME/.config/$app_name/" 2>/dev/null || true
                print_success "Restaurado: $app_name"
            fi
        fi
    done
}

# ====================================
# EXECUÇÃO PRINCIPAL
# ====================================

check_dependencies

# Menu interativo
while true; do
    show_menu
    read -p "Opção: " choice
    
    case $choice in
        1)
            print_header "INSTALAÇÃO COMPLETA"
            install_packages_func
            restore_dotfiles
            restore_configs
            print_success "Setup completo finalizado!"
            ;;
        2)
            install_packages_func
            ;;
        3)
            restore_dotfiles
            ;;
        4)
            restore_configs
            ;;
        5)
            print_warning "Saindo..."
            exit 0
            ;;
        *)
            print_error "Opção inválida"
            ;;
    esac
done
