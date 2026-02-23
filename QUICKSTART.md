# 🎯 Quick Start Guide

## ⚡ Mais Rápido: Auto Setup (Recomendado!)

depois de clonar:

```bash
# 1. Clonar
git clone https://github.com/K-sous4/archlinux-setup.git
cd archlinux-setup

# 2. Preparar
chmod +x scripts/*.sh

# 3. AUTO SETUP (faz tudo automaticamente!)
bash scripts/auto-setup.sh

# 4. Novo terminal/shell
exit
```

✨ **Pronto!** Terminal configurado com Alacritty, Zsh, Powerlevel10k e ferramentas modernas.

Veja [AUTO_SETUP.md](AUTO_SETUP.md) para detalhes completos.

---

## 🔧 Alternativa: Manual (Passo-a-Passo)

---

## 🔧 Setup Manual (Passo-a-Passo)

Se preferir fazer manualmente:

### Passo 1: Clone
```bash
git clone https://github.com/seu-usuario/archlinux-setup.git
cd archlinux-setup
chmod +x scripts/*.sh
```

### Passo 2: Terminal Moderno (Alacritty + Zsh + Powerlevel10k)
```bash
sudo bash scripts/install-terminal.sh
```

### Passo 3: Remover Bloatware (só Manjaro)
```bash
sudo bash scripts/debloat-manjaro.sh
```

### Passo 4: Restaurar Tudo
```bash
bash scripts/setup.sh
# Escolha opção 1 (instalação completa)
```

### Passo 5: Novo Terminal
```bash
exit
# ou
exec zsh
```

---

## 📝 Para Seu PC Atual

Exportar e sincronizar suas configurações:

```bash
# 1. Exportar
bash makefile.sh export

# 2. Revisar
bash makefile.sh status

# 3. Commit e Push
bash makefile.sh commit

# 4. Em outro PC
git pull
bash makefile.sh install
```

---

## 🛠️ Comandos Rápidos

```bash
bash makefile.sh help        # Ver todos atalhos
bash makefile.sh export      # Exportar suas configs
bash makefile.sh install     # Instalar packages
bash makefile.sh setup       # Menu de setup
bash makefile.sh status      # Ver mudanças
bash makefile.sh commit      # Commit + push
```
