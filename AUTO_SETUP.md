# 🚀 Manual de Auto Setup - Guia Rápido

Guia completo para usar o **auto-setup.sh** - o script que automatiza tudo após clonar o repositório.

## ⚡ Setup em 3 Passos

### 1️⃣ Clonar e Preparar

```bash
# Clonar repositório
git clone https://github.com/K-sous4/archlinux-setup.git
cd archlinux-setup

# Dar permissão aos scripts
chmod +x scripts/*.sh
```

### 2️⃣ Executar Auto Setup

```bash
# Executar o script automático
bash scripts/auto-setup.sh
```

### 3️⃣ Recarregar Shell

```bash
# A primeira vez, saia e abra um novo terminal
exit

# Ou força a recarregar
exec zsh
```

✨ **Pronto! Seu terminal está configurado!**

---

## 📋 O que Auto Setup Faz

```
auto-setup.sh
├─ Detecta Distribuição (Arch/Manjaro)
├─ Oferece remover bloatware (Manjaro)
├─ Atualiza sistema (pacman -Syu)
├─ Instala Alacritty (terminal GPU)
├─ Instala Zsh + Oh My Zsh
├─ Instala Powerlevel10k (prompt bonito)
├─ Instala plugins Zsh (syntax, autosuggestions)
├─ Instala ferramentas modernas (fzf, ripgrep, fd, bat, exa, htop, neofetch)
├─ Restaura dotfiles (.zshrc, .aliases, etc)
└─ Restaura configurações de apps
```

---

## 🖧 Para Manjaro Específicamente

O auto-setup detecta Manjaro automaticamente e oferece **remover bloatware**:

```
🧹 Removendo Bloatware do Manjaro?
Deseja remover aplicações pré-instaladas desnecessárias? (s/n)
```

Se responder **sim**, remove:
- Thunderbird (cliente email pesado)
- Audacious (player de áudio duplicado)
- KDE extras desnecessários
- Aplicações de desktop sharing
- Gerenciadores de senhas extra
- E mais...

⚠️ **Ainda há muito bloatware?**
Edite `scripts/debloat-manjaro.sh` e adicione mais apps na array `BLOATWARE`

---

## ✅ Checklist Após Setup

- [ ] Terminal aberto com Alacritty?
- [ ] Powerlevel10k mostrando prompt bonito?
- [ ] Aliases funcionando? (teste: `ll`)
- [ ] Autocomplete funcionando? (digitar incompleto)
- [ ] Syntax highlighting funcionando?

---

## ⚙️ Customizações Pós-Setup

### Customizar Powerlevel10k

```bash
# Assistente visual
p10k configure

# Ou editar manualmente
nano ~/.p10k.zsh
```

### Instalar Fonte Melhorada

Para melhor visualização de ícones:

```bash
# Baixar JetBrains Mono Nerd Font
cd ~/Downloads
curl -LOJ https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip JetBrainsMono.zip
mkdir -p ~/.local/share/fonts
cp JetBrainsMono/*.ttf ~/.local/share/fonts/
fc-cache -fv

# Configure seu terminal para usar: JetBrains Mono Nerd Font
```

### Configurar Alacritty

Edite ou crie `~/.config/alacritty/alacritty.toml`:

```bash
nano ~/.config/alacritty/alacritty.toml
```

Ou copie do repositório:
```bash
cp configs/alacritty/alacritty.toml ~/.config/alacritty/
```

---

## 🔄 Próximos Passos

### Exportar Suas Configurações

Depois de customizar tudo:

```bash
# Exportar tudo
bash makefile.sh export

# Ou manualmente
bash scripts/export-packages.sh
bash scripts/backup-configs.sh
```

### Sincronizar com Git

```bash
# Ver mudanças
bash makefile.sh status

# Fazer commit e push
bash makefile.sh commit

# Em outro PC simplesmente:
git pull
```

### Instalar em Novo PC

```bash
git clone seu-repo
cd seu-repo
chmod +x scripts/*.sh
bash scripts/auto-setup.sh
```

---

## 🛠️ Scripts Complementares

Depois do auto-setup, você pode usar:

```bash
# Exportar suas configs atuais
bash makefile.sh export

# Ver status
bash makefile.sh status

# Fazer commit
bash makefile.sh commit

# Sincronizar
bash makefile.sh sync

# Restaurar só dotfiles
bash scripts/setup.sh  # escolha opção 3

# Restaurar só configs de apps
bash scripts/setup.sh  # escolha opção 4

# Limpar temporários
bash makefile.sh clean
```

---

## 🆘 Problemas Comuns

### Problema: "Permission denied" em auto-setup.sh

```bash
chmod +x scripts/auto-setup.sh
bash scripts/auto-setup.sh
```

### Problema: "zsh: command not found" após setup

O Zsh foi definido como shell padrão. Digite:
```bash
exit
# Abra novo terminal
```

### Problema: Powerlevel10k mostra `?` or caracteres errados

Instale uma Nerd Font (veja seção acima)

### Problema: Alacritty não inicia

```bash
# Verificar instalação
alacritty --version

# Ou reinstalar
sudo pacman -S alacritty
```

### Problema: Auto-setup trava em "Instalar packages"

```bash
# Cancelar com Ctrl+C
# E executar manualmente
sudo bash scripts/install-packages.sh
```

---

## 📊 Tempo de Execução

| Etapa | Tempo |
|-------|-------|
| Clone & Permissões | ~30 seg |
| Debloat (Manjaro) | ~2-5 min |
| Atualização Sistema | ~5-15 min |
| Terminal Setup | ~5-10 min |
| Packages | ~10-60 min* |
| Total | ~25-90 min |

*Depende da quantidade de packages

---

## 📞 Suporte

Se tiver problemas:

1. Veja [scripts/README.md](scripts/README.md) para documentação completa
2. Veja [TERMINAL_SETUP.md](../TERMINAL_SETUP.md) para details de ferramentas
3. Veja [WORKFLOW.md](../WORKFLOW.md) para sincronização
4. Leia os comentários dos scripts

---

## 🎉 Pronto!

Seu terminal agora tem:
- ✅ **Alacritty** - Terminal rápido (GPU acelerado)
- ✅ **Zsh** - Shell moderno com plugins
- ✅ **Powerlevel10k** - Prompt visual criativo
- ✅ **Ferramentas modernas** - fzf, ripgrep, fd, bat, exa, etc
- ✅ **Configurações sincronizadas** - Use em múltiplos PCs

**Aproveite seu terminal novo! 🚀**
