# 📦 Packages Directory

Diretório para armazenar listas de packages instalados no Arch Linux.

## ⚡ Ferramentas Recomendadas para Terminal

### Framework & Theme
- **zsh** - Shell interativo mais poderoso que bash
- **oh-my-zsh** - Framework completo para Zsh com plugins
- **powerlevel10k** - Tema visual moderno e rápido para Zsh
- **zsh-syntax-highlighting** - Destaca sintaxe enquanto digita
- **zsh-autosuggestions** - Sugere comandos do histórico

### Utilidades Essenciais
- **git** - Controle de versão
- **yay** ou **paru** - AUR helpers para instalar packages
- **fzf** - Fuzzy finder (histórico, arquivos, etc)
- **ripgrep** - grep moderno e muito mais rápido
- **fd** - find mais simples e intuitivo

### Melhorias de Visualização
- **bat** - cat com syntax highlighting
- **exa** ou **lsd** - ls moderno com cores e ícones
- **htop** - Monitor de processos interativo
- **neofetch** - Mostra info bonita do sistema
- **bottom** - Alternative moderno ao htop

## Arquivos

- **pacman-packages.txt** - Packages oficiais do Arch Linux (pacman)
- **aur-packages.txt** - Packages do Arch User Repository (AUR)
- **pip-packages.txt** - Pacotes Python gerenciados com pip
- **npm-packages.txt** - Pacotes Node.js (npm global)
- **system-info.txt** - Informações do sistema no momento do export

## Como Usar

### Exportar packages do seu PC:
```bash
bash ../scripts/export-packages.sh
```

Isso criará/atualizará os arquivos .txt neste diretório.

### Instalar packages em novo PC:
```bash
sudo bash ../scripts/install-packages.sh
```

## Notas Importantes

- **pacman-packages.txt**: Contém apenas packages instalados explicitamente (sem dependências)
- **aur-packages.txt**: Packages instalados do AUR
- **pip-packages.txt**: Usa `pip freeze` para capturar a versão exata
- **npm-packages.txt**: Lista de packages globais instalados com npm

Os packages são instalados usando:
- `pacman -S` para packages oficiais
- `yay -S` ou `paru -S` para AUR
- `pip install -r` para Python
- `npm install -g` para Node.js

## Fluxo de Atualização

1. Quando instala novo package em seu PC, execute: `bash ../scripts/export-packages.sh`
2. Revise as mudanças: `git status`
3. Commit as mudanças: `git add . && git commit -m "Update packages"`
4. Push: `git push`
5. Em outro PC: `git pull` e `sudo bash ../scripts/install-packages.sh`
