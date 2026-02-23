# 🔄 Fluxo de Trabalho - Como Manter Tudo Sincronizado

## 📋 Setup Inicial

### PC 1 (Original):

```bash
# Clone ou navegue até o repositório
cd ~/archlinux-setup

# Faça os scripts serem executáveis
chmod +x scripts/*.sh

# Exporte suas configurações atuais
bash scripts/export-packages.sh
bash scripts/backup-configs.sh

# Revise as mudanças
git status

# Faça commit
git add .
git commit -m "Initial Arch Linux setup backup"
git push origin main
```

### PC 2 (Novo):

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/archlinux-setup.git
cd archlinux-setup

# Faça os scripts serem executáveis
chmod +x scripts/*.sh

# Execute o setup completo
bash scripts/setup.sh

# Escolha opção 1 para instalação completa
```

## 🔄 Sincronização Contínua

### Quando adiciona novo package em PC 1:

```bash
# Exporte packages
bash scripts/export-packages.sh

# Commits das mudanças
git add packages/
git commit -m "Add new packages: [lista de novos packages]"
git push origin main
```

### Sincronizar em PC 2:

```bash
# Atualizar repositório
git pull origin main

# Instalar novos packages
sudo bash scripts/install-packages.sh
```

## 📝 Quando modifica dotfiles

### PC 1: Atualizando um dotfile

```bash
# Modifique seu ~/.bashrc
nano ~/.bashrc

# Copie para o repositório
cp ~/.bashrc dotfiles/.bashrc

# Commit
git add dotfiles/.bashrc
git commit -m "Update .bashrc with new aliases"
git push
```

### PC 2: Restaurando

```bash
# Atualizar repo
git pull origin main

# Restaurar dotfile
cp dotfiles/.bashrc ~/.bashrc

# Recarregar shell
source ~/.bashrc
```

## ⚙️ Quando modifica configs de apps

### PC 1: Atualizando configuração

```bash
# Modifique a configuração do app (ex: alacritty)
nano ~/.config/alacritty/alacritty.yml

# Copie para o repositório
cp -r ~/.config/alacritty/* configs/alacritty/

# Commit
git add configs/alacritty/
git commit -m "Update alacritty configuration"
git push
```

### PC 2: Restaurando

```bash
# Atualizar repo
git pull origin main

# Restaurar config
mkdir -p ~/.config/alacritty
cp -r configs/alacritty/* ~/.config/alacritty/

# Reiniciar app
```

## 🔧 Perfis Personalizados (Opcional)

Se seus PCs têm diferenças significativas, use branches:

```bash
# PC 1 (Desktop)
git checkout -b desktop
bash scripts/export-packages.sh
bash scripts/backup-configs.sh
git add .
git commit -m "Desktop environment setup"
git push origin desktop

# PC 2 (Laptop)
git checkout -b laptop
bash scripts/export-packages.sh
bash scripts/backup-configs.sh
git add .
git commit -m "Laptop environment setup"
git push origin laptop

# Para sincronizar tudo depois
git checkout main
git merge desktop
git merge laptop
git push
```

## 🛡️ Dicas de Segurança

### Nunca commit:
- 🚫 Senhas ou tokens
- 🚫 Arquivos com dados sensíveis
- 🚫 Chaves SSH (adicione ao .gitignore)
- 🚫 Configurações com paths locais específicos

### Adicione ao .gitignore:
```bash
echo "~/.ssh/" >> .gitignore
echo ".env" >> .gitignore
echo "local-config" >> .gitignore
```

## 📊 Script de Status

Para ver rapidamente o que mudou:

```bash
#!/bin/bash
# Salve como check-changes.sh

echo "📦 Pacman changes:"
pacman -Qqe | grep -v "$(pacman -Qqm)" | wc -l

echo "🗂️  AUR changes:"
pacman -Qqm | wc -l

echo "📝 Dotfile changes:"
ls -la ~/archlinux-setup/dotfiles/ | wc -l

echo "⚙️  App configs changes:"
ls -la ~/archlinux-setup/configs/ | wc -l

echo ""
echo "Git status:"
git status --short
```

## 🚨 Troubleshooting

### Conflitos ao fazer merge:
```bash
git pull origin main
# Resolva os conflitos manualmente
git add .
git commit -m "Resolve merge conflicts"
git push
```

### Restaurar arquivo específico de versão anterior:
```bash
git log --oneline -- packages/pacman-packages.txt
git show COMMIT_ID:packages/pacman-packages.txt > packages/pacman-packages.txt
```

### Atualizar só uma app config:
```bash
mkdir -p ~/.config/nvim
cp configs/nvim/* ~/.config/nvim/
```

## ✅ Checklist Mensal

- [ ] Exportar packages: `bash scripts/export-packages.sh`
- [ ] Fazer backup de configs: `bash scripts/backup-configs.sh`
- [ ] Revisar mudanças: `git status`
- [ ] Commitar: `git add . && git commit -m "Monthly update"`
- [ ] Push: `git push`
- [ ] Verificar em outro PC: `git pull && bash scripts/setup.sh`

---

**Mantenha seu ambiente sincronizado e reproduzível! 🎉**
