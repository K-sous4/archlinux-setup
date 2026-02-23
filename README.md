# 🐧 Arch Linux Setup & Configuration Repository

Repositório para sincronizar e replicar configurações, aplicativos e dotfiles do Arch Linux entre diferentes máquinas.

## ⚡ Início Rápido (3 Passos!)

```bash
git clone https://github.com/K-sous4/archlinux-setup.git
cd archlinux-setup
chmod +x scripts/*.sh && bash scripts/auto-setup.sh
```

**O auto-setup.sh automaticamente:**
- ✅ Detecta Arch Linux ou Manjaro
- ✅ Remove bloatware (se Manjaro)
- ✅ Instala Alacritty + Zsh + Powerlevel10k
- ✅ Instala ferramentas modernas
- ✅ Restaura todas as configurações

Veja [AUTO_SETUP.md](AUTO_SETUP.md) para guia completo.

---

## 📋 Estrutura do Projeto

```
.
├── README.md                  # Este arquivo
├── AUTO_SETUP.md              # ⭐ Guia do auto-setup (comece aqui!)
├── .gitignore                 # Arquivos ignorados pelo git
├── scripts/                   # Scripts de automação
│   ├── auto-setup.sh          # ⭐ NOVO: Setup automático completo
│   ├── install-terminal.sh    # ⭐ NOVO: Instala Alacritty + Zsh + P10k
│   ├── debloat-manjaro.sh     # ⭐ NOVO: Remove bloatware do Manjaro
│   ├── export-packages.sh     # Exporta lista de packages instalados
│   ├── install-packages.sh    # Instala packages do arquivo
│   ├── backup-configs.sh      # Faz backup de configurações
│   ├── setup.sh               # Script principal de setup (menu)
│   └── README.md              # Documentação dos scripts
├── packages/                  # Listas de packages
│   ├── pacman-packages.txt    # Packages do pacman
│   ├── aur-packages.txt       # Packages do AUR
│   └── pip-packages.txt       # Packages do Python (pip)
├── dotfiles/                  # Arquivos de configuração do shell
│   ├── .bashrc.example
│   ├── .zshrc.example         # ✅ Atualizado com P10k
│   ├── .aliases.example       # ✅ Atualizado com aliases modernos
│   └── README.md
└── configs/                   # Configurações de aplicações
    ├── alacritty/             # ✅ NOVO: Config do Alacritty
    ├── neovim/
    ├── tmux/
    └── README.md
```

## 🚀 Novas Funcionalidades

### ⭐ Auto-Setup (Novo!)

Execute `auto-setup.sh` após clonar para:
- Detectar Arch Linux ou Manjaro automaticamente
- Opcionalmente remover bloatware (Manjaro)
- Instalar Alacritty + Zsh + Powerlevel10k
- Instalar ferramentas modernas (fzf, ripgrep, fd, bat, exa, etc)
- Restaurar todas as configurações
- Suporta tanto Arch quanto Manjaro

Veja [AUTO_SETUP.md](AUTO_SETUP.md) para detalhes completos.

### 🖥️ Terminal Moderno

Agora inclui setup completo de:
- **Alacritty** - Terminal GPU acelerado (mais rápido que tudo)
- **Zsh** - Shell moderno com plugins
- **Powerlevel10k** - Prompt visual criativo
- **Ferramentas**: fzf, ripgrep, fd, bat, exa, htop, neofetch

### 🧹 Debloat Manjaro

Script específico para remover bloatware do Manjaro:
- Thunderbird, Audacious, KDE extras, etc
- Mantém sistema limpo e responsivo

### No PC Original (para exportar configurações):

```bash
# Exportar lista de packages instalados
bash scripts/export-packages.sh

# Fazer backup de configurações
bash scripts/backup-configs.sh
```

### Em Novo PC (para restaurar setup):

```bash
# Clonar repositório
git clone https://github.com/seu-usuario/archlinux-setup.git
cd archlinux-setup

# Executar instalação completa
bash scripts/setup.sh
```

## 📦 Componentes Principais

### 1. **Packages** (`/packages`)
- **pacman-packages.txt**: Packages oficiais do Arch Linux
- **aur-packages.txt**: Packages do Arch User Repository
- **pip-packages.txt**: Pacotes Python

### 2. **Dotfiles** (`/dotfiles`)
Configurações de shell:
- `.bashrc` - Configuração do Bash
- `.zshrc` - Configuração do Zsh
- `.profile` - Variáveis de ambiente
- `.aliases` - Aliases customizados

### 3. **Configs** (`/configs`)
Compartilhamento de configurações de aplicações:
- Alacritty, Neovim, Tmux, etc.

## 🔧 Scripts

### `export-packages.sh`
Exporta todos os packages instalados para arquivos de texto:
```bash
bash scripts/export-packages.sh
```

### `install-packages.sh`
Instala packages a partir dos arquivos salvos:
```bash
bash scripts/install-packages.sh
```

### `backup-configs.sh`
Faz backup das configurações principais:
```bash
bash scripts/backup-configs.sh
```

### `setup.sh`
Script principal que automatiza todo o processo de setup em novo PC.

## 💡 Como Usar

### Adicionando novos dotfiles:
```bash
# Copie seu dotfile para a pasta
cp ~/.bashrc dotfiles/.bashrc

# Faça commit
git add dotfiles/.bashrc
git commit -m "Add .bashrc configuration"
git push
```

### Adicionando novas configurações de apps:
```bash
# Copie as configurações
cp -r ~/.config/alacritty configs/

# Faça commit
git add configs/alacritty
git commit -m "Add alacritty configuration"
git push
```

## 🔄 Fluxo de Sincronização

1. **Fazer Exportação** → `bash scripts/export-packages.sh`
2. **Revisar Mudanças** → `git status`
3. **Fazer Commit** → `git commit -m "Update packages and configs"`
4. **Push para Remoto** → `git push origin main`
5. **Em outro PC**: `git pull` e `bash scripts/setup.sh`

## ⚙️ Personalizações

Cada máquina pode ter ajustes específicos. Você pode:
- Manter arquivos separados por perfil (dev, server, desktop)
- Usar branches diferentes para configurações específicas
- Adicionar um arquivo `config-local.env` (adicionado ao .gitignore) para overrides

## 📝 Notas Importantes

- ⚠️ Revise sempre os packages antes de instalar em novo PC
- 🔐 Não commite senhas ou tokens (use .gitignore)
- 📱 Dotfiles são particulares - ajuste conforme necessário
- 🔄 Faça backup antes de aplicar mudanças significativas

## 🐛 Troubleshooting

### AUR Helper (yay/paru)
Se não tiver um AUR helper instalado:
```bash
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

### Permissões de Scripts
```bash
chmod +x scripts/*.sh
```

## 📚 Documentação

- [AUTO_SETUP.md](AUTO_SETUP.md) - ⭐ **Comece aqui!** Guia do auto-setup automático
- [INIT.md](INIT.md) - Guia de inicialização detalhada
- [QUICKSTART.md](QUICKSTART.md) - Início rápido (passo-a-passo)
- [WORKFLOW.md](WORKFLOW.md) - Fluxo de sincronização entre PCs
- [TERMINAL_SETUP.md](TERMINAL_SETUP.md) - Setup manual de Powerlevel10k
- [scripts/README.md](scripts/README.md) - Documentação de todos os scripts

# 🐧 Arch Linux / Manjaro Setup Repository

Automatize setup, configurações e sincronize aplicativos entre múltiplos PCs.

## ⚡ Início Rápido

```bash
git clone https://github.com/K-sous4/archlinux-setup.git
cd archlinux-setup
chmod +x scripts/*.sh && bash scripts/auto-setup.sh
```

O auto-setup detecta Arch/Manjaro, remove bloatware, instala Alacritty + Zsh + Powerlevel10k, e restaura tudo automaticamente.

---

## 📖 Documentação Única

**[SETUP.md](SETUP.md)** — Guia completo com todos os scripts, fluxos e troubleshooting

---

## 🎯 O Que Faz

- ✅ Auto-setup completo (1 comando)
- ✅ Terminal moderno (Alacritty + Zsh + Powerlevel10k)
- ✅ Debloat Manjaro (remove pré-instalados desnecessários)
- ✅ Gerenciar packages (exporte e sincronize entre PCs)
- ✅ Sincronizar dotfiles e configurações via Git

---

## 🚀 Comandos Principais

```bash
# Setup automático (recomendado)
bash scripts/auto-setup.sh

# Atalhos disponíveis
bash makefile.sh help           # Ver todos
bash makefile.sh export         # Exportar apps
bash makefile.sh install        # Instalar apps
bash makefile.sh commit         # Commit + push
bash makefile.sh status         # Ver mudanças
```

---

## 📁 Diretórios

- `scripts/` - Todos os scripts de automação
- `dotfiles/` - .bashrc, .zshrc, .aliases
- `configs/` - Configurações de aplicações (alacritty, etc)
- `packages/` - Listas de pacotes (pacman, aur, pip)

---

**Documentação completa:** [SETUP.md](SETUP.md)
