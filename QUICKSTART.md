# 🎯 Quick Start Guide

## Para PC novo com Arch Linux

### Passo 1: Clone o repositório
```bash
git clone https://github.com/seu-usuario/archlinux-setup.git
cd archlinux-setup
```

### Passo 2: Configure permissões
```bash
chmod +x scripts/*.sh
```

### Passo 3: Execute instalação completa
```bash
bash scripts/setup.sh
```

Escolha opção `1` para instalação completa (packages + dotfiles + configs).

---

## Para seu PC atual (Arch Linux)

### Passo 1: Exporte configurações
```bash
# No seu repositório local
bash scripts/export-packages.sh
bash scripts/backup-configs.sh
```

### Passo 2: Revise e commit
```bash
git status
git add .
git commit -m "Initial setup backup"
```

### Passo 3: Push para GitHub
```bash
git push origin main
```

---

## Comandos Mais Comuns

```bash
# Exportar após instalar novo package
bash scripts/export-packages.sh

# Atualizar tudo no novo PC
git pull
sudo bash scripts/install-packages.sh

# Restaurar apenas dotfiles
bash scripts/setup.sh  # escolha opção 3

# Fazer backup de configurações
bash scripts/backup-configs.sh
```

---

## Estrutura do Repositório

```
archlinux-setup/
├── README.md              ← Documentação completa
├── QUICKSTART.md          ← Este arquivo
├── WORKFLOW.md            ← Fluxo detalhado
├── scripts/
│   ├── export-packages.sh
│   ├── install-packages.sh
│   ├── backup-configs.sh
│   └── setup.sh
├── packages/
│   ├── pacman-packages.txt
│   ├── aur-packages.txt
│   └── pip-packages.txt
├── dotfiles/
│   ├── .bashrc
│   ├── .zshrc
│   └── .aliases
└── configs/
    ├── alacritty/
    ├── nvim/
    └── tmux/
```

---

## Próximos Passos

1. **Personalizar**: Edite os arquivos conforme suas preferências
2. **Adicionar**: Inclua mais aplicações e configurações
3. **Sincronizar**: Use `git push/pull` para manter tudo atualizado
4. **Documentar**: Mantenha o README atualizado com instruções específicas

---

**Pronto para começar! 🚀**
