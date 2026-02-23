#!/bin/bash

# Script para instalar e configurar LunarVim
# LunarVim é um Neovim IDE pré-configurado baseado em Neovim
# Instalação rápida com suporte para Python, Go, C++, Java, Node.js/Next.js
# Uso: bash scripts/install-lunarvim.sh

set -e

# ====================================
# INICIALIZAR LOGGING
# ====================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_logging.sh" 2>/dev/null || true

log "INFO" "Iniciando: install-lunarvim.sh"
log "INFO" "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"

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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
    log "INFO" "$1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# ====================================
# COMEÇAR
# ====================================

print_header "LunarVim - IDE Neovim Configurado"

echo -e "${YELLOW}Pré-requisitos:${NC}"
echo "  • Neovim 0.9+ (será instalado se necessário)"
echo "  • Git"
echo "  • Node.js (para LSP)"
echo ""

# Verificar Neovim
if ! command -v nvim &> /dev/null; then
    print_warning "Neovim não encontrado, instalando..."
    sudo pacman -S --noconfirm neovim
    print_success "Neovim instalado"
else
    NVIM_VERSION=$(nvim --version | head -1)
    print_success "Neovim encontrado: $NVIM_VERSION"
fi

# ====================================
# INSTALAR LUNARVIM
# ====================================

print_header "Instalando LunarVim"

if [[ -d ~/.config/lvim ]]; then
    print_warning "LunarVim já está instalado"
    read -p "Deseja reinstalar? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_info "Pulando instalação do LunarVim"
    else
        bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/rolling/utils/installer/install.sh)
        print_success "LunarVim reinstalado"
    fi
else
    print_info "Instalando LunarVim..."
    bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/rolling/utils/installer/install.sh)
    print_success "LunarVim instalado"
fi

# ====================================
# INSTALAR LANGUAGE SERVERS (LSP)
# ====================================

print_header "Instalando Language Servers"

LSP_TOOLS=(
    "python-lsp-server:Python LSP"
    "gopls:Go LSP"
    "clangd:C++ LSP"
    "jdtls:Java LSP"
)

# Via npm (Node.js)
NPM_TOOLS=(
    "typescript"
    "typescript-language-server"
    "prettier"
    "@vue/language-server"
)

# Python
if command -v pip &> /dev/null; then
    print_info "Instalando Python LSP..."
    pip install python-lsp-server pylsp-mypy pylsp-rope --user
    print_success "Python LSP instalado"
else
    print_warning "pip não encontrado, pulando Python LSP"
fi

# Go
if ! pacman -Q gopls &> /dev/null 2>&1; then
    print_info "Instalando Go LSP (gopls)..."
    sudo pacman -S --noconfirm gopls
    print_success "gopls instalado"
else
    print_success "gopls já instalado"
fi

# C/C++
if ! pacman -Q clang &> /dev/null 2>&1; then
    print_info "Instalando Clangd (C/C++ LSP)..."
    sudo pacman -S --noconfirm clang
    print_success "clang instalado"
else
    print_success "clang já instalado"
fi

# Java (JDTLS)
if ! pacman -Q jdtls &> /dev/null 2>&1; then
    print_info "Instalando JDTLS (Java LSP)..."
    sudo pacman -S --noconfirm jdtls
    print_success "jdtls instalado"
else
    print_success "jdtls já instalado"
fi

# Node.js/TypeScript
if command -v npm &> /dev/null; then
    print_info "Instalando TypeScript/Node.js tools..."
    npm install -g typescript typescript-language-server prettier @vue/language-server 2>/dev/null || true
    print_success "TypeScript tools instalados"
else
    print_warning "npm não encontrado, pulando Node.js tools"
fi

# ====================================
# INSTALAR FORMATTERS
# ====================================

print_header "Instalando Formatters & Tools"

# Black (Python formatter)
pip install black isort --user 2>/dev/null || print_warning "Black não pôde ser instalado"

# Prettier (JS/TS/HTML/CSS formatter)
npm install -g prettier 2>/dev/null || print_warning "Prettier não pôde ser instalado"

# Go formatter (gofmt built-in)
print_success "Go format: gofmt (built-in)"

# Clang format (C/C++)
sudo pacman -S --noconfirm clang 2>/dev/null || true

# Java formatter
# Instalado com jdtls

print_success "Formatters instalados"

# ====================================
# COPIAR CONFIGURAÇÃO
# ====================================

print_header "Configurando LunarVim"

LVIM_CONFIG_DIR=~/.config/lvim

if [[ -f "configs/lunarvim/config.lua" ]]; then
    print_info "Copiando configuração customizada..."
    cp configs/lunarvim/config.lua "$LVIM_CONFIG_DIR/" 2>/dev/null || print_warning "Não foi possível copiar config, usando padrão"
    print_success "Configuração copiada"
else
    print_info "Criando arquivo de configuração customizado..."
    mkdir -p "$LVIM_CONFIG_DIR"
    
    # Criar configuração padrão se não existir
    if [[ ! -f "$LVIM_CONFIG_DIR/config.lua" ]]; then
        cat > "$LVIM_CONFIG_DIR/config.lua" << 'EOF'
-- LunarVim Configuration
-- Otimizado para: Python, Go, C++, Java, Node.js/Next.js
-- Keybindings similares ao VS Code

-- General Settings
lvim.log.level = "warn"
lvim.colorscheme = "onedarker"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.linebreak = true

-- VS Code-like settings
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.guifont = "JetBrains Mono:h12"

-- Keybindings similares ao VS Code
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Ctrl+/ para comentar
keymap("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", opts)
keymap("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", opts)

-- Ctrl+S para salvar
keymap("n", "<C-s>", ":w<CR>", opts)
keymap("i", "<C-s>", "<Esc>:w<CR>", opts)

-- Ctrl+D para selecionar palavra
keymap("n", "<C-d>", "*", opts)

-- Alt+Up/Down para mover linhas
keymap("n", "<A-Up>", ":m-2<CR>", opts)
keymap("n", "<A-Down>", ":m+1<CR>", opts)
keymap("v", "<A-Up>", ":m-2<CR>gv", opts)
keymap("v", "<A-Down>", ":m+1<CR>gv", opts)

-- Ctrl+Shift+K para deletar linha
keymap("n", "<C-S-k>", "dd", opts)

-- Ctrl+L para selecionar linha
keymap("n", "<C-l>", "V", opts)

-- F12 para ir para definição
keymap("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

-- F2 para renomear
keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

-- LSP Configuration
local function setup_lsp()
    local mason_config = require("lvim.lsp.manager")
    
    -- Python
    mason_config:setup("pylsp", {
        cmd = {"pylsp"},
        settings = {
            pylsp = {
                configurationSources = {"flake8"},
                plugins = {
                    pycodestyle = { enabled = false },
                    mccabe = { enabled = false },
                    flake8 = { enabled = true },
                    pylint = { enabled = false },
                    mypy = { enabled = true },
                }
            }
        }
    })
    
    -- Go
    mason_config:setup("gopls", {
        cmd = {"gopls"},
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            }
        }
    })
    
    -- C/C++
    mason_config:setup("clangd", {
        cmd = {"clangd"},
    })
    
    -- Java
    mason_config:setup("jdtls", {
        cmd = {"jdtls"},
    })
    
    -- TypeScript/JavaScript
    mason_config:setup("tsserver", {
        cmd = {"typescript-language-server", "--stdio"},
    })
end

setup_lsp()

-- Formatters
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
    { name = "black" },           -- Python
    { name = "prettier" },         -- JS/TS/HTML/CSS
    { name = "gofmt" },           -- Go
    { name = "clang_format" },    -- C/C++
})

-- Linters
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
    { name = "flake8" },          -- Python
    { name = "shellcheck" },      -- Shell
    { name = "eslint" },          -- JavaScript/TypeScript
})

-- Plugins úteis
lvim.plugins = {
    { "folke/trouble.nvim" },
    { "github/copilot.vim" },
    { "norcalli/nvim-colorizer.lua" },
}

-- Copilot setup (opcional)
-- Descomente para usar GitHub Copilot
-- vim.cmd("Copilot setup")
EOF
        print_success "Arquivo de configuração criado"
    fi
fi

# ====================================
# INSTALAR PLUGINS
# ====================================

print_header "Sincronizando Plugins"

print_info "Iniciando LunarVim para sincronizar plugins (pode levar alguns minutos)..."
timeout 30 nvim --headless -c "LvimUpdate" +q 2>/dev/null || true

print_success "LunarVim atualizado"

# ====================================
# FINALIZAÇÃO
# ====================================

print_header "✨ LunarVim Instalado e Configurado!"

echo -e "${GREEN}Pronto para usar!${NC}"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo "  1. Abra LunarVim: ${BLUE}lvim${NC}"
echo "  2. Customizações adicionais: ${BLUE}nano ~/.config/lvim/config.lua${NC}"
echo "  3. Instale plugins: ${BLUE}:PackerSync${NC} (dentro do LunarVim)"
echo ""
echo -e "${YELLOW}Atalhos VS Code-like:${NC}"
echo "  • Ctrl+/     → Comentar linha"
echo "  • Ctrl+S     → Salvar"
echo "  • Ctrl+D     → Selecionar palavra"
echo "  • Alt+↑/↓    → Mover linha"
echo "  • Ctrl+Shift+K → Deletar linha"
echo "  • F12        → Ir para definição"
echo "  • F2         → Renomear"
echo "  • Ctrl+P     → Procurar arquivo"
echo "  • Ctrl+Shift+P → Command palette"
echo ""
echo -e "${YELLOW}Suportado:${NC}"
echo "  ✓ Python        (pylsp, black, flake8)"
echo "  ✓ Go            (gopls, gofmt)"
echo "  ✓ C/C++         (clangd, clang-format)"
echo "  ✓ Java          (jdtls)"
echo "  ✓ Node.js/TS    (tsserver, prettier)"
echo "  ✓ GitHub Copilot (opcional, descomente em config)"
echo ""

print_success "Setup completo! 🎉"
