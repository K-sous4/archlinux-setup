# 🚀 Initialization Guide - Guia de Inicialização

## ✅ Depois de Clonar Este Repositório

### 1. **Dar permissão aos scripts**
```bash
chmod +x scripts/*.sh
```

### 2. **Customizar para seu ambiente**

Antes de usar, revise e customize:
- `packages/` - Ajuste qual packages deseja instalar/manter
- `dotfiles/` - Revise e adapte suas configurações
- `configs/` - Selecione apps que está usando
- `README.md` - Atualize com informações pessoais

### 3. **Testar scripts**

Comece testando em um PC separado ou máquina virtual:
```bash
bash scripts/setup.sh
```

---

## 📦 Setup no PC Original

Se está usando em seu PC Arch Linux atual:

### Passo 1: Clonar/inicializar repositório
```bash
git clone https://github.com/seu-usuario/archlinux-setup.git
cd archlinux-setup
chmod +x scripts/*.sh
```

### Passo 2: Exportar configuração atual
```bash
# Exportar packages instalados
bash scripts/export-packages.sh

# Fazer backup de configurações
bash scripts/backup-configs.sh
```

### Passo 3: Revisar mudanças
```bash
git status
# Revise se está tudo correto
```

### Passo 4: Fazer commit
```bash
git add .
git commit -m "Initial Arch Linux setup - $(date +%Y-%m-%d)"
git push origin main
```

---

## 🖥️ Setup em Novo PC

Em um PC novo com Arch Linux:

### Passo 1: Preparar sistema base
```bash
# Atualizar sistema
sudo pacman -Syu

# Instalar git (se não tiver)
sudo pacman -S git

# Instalar AUR helper (yay ou paru)
# opção A: yay-bin
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..

# opção B: paru-bin
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..
```

### Passo 2: Clonar repositório
```bash
git clone https://github.com/seu-usuario/archlinux-setup.git
cd archlinux-setup
chmod +x scripts/*.sh
```

### Passo 3: Executar setup
```bash
bash scripts/setup.sh
# Escolha opção 1 para instalação completa
```

### Passo 4: Recarregar shell
```bash
# Para bash
source ~/.bashrc

# Para zsh
source ~/.zshrc

# Para fish
source ~/.config/fish/config.fish
```

---

## 📋 Checklist Pós-Setup

- [ ] Todos os packages foram instalados?
- [ ] Dotfiles foram restaurados?
- [ ] Configs das apps foram copiadas?
- [ ] Shell está usando os aliases novos?
- [ ] Apps estão iniciando corretamente?

Teste com:
```bash
# Verificar shell
echo $SHELL

# Testar alias
ll  # deveria listar com cores

# Testar package
pacman -Q | wc -l  # contar packages
```

---

## 🔄 Sincronização Contínua

### Após instalar novo package:
```bash
bash scripts/export-packages.sh
git add packages/
git commit -m "Add new packages: [lista]"
git push
```

### Sincronizar em outro PC:
```bash
git pull
sudo bash scripts/install-packages.sh
```

---

## ⚙️ Configuração Manual (sem scripts)

Se preferir fazer manualmente:

### Instalar packages
```bash
# Pacman packages
sudo pacman -S $(cat packages/pacman-packages.txt | tr '\n' ' ')

# AUR
yay -S $(cat packages/aur-packages.txt | tr '\n' ' ')

# Python packages
pip install -r packages/pip-packages.txt
```

### Restaurar dotfiles
```bash
cp dotfiles/.bashrc ~/.bashrc
cp dotfiles/.zshrc ~/.zshrc
cp dotfiles/.aliases ~/.bash_aliases
source ~/.bashrc
```

### Restaurar configs
```bash
mkdir -p ~/.config
cp -r configs/* ~/.config/
```

---

## 🆘 Troubleshooting

### Problem: "Permission denied" nos scripts
```bash
chmod +x scripts/*.sh
```

### Problem: AUR helper não encontrado
```bash
# Install yay
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin && makepkg -si
```

### Problem: Packages não instalam
```bash
# Verificar se pacman está atualizado
sudo pacman -Syu

# Verificar sintaxe do arquivo
head -20 packages/pacman-packages.txt
```

### Problem: Dotfiles não aplicados
```bash
# Verificar arquivo
ls -la ~/.bashrc

# Recarregar manualmente
source ~/.bashrc

# Testar
echo $BASH_ALIASES
```

---

## 📚 Próximas Leituras

- [README.md](README.md) - Documentação completa
- [WORKFLOW.md](WORKFLOW.md) - Fluxo de trabalho detalhado
- [QUICKSTART.md](QUICKSTART.md) - Início rápido
- [scripts/](scripts/) - Ver scripts individuais

---

**Bem-vindo ao setup automatizado do Arch Linux! 🎉**
