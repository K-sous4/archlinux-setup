#!/bin/bash

# Makefile simplificado em bash para facilitar comandos comuns
# Uso: bash makefile.sh [comando]

case "$1" in
    export)
        echo "📦 Exportando configurações..."
        bash scripts/export-packages.sh
        bash scripts/backup-configs.sh
        ;;
    
    install)
        echo "⚙️  Instalando packages..."
        sudo bash scripts/install-packages.sh
        ;;
    
    setup)
        echo "🚀 Setup completo..."
        bash scripts/setup.sh
        ;;
    
    dotfiles)
        echo "📝 Restaurando dotfiles..."
        bash -c 'bash scripts/setup.sh <<< "3"'
        ;;
    
    configs)
        echo "⚙️  Restaurando configs..."
        bash -c 'bash scripts/setup.sh <<< "4"'
        ;;
    
    status)
        echo "📊 Status do repositório"
        echo ""
        echo "Pacman packages: $(wc -l < packages/pacman-packages.txt 2>/dev/null || echo 0)"
        echo "AUR packages: $(wc -l < packages/aur-packages.txt 2>/dev/null || echo 0)"
        echo "Dotfiles: $(ls -1 dotfiles/ 2>/dev/null | wc -l)"
        echo "Configs: $(ls -1d configs/*/ 2>/dev/null | wc -l)"
        echo ""
        git status --short
        ;;
    
    sync)
        echo "🔄 Sincronizando com remoto..."
        git pull origin main
        git status
        ;;
    
    commit)
        DATE=$(date '+%Y-%m-%d %H:%M')
        echo "💾 Fazendo commit..."
        git add .
        git commit -m "Update Arch Linux setup - $DATE"
        git push origin main
        ;;
    
    clean)
        echo "🧹 Limpando arquivos temporários..."
        find . -name "*.swp" -delete
        find . -name "*~" -delete
        find . -name ".DS_Store" -delete
        echo "✓ Limpeza concluída"
        ;;
    
    help|"")
        cat << 'EOF'
Arch Linux Setup - Automação de Comandos

Uso: bash makefile.sh [comando]

Comandos disponíveis:
  export       - Exportar packages e configurações
  install      - Instalar packages a partir dos arquivos
  setup        - Setup completo em novo PC (menu interativo)
  dotfiles     - Restaurar apenas dotfiles
  configs      - Restaurar apenas configurações de apps
  status       - Ver status do repositório
  sync         - Atualizar repositório do remoto (git pull)
  commit       - Fazer commit e push de todas as mudanças
  clean        - Limpar arquivos temporários
  help         - Mostrar esta mensagem

Exemplos:
  bash makefile.sh export      # Salvar atual setup no repo
  bash makefile.sh status      # Ver o que mudou
  bash makefile.sh commit      # Fazer commit das mudanças
  bash makefile.sh sync        # Puxar atualizações
  bash makefile.sh install     # Instalar packages
EOF
        ;;
    
    *)
        echo "❌ Comando desconhecido: $1"
        echo "Use: bash makefile.sh help"
        exit 1
        ;;
esac
