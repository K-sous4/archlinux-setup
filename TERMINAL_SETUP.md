# 🖥️ Setup de Terminal - Powerlevel10k & Zsh

Guia completo para configurar seu terminal com Powerlevel10k, Oh My Zsh e outras ferramentas modernas no Arch Linux.

## 📋 O Que Você Terá

```
┌─ user@hostname ~/project main
├─ 🕐 14:32:51 | Node v18.0 | Python 3.10
└─ »
```

Visual moderno com:
- Prompt rico com git status
- Informações de contexto (hora, versões, diretório)
- Syntax highlighting enquanto digita
- Autocompletar baseado em histórico
- Ícones e cores

## 🚀 Instalação Passo-a-Passo

### 1. Instalar Zsh

```bash
# Instalar Zsh
sudo pacman -S zsh

# Definir como shell padrão
chsh -s /usr/bin/zsh

# Sair e voltar ao terminal (ou inicie novo terminal)
exit
```

### 2. Instalar Oh My Zsh

```bash
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Ou via git
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

### 3. Instalar Powerlevel10k

```bash
# Via AUR (recomendado)
yay -S powerlevel10k

# Ou via git
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 4. Instalar Plugins Extras

```bash
# Syntax highlighting e autosuggestions
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions
```

### 5. Instalar Ferramentas Recomendadas

```bash
# Todas as ferramentas
sudo pacman -S fzf ripgrep fd bat exa htop neofetch

# Ou algumas específicas:
sudo pacman -S fzf             # Fuzzy finder
sudo pacman -S ripgrep         # Grep moderno
sudo pacman -S fd              # Find moderno
sudo pacman -S bat             # Cat com highlighting
sudo pacman -S exa             # Ls moderno
```

## ⚙️ Configuração

### Usar o .zshrc do Repositório

```bash
# Se ainda não tem um .zshrc
cp dotfiles/.zshrc.example ~/.zshrc

# Ou mesclar com seu existente
cat dotfiles/.zshrc.example >> ~/.zshrc
```

### Customizar Powerlevel10k

```bash
# Executar assistente de configuração
p10k configure

# Ou editar manualmente
nano ~/.p10k.zsh
```

## 🎨 Configurações Populares

### Exemplo 1: Tema Minimalista

Edite `~/.p10k.zsh`:

```zsh
# Mostrar pouco
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                    # Diretório
    vcs                    # Git info
    command_execution_time # Tempo do comando
    status                 # Sucesso/erro
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    time                   # Hora
)
```

### Exemplo 2: Tema Completo

```zsh
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    user
    host
    dir
    vcs
    nix_shell
    virtualenv
    node
    python
    ruby
    time
    newline
    status
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
```

### Exemplo 3: Profissional

```zsh
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir
    vcs
    nix_shell
    virtualenv
    node  
    command_execution_time
    newline
    status
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    time
)
```

## 📝 Aliases com Ferramentas Modernas

Coloque em seu `~/.aliases`:

```bash
# Usar exa ao invés de ls
alias ls='exa --icons'
alias ll='exa -lah --icons'
alias la='exa -lA --icons'

# Usar bat ao invés de cat
alias cat='bat'
alias catn='bat --style=plain'

# Usar ripgrep
alias grep='rg'

# Usar fd
alias find='fd'

# FZF com histórico
alias history-search='history | fzf'

# Packages
alias pm-installed='pacman -Qqe'
alias pm-search='pacman -Ss'
alias pm-update='sudo pacman -Syu'
```

## 🔧 Troubleshooting

### Caracteres estranhos no prompt

**Problema**: Vê `?` ou símbolos errados

**Solução**: 
- Instale fonte com suporte a Unicode (Nerd Font)
- Download: [Nerd Fonts](https://www.nerdfonts.com/)
- Descompacte em `~/.local/share/fonts/`
- Configure seu terminal para usar a fonte

```bash
# Exemplo instalando Fira Code Nerd Font
cd ~/Downloads
unzip FiraCode.zip
mkdir -p ~/.local/share/fonts
cp FiraCode/* ~/.local/share/fonts/
fc-cache -fv
```

### Oh My Zsh não está carregando

```bash
# Verificar instalação
ls -la ~/.oh-my-zsh

# Reinstalar se necessário
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Powerlevel10k não está sendo usado

```bash
# Verificar ~/.zshrc tem:
ZSH_THEME="powerlevel10k/powerlevel10k"

# Recarregar shell
exec zsh
```

### Performance lenta

```bash
# Desabilite plugins desnecessários em ~/.zshrc
plugins=(git arch) # Apenas essenciais

# Reduzir histórico se necessário
HISTSIZE=5000
SAVEHIST=5000

# Validar com:
time zsh -i -c exit
```

## 📚 Plugins Oh My Zsh Úteis

Adicione em `~/.zshrc` na array `plugins`:

```bash
plugins=(
    git                    # Git commands
    arch                   # Pacman helpers
    docker                 # Docker completion
    docker-compose         # Docker compose
    extract                # Easy archive extraction
    git-flow              # Git flow
    history-substring-search # Search history
    colored-man-pages     # Colorize man pages
    colorize              # Syntax coloring
    sudo                  # Prepend sudo with ESC+ESC
    command-not-found     # Suggest packages
)
```

## 🔄 Sincronizar Configuração

```bash
# No seu PC:
cp ~/.zshrc dotfiles/.zshrc
cp ~/.p10k.zsh dotfiles/.p10k.zsh
git add dotfiles/
git commit -m "Update Zsh and Powerlevel10k configs"
git push

# Em outro PC:
git pull
cp dotfiles/.zshrc ~/.zshrc
cp dotfiles/.p10k.zsh ~/.p10k.zsh
exec zsh
```

## 🎯 Dicas Finais

1. **Fonte**: Use uma Nerd Font para melhor experiência
2. **Cores**: Terminal com suporte a 256 cores ou true color
3. **Backup**: `~/.p10k.zsh` é salvo automaticamente
4. **Temas**: Customize conforme seu gosto com `p10k configure`
5. **Performance**: Carregue apenas plugins que usa

## 📖 Referências

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh](https://ohmyzsh.sh/)
- [Arch Linux Wiki - Zsh](https://wiki.archlinux.org/title/Zsh)
- [Nerd Fonts](https://www.nerdfonts.com/)

---

**Bem-vindo ao terminal moderno! 🚀**
