# 📜 Scripts - Documentação Completa

Referência de todos os scripts disponíveis no repositório.

## 🚀 Para Começar

### Auto Setup (Recomendado - Primeiro Passo!)

**Arquivo:** `auto-setup.sh`

Script automático que faz todo o setup inicial após clonar o repositório.

```bash
# Dar permissão e executar
chmod +x scripts/*.sh
bash scripts/auto-setup.sh

# Ou mais direto (com sintaxe POSIX)
bash auto-setup.sh
```

**O que faz:**
- ✅ Detecta sua distribuição (Arch/Manjaro)
- ✅ Oferece remover bloatware (se Manjaro)
- ✅ Atualiza o sistema
- ✅ Instala e configura Alacritty + Zsh + Powerlevel10k
- ✅ Instala ferramentas recomendadas
- ✅ Restaura suas configurações

⚠️ **Requer:** Conexão com internet, sudo

---

## 🔧 Scripts Individuais

### 1. **install-terminal.sh** - Terminal Moderno

Instala e configura Alacritty, Zsh, Powerlevel10k e ferramentas.

```bash
sudo bash scripts/install-terminal.sh
```

**Instala:**
- 🖥️ Alacritty (terminal GPU acelerado)
- 🐚 Zsh + Oh My Zsh (shell interativo com framework)
- ⚡ Powerlevel10k (prompt visual moderno)
- 🎨 Plugins Zsh (syntax highlighting, autosuggestions)
- 🛠️ Ferramentas: fzf, ripgrep, fd, bat, exa, htop, neofetch

**Tempo:** ~5-10 minutos

---

### 2. **debloat-manjaro.sh** - Remover Bloatware

Remove aplicações pré-instaladas desnecessárias do Manjaro.

```bash
sudo bash scripts/debloat-manjaro.sh
```

**Remove:**
- Thunderbird (cliente de email pesado)
- Audacious (player de áudio duplicado)
- KDE Plasma extras (bloatware)
- Gerenciadores de senhas desnecessários
- Softwares de desktop sharing
- E outros...

**Nota:** Só funciona em Manjaro. Arch não tem bloatware pré-instalado.

---

### 3. **export-packages.sh** - Exportar Suas Apps

Salva lista de todos os packages instalados.

```bash
bash scripts/export-packages.sh
```

**Gera:**
- `packages/pacman-packages.txt` - Apps oficiais
- `packages/aur-packages.txt` - Apps do AUR
- `packages/pip-packages.txt` - Packages Python
- `packages/npm-packages.txt` - Packages Node.js
- `packages/system-info.txt` - Info do sistema

**Use quando:** Instalou novo package e quer sincronizar

---

### 4. **install-packages.sh** - Instalar Suas Apps

Instala todos os packages salvos em outro PC.

```bash
sudo bash scripts/install-packages.sh
```

**Requer:**
- Arquivo `packages/pacman-packages.txt`
- AUR helper instalado (yay ou paru) - para AUR packages

**Tempo:** Depende da quantidade de packages (~10 minutos em média)

---

### 5. **backup-configs.sh** - Fazer Backup

Copia suas configurações (dotfiles, configs de apps).

```bash
bash scripts/backup-configs.sh
```

**Copia:**
- Dotfiles: `.bashrc`, `.zshrc`, `.profile`, `.aliases`
- Configs de apps: alacritty, nvim, tmux, etc
- Arquivo de info do sistema

---

### 6. **setup.sh** - Setup Principal (Menu Interativo)

Menu interativo com opções de installação.

```bash
bash scripts/setup.sh
```

**Opções:**
```
1) Instalação completa (packages + dotfiles + configs)
2) Instalar apenas packages
3) Restaurar apenas dotfiles
4) Restaurar apenas configurações de apps
5) Sair
```

---

## 📋 Makefile.sh - Atalhos

Arquivo `makefile.sh` na raiz com atalhos para comandos comuns:

```bash
bash makefile.sh export       # Exportar suas configs
bash makefile.sh install      # Instalar packages
bash makefile.sh setup        # Menu de setup
bash makefile.sh dotfiles     # Restaurar dotfiles
bash makefile.sh configs      # Restaurar configs
bash makefile.sh status       # Ver mudanças
bash makefile.sh sync         # git pull
bash makefile.sh commit       # Fazer commit e push
bash makefile.sh clean        # Limpar temporários
bash makefile.sh help         # Ver help
```

---

## 🔄 Fluxo de Uso

### Cenário 1: Novo PC (Manual)

```bash
# 1. Clonar
git clone https://github.com/seu-usuario/archlinux-setup.git
cd archlinux-setup

# 2. Preparar
chmod +x scripts/*.sh

# 3. Setup automático (recomendado!)
bash scripts/auto-setup.sh

# Ou passo-a-passo:
sudo bash scripts/install-terminal.sh   # Terminal moderno
sudo bash scripts/debloat-manjaro.sh    # Se Manjaro
bash scripts/setup.sh                   # Menu completo
```

### Cenário 2: Sincronizar PC Existente

```bash
# 1. Exportar suas configs
bash makefile.sh export

# 2. Review
bash makefile.sh status

# 3. Commit e push
bash makefile.sh commit

# 4. Em outro PC
git pull
bash makefile.sh install
bash makefile.sh dotfiles
```

### Cenário 3: Instalar Novo Package

```bash
# 1. Instalar normalmente
sudo pacman -S novo-package

# 2. Exportar
bash makefile.sh export

# 3. Commit
bash makefile.sh commit

# 4. Em outro PC
git pull
sudo bash scripts/install-packages.sh
```

---

## 🆘 Troubleshooting

### Os scripts não executam

```bash
# Dar permissão
chmod +x scripts/*.sh

# Executar com bash explícito
bash scripts/auto-setup.sh
```

### Erro "sudo: bash: command not found"

```bash
# Usar /usr/bin/bash
sudo /usr/bin/bash scripts/auto-setup.sh
```

### AUR helper não instalado

```bash
# Instalar yay
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin && makepkg -si

# Ou paru
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin && makepkg -si
```

### Terminal não está usando Zsh após reboot

```bash
# Definir manualmente
chsh -s /usr/bin/zsh

# Ou
sudo usermod --shell /usr/bin/zsh $(whoami)

# Depois reiniciar
```

### Powerlevel10k mostrando caracteres estranhos

Instale uma Nerd Font:

```bash
# Download FiraCode Nerd Font
cd ~/Downloads
curl -LOJ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
unzip FiraCode.zip
mkdir -p ~/.local/share/fonts
cp FiraCode/*.ttf ~/.local/share/fonts/
fc-cache -fv

# Configure seu terminal para usar a fonte
# E customize Powerlevel10k
p10k configure
```

---

## 📊 Ordem de Execução Recomendada

```
1. auto-setup.sh
   ↓
2. Terminal reiniciado/novo
   ↓
3. Customize Powerlevel10k (p10k configure)
   ↓
4. Use makefile.sh para sincronizar
```

---

## 🔒 Notas sobre Segurança

⚠️ **Nunca commite:**
- Senhas ou tokens
- Chaves SSH
- Dados sensíveis nos dotfiles
- Paths locais específicos

✅ **Adicione ao .gitignore:**
```bash
.env
.env.local
*.key
.ssh/
local-config
~/.bash_history
```

---

## 📚 Referências

- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [Manjaro Wiki](https://wiki.manjaro.org/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh](https://ohmyzsh.sh/)
- [Alacritty](https://alacritty.org/)

---

**Bom trabalho com seus scripts! 🚀**
