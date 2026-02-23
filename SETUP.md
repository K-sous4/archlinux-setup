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
- 🔍 Verifica pré-requisitos do sistema
- 🔍 Detecta Arch/Manjaro
- 🧹 Remove bloatware (Manjaro)
- 🖥️ Instala Alacritty + Zsh + Powerlevel10k
- 📦 Instala ferramentas modernas
- ⚙️ Restaura todas as configurações
- 📊 Gera log completo em `.setup-logs/`

**Tempo:** ~30-90 minutos (depende de internet e packages)

---

### ⚠️ Sobre Permissões e Sudo

**NOVO: Modo Automático (Padrão)**

O script agora roda em **modo automático** por padrão:
- ✅ Instala TUDO na primeira execução
- ✅ Sem perguntas interativas
- ❌ Sem `sudo` inicial (pede senha apenas quando necessário)
- 📝 Captura e exibe erros detalhados

**Responda do jeito que fizer sentido para você:**

1. **Opção 1 (Recomendado): Modo automático (PADRÃO)**
   ```bash
   chmod +x scripts/*.sh
   bash scripts/auto-setup.sh
   ```
   - ✅ Instala TUDO automaticamente (debloat, packages, terminal, configs)
   - ✅ Pede senha quando necessário (1-2 vezes)
   - 📊 Diferencia erros críticos de warnings
   - 🔴 Se encontrar erro, exibe output detalhado

2. **Opção 2: Modo interativo (perguntas)**
   ```bash
   chmod +x scripts/*.sh
   INSTALL_ALL=false bash scripts/auto-setup.sh
   ```
   - ❓ Pergunta antes de cada operação (debloat? packages?)
   - ✅ Você controla o que instala
   - ⏱️ Mais lento (por causa das perguntas)

3. **Opção 3: Sem chmod (bash importa)**
   ```bash
   bash scripts/auto-setup.sh
   ```
   - ✅ Funciona igual, sem precisar de chmod
   - ℹ️ Log salvo em `.setup-logs/`


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

## � Acompanhamente de Instalação

### Sistema de Logging Automático

`auto-setup.sh` cria logs detalhados durante a execução:

**Arquivos gerados em `.setup-logs/`:**
1. **Log completo:** `auto-setup_TIMESTAMP.log`
   - Todos os comandos e saídas
   - Erros e warnings
   - Timestamps de cada ação

2. **Progresso:** `setup-progress.txt`
   - Resumo de cada etapa (1/7, 2/7, etc)
   - Status: ✓ CONCLUÍDO, ⚠ Avisos, ✗ FALHA

### Monitorar em Tempo Real

```bash
# Ver log en vivo enquanto executa
tail -f .setup-logs/auto-setup_*.log

# Ver progresso (em outro terminal)
watch cat .setup-logs/setup-progress.txt

# Ver status final
cat .setup-logs/setup-progress.txt
```

### Exemplo de Saída

```
=== Auto Setup Progress ===
Iniciado em: Mon Feb 23 13:30:45 2026

1/7 | Verificar pré-requisitos | ✓ CONCLUÍDO
2/7 | Detectar distribuição | ✓ Manjaro
3/7 | Remover bloatware | ✓ CONCLUÍDO
4/7 | Atualizar sistema | ✓ CONCLUÍDO
5/7 | Configurar Terminal | ✓ CONCLUÍDO
6/7 | Instalar packages | ✓ CONCLUÍDO
7/7 | Aplicar configurações | ✓ CONCLUÍDO

Concluído em: Mon Feb 23 14:15:30 2026
```

---

## 📋 Ordem de Execução & Dependências

### ⚡ Auto-Setup (Recomendado)

O script `auto-setup.sh` executa tudo na ordem correta automaticamente:

| Ordem | Script | Descrição | Dependência |
|-------|--------|-----------|------------|
| 0️⃣ | keyring check (inline) | Verifica chaves do Arch Linux | Nenhuma (crítico: very first) |
| 1️⃣ | `check-prerequisites.sh` | Verifica essenciais do sistema | Nenhuma (crítico: first) |
| 2️⃣ | `detect-distro` (inline) | Detecta Arch/Manjaro | check-prerequisites ✓ |
| 3️⃣ | `debloat-manjaro.sh` | Remove bloatware (se Manjaro) | detect-distro ✓ (opcional) |
| 4️⃣ | `pacman -Syu` (inline) | Atualiza sistema | check-prerequisites ✓ |
| 4️⃣.5️⃣ | keyring check second (inline) | Re-verifica chaves pós-update | pacman update ✓ |
| 5️⃣ | `install-terminal.sh` | Alacritty + Zsh + P10k | pacman update ✓, sudo ✓ |
| 6️⃣ | `install-packages.sh` | Instala packages salvos | pacman update ✓, sudo ✓, keyring ✓ |
| 7️⃣ | `setup.sh` (inline) | Aplica configurações | install-terminal ✓ |

**Tempo total:** ~30-90 minutos (varia com internet)

### 📊 Acompanhando o Progresso

O `auto-setup.sh` gera logs em tempo real:

```bash
# Ver logs durante execução
tail -f .setup-logs/setup-progress.txt      # Progresso em tempo real
tail -f .setup-logs/auto-setup_*.log        # Log detalhado
```

**Estrutura de logs:**
```
.setup-logs/
├── setup-progress.txt               # Resumo: [1/7] passo | status
├── auto-setup_20260223_130000.log   # Log completo com timestamps
└── auto-setup_20260223_135000.log   # Novo log a cada execução
```

**Exemplo de progresso:**
```
1/7 | Verificar pré-requisitos | EM ANDAMENTO
1/7 | Verificar pré-requisitos | ✓ CONCLUÍDO
2/7 | Detectar distribuição | EM ANDAMENTO
2/7 | Detectar distribuição | ✓ Arch Linux
3/7 | Remover bloatware | ⊘ N/A (Arch)
```

### ⚠️ Problemas de Dependência

**Ordem CORRETA:**
```bash
✓ KEYRING check → check-prerequisites → detectar distro → debloat → atualizar → KEYRING check 2 → instalar terminal → packages → configs
```

**Ordem ERRADA (evitar):**
```bash
✗ install-terminal sem KEYRING check (assinatura de pacote falha)
✗ install-packages sem KEYRING check (pacotes não autenticam)
✗ check-prerequisites sem KEYRING (faltam chaves para instalar essenciais)
```

### 🔐 Verificação de Chaves do Arch Linux

O `auto-setup.sh` verifica as chaves do Arch **DUAS VEZES**:
1. **No início:** Antes de instalar qualquer coisa
2. **Após atualizar:** Após `pacman -Syu`

**Isso evita:**
- `error:Signature from "Usuario <usuario@mail>" is marginal trust`
- `error:Package (xxxxxxx) may be corrupted`
- Problemas na instalação de packages

**Se ainda tiver problemas com chaves:**
```bash
# Solução manual
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy archlinux-keyring
sudo pacman-key --refresh-keys

# Se persistir (nuclear option - último recurso)
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux
```

### 🔧 Executar Scripts Individuais

Se preferir executar manualmente na ordem correta:

```bash
# 1. Sempre comece com pré-requisitos
bash scripts/check-prerequisites.sh

# 2. Detectar e limpar (Manjaro)
sudo bash scripts/debloat-manjaro.sh

# 3. Atualizar sistema
sudo pacman -Syu

# 4. Terminal moderno
sudo bash scripts/install-terminal.sh

# 5. Packages
sudo bash scripts/install-packages.sh

# 6. Configurações
bash scripts/setup.sh
```

---

## 🎯 Verificar Status da Instalação

### 🔍 Verificar Status da Instalação

#### Durante execução do auto-setup.sh:
```bash
# Terminal 1: Monitorar progresso
tail -f .setup-logs/setup-progress.txt

# Terminal 2: Ver erros detalhados em tempo real
tail -f .setup-logs/errors_*.log
```

#### Após conclusão:
```bash
# Ver resumo completo
cat .setup-logs/setup-progress.txt

# Ver TODOS os erros capturados (detalhados)
cat .setup-logs/errors_*.log

# Ver log completo (com timestamps)
tail -100 .setup-logs/auto-setup_*.log
```

#### Se instalação teve erros:
O script exibe automaticamente um resumo no final:
```
╔════════════════════════════════════════════╗
║         ⚠️  ERROS ENCONTRADOS              
╚════════════════════════════════════════════╝
```

Cada erro mostra:
- 📍 **Passo que falhou** (ex: "Instalar packages")
- 🕐 **Timestamp** (quando aconteceu)
- 📝 **Output completo do erro**

### 🔧 Modo Interativo vs Automático
```bash
# Terminal 1: Monitorar progresso
tail -f .setup-logs/setup-progress.txt

# Terminal 2: Ver erros detalhados
tail -f .setup-logs/auto-setup_*.log | grep ERROR
```

### Após conclusão:
```bash
# Ver resumo completo
cat .setup-logs/setup-progress.txt

# Ver erros (se houver)
grep "ERROR\|FAIL" .setup-logs/auto-setup_*.log

# Ver warnings (não-crítico)
grep "WARNING" .setup-logs/auto-setup_*.log
```

### Verificar instalação manual:
```bash
# Terminal instalado?
alacritty --version && zsh --version && which p10k

# Docker instalado?
docker --version && docker-compose --version

# LunarVim instalado?
nvim +LunarVimVersion

# Portainer rodando?
docker ps | grep portainer
```

---

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
