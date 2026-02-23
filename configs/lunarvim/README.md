# 📝 LunarVim Configuration

Configuração customizada do LunarVim otimizada para múltiplas linguagens e experiência similar ao VS Code.

## 📋 Linguagens Suportadas

- ✅ **Python** - pylsp, black, flake8, mypy
- ✅ **Go** - gopls, gofmt, staticcheck
- ✅ **C/C++** - clangd, clang-format
- ✅ **Java** - jdtls
- ✅ **Node.js/TypeScript** - tsserver, prettier, eslint
- ✅ **Shell** - shellcheck

## 🎮 Keybindings VS Code-like

### Edição
| Atalho | Ação |
|--------|------|
| `Ctrl+/` | Comentar/descomenttar linha |
| `Ctrl+S` | Salvar arquivo |
| `Ctrl+Z` | Desfazer |
| `Ctrl+Y` | Refazer |
| `Ctrl+X` | Cortar |
| `Ctrl+C` | Copiar |
| `Ctrl+V` | Colar |
| `Alt+↑/↓` | Mover linha para cima/baixo |
| `Ctrl+Shift+K` | Deletar linha |
| `Ctrl+L` | Selecionar linha |
| `Ctrl+A` | Selecionar tudo |
| `Ctrl+H` | Find & replace |
| `Ctrl+F` | Find no arquivo |

### Navegação
| Atalho | Ação |
|--------|------|
| `Ctrl+P` | Procurar arquivo (Telescope) |
| `Ctrl+Shift+F` | Procurar em archivos (grep) |
| `Ctrl+Shift+E` | File explorer |
| `Ctrl+B` | Toggle sidebar |
| `Ctrl+`` | Terminal toggle |
| `Ctrl+Shift+`` | Novo terminal |

### LSP (Language Server)
| Atalho | Ação |
|--------|------|
| `K` | Hover (informações) |
| `F12` | Ir para definição |
| `Ctrl+K` `Ctrl+I` | Signature help |
| `GR` | Referências |
| `GI` | Implementação |
| `F2` | Renomear símbolo |
| `Ctrl+K` `Ctrl+X` | Code actions |
| `GE` | Ver erro |

## 🚀 Como Usar

### Instalation

```bash
sudo bash scripts/install-lunarvim.sh
```

### Iniciar LunarVim

```bash
lvim
# ou
nvim
```

### Comandos Customizados

```bash
# Executar arquivo Python
:Python

# Executar arquivo Go
:GoRun

# Executar projeto Node.js
:NodeRun
```

## 📦 Plugins Principais

- **Comment.nvim** - Comentário
- **GitHub Copilot** - IA assistente (opcional)
- **Colorizer** - Visualizar cores
- **Trouble** - Diagnósticos
- **Gitsigns** - Git integration
- **Vim-surround** - Manipular delimitadores
- **Indent-blankline** - Mostrar indentação

## 🗂️ Estrutura de Pastas Recomendada

```
projeto/
├── .python-version          # Python version (pyenv)
├── .nvmrc                   # Node version
├── backend/                 # Go/Python backend
├── frontend/                # Next.js/React frontend
├── .lunarvim/              # Configs locais (opcional)
└── init.lua                # Override de config local
```

## 🎯 Atalhos Úteis do LunarVim

Além dos VS Code-like:

- `:Mason` - Gerenciar LSPs e formatters
- `:Telescope commands` - Ver todos os comandos
- `:Trouble` - Ver diagnósticos
- `:set number rnu` - Número relativo de linhas
- `:set wrap/nowrap` - Toggle wrap

## 📍 Troubleshooting

### "LSP not attached"
```bash
:LspInfo
# Verificar se LSP está ativo
```

### Formatação não funciona
```bash
:NullLsInfo
# Verificar se formatters estão instalados
```

### Plugin não está carregando
```bash
:PackerSync
# Dentro do LunarVim para sincronizar plugins
```

### Problema com shortcut no terminal
```
# Pode ser conflito com terminal. Tente em tty puro ou adicione em config:
vim.cmd("let g:skip_default_keybindings = 1")
```

## 💾 Configurar Setup Local

Para sobrescrever configs por projeto:

```bash
# Criar arquivo local
mkdir -p .lvim
cat > .lvim/init.lua << 'EOF'
-- Seu override aqui
vim.opt.shiftwidth = 2  -- JavaScript usa 2 espaços
EOF

# Adicione ao .gitignore:
echo ".lvim/" >> .gitignore
```

## 🆘 Reset para Padrão

Se quiser reverter para configuração padrão:

```bash
rm -rf ~/.config/lvim/config.lua
# LunarVim restaurará padrão na próxima execução
```

## 📚 Referências

- [LunarVim Docs](https://www.lunarvim.org/)
- [Neovim Keybindings](https://neovim.io/)
- [LSP Servers](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
