#!/bin/bash
# Script para iniciar o organizador de capturas

echo "🚀 Iniciando Organizador de Capturas..."
echo ""

cd "$(dirname "$0")"

# Verifica se Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 não encontrado!"
    echo "💡 Instale Python 3 para usar este aplicativo"
    exit 1
fi

# Verifica se as bibliotecas estão instaladas
python3 -c "import watchdog, pystray, PIL" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "📦 Instalando dependências necessárias..."
    pip3 install --user watchdog pystray pillow
    echo ""
fi

# Usa o script de controle para iniciar em background
./controle.sh start

# Aguarda um momento
sleep 2

# Mostra notificação de sucesso (se disponível)
notify-send "Organizador de Capturas" "Aplicativo iniciado! Procure o ícone na área de notificação." 2>/dev/null || true

echo ""
echo "✅ Aplicativo rodando em segundo plano!"
echo "💡 Use './controle.sh status' para verificar"
echo "💡 Use './controle.sh stop' para parar"
