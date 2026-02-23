# 📋 Ordem de Execução e Dependências dos Scripts

## Hierarquia de Dependências

```
┌─────────────────────────────────────────────────────────────┐
│                    auto-setup.sh                            │
│           (Orquestrador principal)                          │
└─────────────────────────────────────────────────────────────┘
        ↓           ↓           ↓          ↓          ↓
    ┌───┴───┬───────┴─────┬────┴────┬────┴────┬────┴─────┐
    │       │             │         │         │          │
    ▼       ▼             ▼         ▼         ▼          ▼
[Prereq] [Distro] [Debloat] [Update] [Terminal] [Packages]
    │       │        │         │         │         │
    │       │        │         │         │         │
    └───────┴────────┴─────────┴─────────┴─────────┘
                      ↓
                 [Setup/Config]
```

## 📍 Ordem Correta de Execução

### 1️⃣ **check-prerequisites.sh** ⭐ (PRIMEIRO)
**Status:** ✓ CRÍTICO  
**Dependências:** Nenhuma (verificações básicas)  
**O que faz:**
- Verifica distribuição (Arch/Manjaro)
- Valida permissões sudo
- Testa conectividade internet
- Verifica espaço em disco
- Instala ferramentas essenciais (git, curl, base-devel)

**Por que primeiro:** Sem isso, outros scripts podem falhar.

---

### 2️⃣ **auto-setup.sh** (executa sequencialmente)
O script principal coordena a ordem.

**Sequência interna:**

#### A) Detectar distribuição
- Lê `/etc/os-release`
- Define `IS_MANJARO` flag

#### B) **debloat-manjaro.sh** (se Manjaro)
**Status:** ✓ OPCIONAL  
**Dependências:** sudo  
**Requer:** Estar em Manjaro  
**O que faz:** Remove 50+ aplicações pré-instaladas

---

#### C) Atualizar sistema
**Status:** ✓ CRÍTICO  
**Depende de:** conectividade internet  
```bash
sudo pacman -Syu --noconfirm
```
**Por que:** Garante pacotes atualizados antes de instalar outros

---

#### D) **install-terminal.sh**
**Status:** ✓ IMPORTANTE  
**Dependências:** 
- sudo ✓
- pacman ✓
- git ✓ (instalado em prerequisites)
- curl ✓ (instalado em prerequisites)
- zsh (vai ser instalado)

**O que faz:**
- Instala Alacritty (terminal)
- Instala Zsh + Oh My Zsh
- Instala Powerlevel10k
- Instala plugins e ferramentas auxiliares

---

#### E) **export-packages.sh** (se necessário)
**Status:** ⚠ OPCIONAL  
**Dependências:**
- pacman ✓
- npm ✓ (opcional)
- pip ✓ (opcional)

**O que faz:**
- Exporta lista de pacotes instalados
- Gera arquivos em `packages/`

---

#### F) **install-packages.sh** (se desejado)
**Status:** ⚠ OPCIONAL  
**Dependências:**
- sudo ✓
- pacman ✓
- yay/paru (AUR helper) ⚠ (não instalado por padrão)

**Por que pode falhar:** Se não tiver AUR helper, vai falhar em packages AUR

---

#### G) **setup.sh**
**Status:** ✓ IMPORTANTE  
**Dependências:** nenhuma crítica  
**O que faz:** Menu interativo para restaurar configurações

---

## 🚀 Scripts Opcionais (Fora de auto-setup.sh)

### **install-lunarvim.sh**
**Status:** ✓ OPCIONAL (IDE)  
**Dependências:**
- neovim 0.9+ ou será instalado ✓
- git ✓
- node.js ✓
- Acesso à internet ✓

**Ordem:** Pode ser executado depois do main setup  
**Comando:** `bash scripts/install-lunarvim.sh`

---

### **install-docker.sh**
**Status:** ✓ OPCIONAL (Docker)  
**Dependências:**
- sudo ✓
- pacman ✓
- Acesso à internet ✓

**Ordem:** Pode ser executado depois do main setup  
**Comando:** `bash scripts/install-docker.sh`

---

### **install-portainer.sh**
**Status:** ✓ OPCIONAL (UI Docker)  
**Dependências:**
- Docker **DEVE** estar instalado e **RODANDO** ⚠🔴
- curl (verificação)
- Acesso à internet ✓

**Ordem:** DEVE SER DEPOIS de `install-docker.sh`  
**Comando:** `bash scripts/install-portainer.sh`

---

## 📊 Verificação de Dependências Críticas

| Script | Dependência | Status | Verificação |
|--------|-------------|--------|-------------|
| check-prerequisites | bash | ✓ Crítico | Pré-instalado |
| debloat-manjaro | sudo | ✓ Crítico | `sudo -n true` |
| auto-setup | bash, jq | ✓ Crítico | Pré-instalado |
| install-terminal | pacman, git, curl | ✓ Crítico | `which pacman` |
| install-packages | yay/paru | ⚠ Opcional | `which yay` |
| install-docker | pacman, systemd | ✓ Crítico | `which pacman` |
| install-portainer | docker | 🔴 **CRÍTICO** | `docker ps` |
| install-lunarvim | neovim, git, node | ⚠ Semi | `which neovim` |

---

## ⚠️ Potenciais Problemas & Soluções

### ❌ Problema 1: Executar Portainer antes de Docker
```bash
# ❌ ERRADO:
bash scripts/install-portainer.sh
# → Erro: Docker não encontrado

# ✅ CORRETO:
bash scripts/install-docker.sh
bash scripts/install-portainer.sh
```

### ❌ Problema 2: Packages AUR sem helper
```bash
# ❌ ERRADO (se não tiver yay/paru):
sudo bash scripts/install-packages.sh
# → Erro: yay não encontrado para pacotes AUR

# ✅ CORRETO (instalar antes):
sudo pacman -S yay
sudo bash scripts/install-packages.sh
```

### ❌ Problema 3: Terminal não instalado antes de usar shell novo
```bash
# ❌ ERRADO (pular install-terminal.sh):
bash scripts/auto-setup.sh
# → Shell continua bash por default

# ✅ CORRETO:
# auto-setup.sh executa install-terminal.sh automaticamente
```

### ❌ Problema 4: Requisitos do sistema não verificados
```bash
# ❌ ERRADO (começar direto):
bash scripts/install-terminal.sh
# → Pode falhar se base-devel não estiver instalado

# ✅ CORRETO:
bash scripts/check-prerequisites.sh
bash scripts/install-terminal.sh
```

---

## 📈 Progresso & Logging

### Auto Tracking
`auto-setup.sh` agora cria 2 arquivos de rastreamento:

1. **Log completo:** `.setup-logs/auto-setup_TIMESTAMP.log`
   ```
   [2026-02-23 13:30:45] [INFO] Verificar pré-requisitos
   [2026-02-23 13:30:50] [SUCCESS] Check completado
   ```

2. **Progresso:** `.setup-logs/setup-progress.txt`
   ```
   1/7 | Verificar pré-requisitos | ✓ CONCLUÍDO
   2/7 | Detectar distribuição | ✓ Manjaro
   3/7 | Remover bloatware | ✓ CONCLUÍDO
   ```

### Como Monitorar
```bash
# Ver log em tempo real
tail -f .setup-logs/auto-setup_*.log

# Ver progresso
cat .setup-logs/setup-progress.txt
```

---

## 🔄 Fluxo de Execução Recomendado

### Novo PC - Setup Completo
```bash
# 1. Clonar repositório
git clone https://github.com/K-sous4/archlinux-setup.git
cd archlinux-setup

# 2. Dar permissão
chmod +x scripts/*.sh

# 3. Verificar pré-requisitos (IMPORTANTE!)
bash scripts/check-prerequisites.sh

# 4. Executar setup completo (vai coordenar tudo)
bash scripts/auto-setup.sh

# 5. (Opcional) Instalar Docker
bash scripts/install-docker.sh

# 6. (Opcional) Instalar Portainer (DEPOIS de Docker)
bash scripts/install-portainer.sh

# 7. (Opcional) Instalar LunarVim
bash scripts/install-lunarvim.sh
```

### Após Reboot
```bash
# Terminal deve estar novo (Alacritty + Zsh)
# LunarVim pronto para usar
# Docker pronto para usar

# Customizar Powerlevel10k
p10k configure

# Acessar Portainer (se instalado)
# Abra: http://localhost:9000
```

---

## 📚 Referência Rápida

| Tarefa | Comando |
|--------|---------|
| Verificar sistema | `bash scripts/check-prerequisites.sh` |
| Setup completo | `bash scripts/auto-setup.sh` |
| Apenas terminal | `sudo bash scripts/install-terminal.sh` |
| Apenas Docker | `bash scripts/install-docker.sh` |
| Apenas Portainer | `bash scripts/install-portainer.sh` (após Docker) |
| Apenas LunarVim | `bash scripts/install-lunarvim.sh` |
| Menu manual | `bash scripts/setup.sh` |
| Ver log | `tail -f .setup-logs/auto-setup_*.log` |

---

## ✅ Checklist Final

Após `auto-setup.sh`:
- [ ] Terminal aberto é Alacritty
- [ ] Shell é Zsh (`echo $SHELL`)
- [ ] Powerlevel10k prompt visível
- [ ] Aliases funcionando (`alias ll`)
- [ ] Ferramentas disponíveis (`fzf`, `ripgrep`, etc)

---

**Última atualização:** 2026-02-23  
**Versão:** 2.0 (com logging e progresso)
