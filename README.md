# 🐧 Arch Linux Setup & Configuration Repository

Repositório para sincronizar e replicar configurações, aplicativos e dotfiles do Arch Linux entre diferentes máquinas.

## 📋 Estrutura do Projeto

```
.
├── README.md                  # Este arquivo
├── .gitignore                 # Arquivos ignorados pelo git
├── scripts/                   # Scripts de automação
│   ├── export-packages.sh     # Exporta lista de packages instalados
│   ├── install-packages.sh    # Instala packages do arquivo
│   ├── backup-configs.sh      # Faz backup de configurações
│   └── setup.sh               # Script principal de setup
├── packages/                  # Listas de packages
│   ├── pacman-packages.txt    # Packages do pacman
│   ├── aur-packages.txt       # Packages do AUR
│   └── pip-packages.txt       # Packages do Python (pip)
├── dotfiles/                  # Arquivos de configuração do terminal/shell
│   ├── .bashrc
│   ├── .zshrc
│   ├── .profile
│   └── .aliases
└── configs/                   # Configurações de aplicações
    ├── alacritty/
    ├── neovim/
    ├── tmux/
    └── ...
```

## 🚀 Início Rápido

### Instalação de Ferramentas Recomendadas (Terminal Moderno)

```bash
# Instalar framework Zsh e tema Powerlevel10k
sudo pacman -S zsh oh-my-zsh powerlevel10k
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions

# AUR helper
yay -S yay

# Utilidades essenciais
sudo pacman -S fzf ripgrep fd bat exa htop neofetch

# Opcional: git, tmux, neovim, etc
sudo pacman -S git tmux neovim
```

### Após instalação de ferramentas:

```bash
# Configurar Powerlevel10k (recomendado)
p10k configure

# Definir zsh como shell padrão
chsh -s /usr/bin/zsh
```

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

- [INIT.md](INIT.md) - Guia de inicialização
- [QUICKSTART.md](QUICKSTART.md) - Início rápido
- [WORKFLOW.md](WORKFLOW.md) - Fluxo de sincronização
- [TERMINAL_SETUP.md](TERMINAL_SETUP.md) - ⭐ Setup Powerlevel10k & Zsh moderno

---

**Mantém seu Arch Linux sincronizado! 🎉**
