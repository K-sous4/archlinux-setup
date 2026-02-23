# 📝 Dotfiles

Diretório para armazenar e sincronizar dotfiles (arquivos de configuração do shell/terminal).

## Arquivos Inclusos

- `.bashrc` - Configuração do Bash
- `.zshrc` - Configuração do Zsh  
- `.profile` - Variáveis de ambiente compartilhadas
- `.aliases` - Aliases customizados
- `.bash_aliases` - Aliases específicos do Bash
- `.bashrc.example` - Exemplo de .bashrc
- `.zshrc.example` - Exemplo de .zshrc
- `.aliases.example` - Exemplo de aliases

## Como Usar

### Restaurar dotfiles em novo PC:

```bash
# Opção 1: Setup automático
bash ../scripts/setup.sh
# Escolher opção 3 (Restaurar apenas dotfiles)

# Opção 2: Manual
cp .bashrc ~/.bashrc
cp .zshrc ~/.zshrc
cp .profile ~/.profile
cp .aliases ~/.bash_aliases

# Recarregar shell
source ~/.bashrc  # ou ~/.zshrc
```

### Atualizar dotfile após mudanças:

```bash
# 1. Modifique seu arquivo
nano ~/.bashrc

# 2. Copie para o repositório
cp ~/.bashrc dotfiles/.bashrc

# 3. Commit
git add dotfiles/.bashrc
git commit -m "Update .bashrc with new aliases"
git push
```

## Boas Práticas

1. **Backup antes de sobrescrever**: `cp ~/.bashrc ~/.bashrc.bak`
2. **Revisar antes de aplicar**: `diff ~/.bashrc dotfiles/.bashrc`
3. **Teste em novo PC primeiro**: Antes de commitar
4. **Documente mudanças importantes**: No commit message

## Estrutura Recomendada

Organize seus dotfiles assim:

```
~/.bashrc
~/.zshrc
~/.profile
~/.bash_aliases
~/.config/shell/
~/.config/shell/aliases
~/.config/shell/functions
~/.config/shell/exports
```

E importe tudo do .bashrc/.zshrc:

```bash
# Em ~/.bashrc
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -d ~/.config/shell ]] && source ~/.config/shell/*
```

## Customizações Pessoais

Para manter configurações pessoais sem sync:

```bash
# Crie um arquivo local
echo "# Local config" > ~/.bashrc_local

# Importe em ~/.bashrc
[[ -f ~/.bashrc_local ]] && source ~/.bashrc_local

# Adicione ao .gitignore do repositório
echo "~/.bashrc_local" >> ../.gitignore
```

## Common Shells

### Bash
```bash
~/.bashrc       - Configuração de shell interativo
~/.bash_profile - Configuração de shell login
~/.bashrc_local - Configurações locais (não sincronizar)
```

### Zsh
```bash
~/.zshrc        - Configuração de shell interativo
~/.zsh_profile  - Configuração de shell login
~/.zshrc_local  - Configurações locais (não sincronizar)
```

### Fish
```bash
~/.config/fish/config.fish       - Configuração principal
~/.config/fish/functions/        - Funções customizadas
~/.config/fish/conf.d/           - Arquivos de configuração
```

## Recarregar sem Reiniciar Shell

```bash
# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc

# Fish
source ~/.config/fish/config.fish
```

---

**Mantenha suas configurações sincronizadas e portáveis! ✨**
