#!/bin/bash

# Script para exportar lista de packages instalados no Arch Linux
# Uso: bash scripts/export-packages.sh

echo "🔍 Exportando packages do Arch Linux..."

# Criar diretório se não existir
mkdir -p packages

# Exportar packages oficiais do pacman (sem dependências)
echo "📦 Exportando pacman packages..."
pacman -Qqe | grep -v "$(pacman -Qqm)" > packages/pacman-packages.txt
echo "✓ Pacman packages salvos em: packages/pacman-packages.txt"

# Exportar packages do AUR (instalados localmente)
echo "🗂️  Exportando AUR packages..."
pacman -Qqm > packages/aur-packages.txt
echo "✓ AUR packages salvos em: packages/aur-packages.txt"

# Exportar packages Python (pip) se pip estiver instalado
if command -v pip &> /dev/null; then
    echo "🐍 Exportando pip packages..."
    pip freeze > packages/pip-packages.txt
    echo "✓ Pip packages salvos em: packages/pip-packages.txt"
else
    echo "⚠️  pip não encontrado, pulando exportação de Python packages"
fi

# Exportar pacotes npm se npm estiver instalado
if command -v npm &> /dev/null; then
    echo "📚 Exportando npm packages (global)..."
    npm list -g --depth=0 | grep "├\|└" | sed 's/.*── //' > packages/npm-packages.txt
    echo "✓ Npm packages salvos em: packages/npm-packages.txt"
else
    echo "⚠️  npm não encontrado, pulando exportação de Node packages"
fi

# Exportar informações do sistema
echo "🖥️  Exportando informações do sistema..."
{
    echo "# Arch Linux System Info - $(date)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Total Packages: $(pacman -Q | wc -l)"
    echo "Pacman: $(pacman -Q | wc -l)"
    pacman -Qqe | grep -v "$(pacman -Qqm)" | wc -l | xargs echo "Official:"
    pacman -Qqm | wc -l | xargs echo "AUR:"
} > packages/system-info.txt
echo "✓ Info do sistema salvo em: packages/system-info.txt"

echo ""
echo "✨ Exportação concluída!"
echo ""
echo "Resumo:"
cat packages/system-info.txt
