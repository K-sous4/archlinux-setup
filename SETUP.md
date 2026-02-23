# 📖 Guia de Setup - Arch Linux / Manjaro

**Para setup rápido: execute `bash scripts/auto-setup.sh` após clonar**

---

## ⚡ Início Rápido (3 passos)

```bash
git clone https://github.com/K-sous4/archlinux-setup.git
cd archlinux-setup
chmod +x scripts/*.sh && bash scripts/auto-setup.sh
```

O script automaticamente:
- 🔍 Detecta Arch/Manjaro
- 🧹 Remove bloatware (Manjaro)
- 🖥️ Instala Alacritty + Zsh + Powerlevel10k
- 📦 Instala ferramentas modernas
- ⚙️ Restaura todas as configurações

---

## 📋 O Que Cada Script Faz

### `auto-setup.sh` ⭐ (Comece aqui!)
Script única parada que faz tudo. Detecta distribuição, remove bloatware se Manjaro, instala terminal moderno com Powerlevel10k, e restaura suas configs.

```bash
bash scripts/auto-setup.sh
```

**Tempo:** ~20-60 minutos (depende de internet e packages)

---

### `install-terminal.sh`
Instala independentemente: Alacritty, Zsh, Oh My Zsh, Powerlevel10k, plugins e ferramentas modernas.

```bash
sudo bash scripts/install-terminal.sh
```

**Instala:**
- Alacritty (terminal GPU acelerado)
- Zsh + Oh My Zsh
- Powerlevel10k (prompt visual)
- Plugins: syntax-highlighting, autosuggestions
- Ferramentas: fzf, ripgrep, fd, bat, exa, htop, neofetch

---

### `install-lunarvim.sh`
Instala LunarVim - um IDE Neovim com suporte multi-linguagem e keybindings similares ao VS Code.

```bash
bash scripts/install-lunarvim.sh
```

**Instala:**
- Neovim 0.9+ (se não estiver instalado)
- LunarVim (wrapper moderno do Neovim)
- Language servers (LSP) para 6 linguagens:
  - Python (pylsp)
  - Go (gopls)
  - C/C++ (clangd)
  - Java (jdtls)
  - TypeScript/JavaScript (tsserver)
  - Shell (bash-language-server)
- Formatadores: black, prettier, gofmt, clang-format
- Linters: flake8, eslint, shellcheck
- Plugins: Comment.nvim, GitHub Copilot, Colorizer, Trouble, Gitsigns
- DAP (Debug Adapter Protocol) para Python

**Keybindings VS Code-like:**
- `Ctrl+/` - Toggle comment
- `Ctrl+S` - Save file
- `F2` - Rename symbol
- `F12` - Go to definition
- `Shift+F12` - Show references
- `Alt+Up/Down` - Move line
- `Ctrl+Shift+K` - Delete line
- `Ctrl+D` - Multi-select word

Configure via `~/.config/nvim/config.lua` ou use comando `:LvimConfig`

---

### `check-prerequisites.sh`
Verifica e instala pré-requisitos essenciais do sistema antes de qualquer instalação.

```bash
bash scripts/check-prerequisites.sh
```

**Verifica:**
- Distribuição (Arch/Manjaro)
- Permissões sudo
- Conectividade internet
- Espaço em disco (mínimo 5GB)
- Variáveis de ambiente

**Instala (opcional):**
- Ferramentas essenciais: git, curl, wget, base-devel
- Ferramentas modernas: fzf, ripgrep, fd, bat, exa, htop, neofetch

**Use:** Sempre como primeiro script depois de clonar o repositório

---

### `install-docker.sh`
Instala Docker e Docker Compose para containerização.

```bash
bash scripts/install-docker.sh
```

**Instala:**
- Docker (engine)
- Docker Compose (orquestração)
- Docker Buildx (opcional - builds multi-arquitetura)
- Configura permissões de grupo

**Pós-instalação:**
```bash
# Aplique mudanças de grupo
newgrp docker

# Teste Docker
docker run hello-world
```

---

### `install-portainer.sh`
Instala Portainer - Interface web para gerenciar Docker containers.

```bash
bash scripts/install-portainer.sh
```

**Instala:**
- Portainer Community Edition (gratuito)
- Acesso HTTP em: `http://localhost:9000`
- Integração com Docker local
- Volume persistente para dados

**Recursos:**
- Dashboard visual
- Gerenciar containers, imagens, networks
- Deploy via docker-compose
- User management
- Event logs

**Primeira vez:**
1. Acesse http://localhost:9000
2. Crie usuário admin
3. Defina senha
4. Conecte ao Docker local

---

### `debloat-manjaro.sh`
Remove aplicações pré-instaladas do Manjaro: Thunderbird, Audacious, KDE extras, etc.

```bash
sudo bash scripts/debloat-manjaro.sh
```

⚠️ **Só para Manjaro** (Arch Linux não tem pré-instalados)

---

### `export-packages.sh`
Exporta lista de todos os packages instalados no seu PC.

```bash
bash scripts/export-packages.sh
```

**Gera:**
- `packages/pacman-packages.txt`
- `packages/aur-packages.txt`
- `packages/pip-packages.txt`
- `packages/npm-packages.txt`
- `packages/system-info.txt`

Use quando instalar novo package e quiser sincronizar com outro PC.

---

### `install-packages.sh`
Instala todos os packages salvos em outro PC.

```bash
sudo bash scripts/install-packages.sh
```

**Requer:** `packages/pacman-packages.txt` e AUR helper (yay ou paru)

---

### `backup-configs.sh`
Faz backup de suas configurações (dotfiles, configs de apps).

```bash
bash scripts/backup-configs.sh
```

**Copia:**
- Dotfiles: .bashrc, .zshrc, .profile, .aliases
- Configs de apps: alacritty, nvim, tmux, etc
- Info do sistema

---

### `setup.sh`
Menu interativo com opções granulares.

```bash
bash scripts/setup.sh
```

**Opções:**
1. Instalação completa (packages + dotfiles + configs)
2. Instalar apenas packages
3. Restaurar apenas dotfiles
4. Restaurar apenas configs de apps
5. Sair

---

## 🛠️ Atalhos (Makefile.sh)

Na raiz do repositório:

```bash
bash makefile.sh help           # Ver todos atalhos
bash makefile.sh export         # Exportar suas configs
bash makefile.sh install        # Instalar packages
bash makefile.sh setup          # Menu de setup
bash makefile.sh status         # Ver mudanças
bash makefile.sh commit         # Fazer commit + push
bash makefile.sh sync           # git pull
bash makefile.sh clean          # Limpar temporários
```

---

## 📁 Estrutura do Repositório

```
archlinux-setup/
├── README.md                   # Overview e links
├── SETUP.md                    # Este arquivo - guia completo
├── makefile.sh                 # Atalhos para comandos
├── scripts/
│   ├── check-prerequisites.sh  # ⭐ Verificar pré-requisitos primeiro
│   ├── auto-setup.sh           # Campo unificado (terminal + config)
│   ├── install-terminal.sh     # Instala Alacritty + Zsh + P10k
│   ├── install-lunarvim.sh     # Instala LunarVim IDE
│   ├── install-docker.sh       # Instala Docker + Docker Compose
│   ├── install-portainer.sh    # Instala Portainer UI
│   ├── debloat-manjaro.sh      # Remove bloatware Manjaro
│   ├── export-packages.sh      # Exporta packages
│   ├── install-packages.sh     # Instala packages
│   ├── backup-configs.sh       # Faz backup
│   ├── setup.sh                # Menu interativo
│   └── README.md               # Docs de scripts
├── packages/                   # Listas de apps
│   ├── pacman-packages.txt
│   ├── aur-packages.txt
│   └── pip-packages.txt
├── dotfiles/                   # Configs de shell
│   ├── .bashrc.example
│   ├── .zshrc.example
│   └── .aliases.example
└── configs/                    # Configs de aplicações
    ├── alacritty/
    │   └── alacritty.toml
    ├── lunarvim/
    │   ├── config.lua
    │   └── README.md
    └── portainer/              # Configs Portainer
        └── docker-compose.yml
```


---

## 🔄 Fluxos de Uso

### Cenário 1: Novo PC (Recomendado)

```bash
git clone https://github.com/K-sous4/archlinux-setup.git
cd archlinux-setup
chmod +x scripts/*.sh
bash scripts/auto-setup.sh      # Uma linha faz tudo!
```

**Resultado:** Terminal moderno + todas as suas configs

---

### Cenário 2: Setup Manual (Se preferir controlar)

```bash
chmod +x scripts/*.sh

# 1. Instalar terminal moderno (Alacritty + Zsh + P10k)
sudo bash scripts/install-terminal.sh

# 2. Se Manjaro: remover bloatware
sudo bash scripts/debloat-manjaro.sh

# 3. Instalar suas apps
sudo bash scripts/install-packages.sh

# 4. Restaurar configs
bash scripts/setup.sh           # Escolha opção 1
```

---

### Cenário 3: Sincronizar de Outro PC

```bash
# PC 1 (seu PC atual):
bash makefile.sh export         # Exporta suas apps
bash makefile.sh status         # Revisa mudanças
bash makefile.sh commit         # Commit + push

# PC 2 (novo PC):
git pull
sudo bash scripts/install-packages.sh
```

---

### Cenário 4: Setup com Docker & Portainer

```bash
chmod +x scripts/*.sh

# 1. Verificar pré-requisitos (primeiro!)
bash scripts/check-prerequisites.sh

# 2. Terminal moderno (opcional)
sudo bash scripts/install-terminal.sh

# 3. LunarVim IDE (opcional)
bash scripts/install-lunarvim.sh

# 4. Docker & Docker Compose
bash scripts/install-docker.sh
newgrp docker                   # Aplicar mudanças de grupo

# 5. Portainer UI (opcional)
bash scripts/install-portainer.sh

# 6. Acessar Portainer
# Abra: http://localhost:9000 no navegador
```

**Resultado:** Terminal moderno + Docker + Portainer UI

---

## ⚙️ Customizações

### Powerlevel10k
```bash
p10k configure                  # Assistente visual
# ou edite ~/.p10k.zsh manualmente
```

### Instalar Nerd Font (para ícones)
```bash
cd ~/Downloads
curl -LOJ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip
mkdir -p ~/.local/share/fonts
cp *.ttf ~/.local/share/fonts/
fc-cache -fv
```

### Adicionar mais apps ao debloat
Edite `scripts/debloat-manjaro.sh` e adicione à array `BLOATWARE`:

```bash
BLOATWARE=(
    "seu-app-aqui"
    "outro-app"
)
```

---

## 🆘 Troubleshooting

| Problema | Solução |
|----------|---------|
| Scripts não executam | `chmod +x scripts/*.sh` então `bash script.sh` |
| Zsh não é padrão após reboot | `chsh -s /usr/bin/zsh` |
| Powerlevel10k mostra `?` | Instale Nerd Font (veja acima) |
| AUR helper não instalado | `git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si` |
| Terminal lento | Reduza plugins em `~/.zshrc` |
| Alacritty não encontrado | `sudo pacman -S alacritty` |
| LunarVim: LSP não aparece | Execute `bash scripts/install-lunarvim.sh` novamente |
| LunarVim: Keybindings não funcionam | Reinicie Neovim com `:qa` e `nvim` novamente |
| LunarVim: Formatador não funciona | Cheque instalação com `:Mason` dentro do Neovim |
| LunarVim: Copilot não ativa | Autentique com `:Copilot auth` |
| Docker: Comando não reconhecido | Faça logout/login ou execute: `newgrp docker` |
| Docker: Permissão denied ao usar docker | Adicione usuário ao grupo: `sudo usermod -aG docker $USER` |
| Docker: Docker daemon não inicia | Inicie com: `sudo systemctl start docker` |
| Portainer: Não acessa http://localhost:9000 | Aguarde 30s para inicializar, verifique com: `docker ps` |
| Portainer: Container parou | Reinicie com: `docker start portainer` |

---

## 📦 Packages Instalados (Padrão)

### Essenciais (auto-setup instala)
- `zsh` - Shell interativo
- `oh-my-zsh-git` - Framework shell
- `powerlevel10k` - Prompt visual
- `alacritty` - Terminal GPU
- `zsh-syntax-highlighting` - Highlighting
- `zsh-autosuggestions` - Autocompletar
- `fzf` - Fuzzy finder
- `ripgrep` - Grep moderno
- `fd` - Find moderno
- `bat` - Cat com highlighting
- `exa` - Ls moderno
- `htop` - Monitor processos
- `neofetch` - Info sistema

### Customizar
Edite `packages/pacman-packages.txt` ou `packages/aur-packages.txt` antes de instalar, ou adicione/remova conforme necessário.

---

## 🔒 Segurança

❌ **Nunca commite:**
- Senhas, tokens, chaves
- `.ssh/` ou `.gnupg/`
- Paths locais específicos

✅ **Adicionado ao .gitignore:**
```
.env
.env.local
config-local.env
*.key
.ssh/
.gnupg/
```

---

## 📊 Tempos Típicos

| Etapa | Tempo |
|-------|-------|
| Clone + chmod | ~1 min |
| Debloat Manjaro | 2-5 min |
| Atualização sistema | 5-15 min |
| Terminal setup | 5-10 min |
| Packages | 10-60 min* |
| **Total** | **~25-90 min** |

*Depende da internet e quantidade de packages

---

## 📱 Para Múltiplos PCs

Mantenha sincronizados:

```bash
# Quando instala novo app:
bash makefile.sh export && bash makefile.sh commit

# Em outro PC:
git pull && sudo bash scripts/install-packages.sh
```

---

## 🚀 Pronto!

Seu Manjaro/Arch Linux agora tem:
- ✅ **Alacritty** - Terminal rápido
- ✅ **Zsh + Powerlevel10k** - Shell moderno bonito
- ✅ **Ferramentas modernas** - fzf, ripgrep, exa, etc
- ✅ **Configurações sincronizadas** - Entre múltiplos PCs
- ✅ **LunarVim IDE** - Neovim com suporte Python, Go, C++, Java, Node.js/Next.js (opcional)
- ✅ **Docker & Docker Compose** - Containerização (opcional)
- ✅ **Portainer** - Interface web para Docker (opcional)

**Aproveite seu terminal, IDE e plataforma de containerização! 🎉**

---

**GitHub:** https://github.com/K-sous4/archlinux-setup
