# 🛠️ Configurações de Aplicações

Diretório para armazenar e sincronizar configurações de aplicações do Arch Linux.

## Como Usar

### Adicionando configuração de nova app:

```bash
# Copie a pasta de configuração
cp -r ~/.config/[nome-da-app] configs/

# Exemplo com alacritty
cp -r ~/.config/alacritty configs/

# Commit
git add configs/alacritty
git commit -m "Add alacritty configuration"
git push
```

### Restaurando configuração em outro PC:

```bash
# Pull das mudanças
git pull

# Copie para o local correto
mkdir -p ~/.config/alacritty
cp -r configs/alacritty/* ~/.config/alacritty/

# Reinicie a aplicação
```

## Apps Comuns

Arquivos de configuração típicos para adicionar:

- **alacritty** - Emulador de terminal GPU (` ~/.config/alacritty/alacritty.yml`)
- **neovim** - Editor de texto avançado (`~/.config/nvim/init.vim`)
- **tmux** - Multiplexer de terminal (`~/.tmux.conf`)
- **fish** - Shell interativo (`~/.config/fish/config.fish`)
- **kitty** - Terminal (`~/.config/kitty/kitty.conf`)
- **dunst** - Notificações (`~/.config/dunst/dunstrc`)
- **polybar** - Barra de status (`~/.config/polybar/config`)
- **i3/sway** - WM (`~/.config/i3/config` ou `~/.config/sway/config`)

## Notas

- Algumas configs contêm paths locais - ajuste conforme necessário
- Arquivos muito grandes podem ficar lento o git
- Use .gitignore para excluir arquivos sensíveis
- Some configs têm cache - limpe antes de commitar

## Template de Adição

```bash
# 1. Copiar configuração
cp -r ~/.config/[app] configs/

# 2. Verificar mudanças
git status

# 3. Revisar e editar se necessário
nano configs/[app]/config-file

# 4. Commit
git add configs/[app]
git commit -m "Add/Update [app] configuration"

# 5. Push
git push origin main
```
