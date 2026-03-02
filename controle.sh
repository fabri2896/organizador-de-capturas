#!/bin/bash
# Script de controle do Organizador de Capturas

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/organizador_tray.py"
PID_FILE="$SCRIPT_DIR/.organizador.pid"
LOG_FILE="$SCRIPT_DIR/organizador.log"

start() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo "⚠️  Organizador já está rodando (PID: $PID)"
            return 1
        else
            rm -f "$PID_FILE"
        fi
    fi
    
    echo "🚀 Iniciando Organizador de Capturas..."
    
    # Inicia o aplicativo em background
    nohup python3 "$PYTHON_SCRIPT" > /dev/null 2>&1 &
    PID=$!
    echo $PID > "$PID_FILE"
    
    sleep 2
    
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ Organizador iniciado com sucesso!"
        echo "📋 PID: $PID"
        echo "📁 Log: $LOG_FILE"
        echo "💡 Procure o ícone na área de notificação"
    else
        echo "❌ Erro ao iniciar o organizador"
        rm -f "$PID_FILE"
        return 1
    fi
}

stop() {
    if [ ! -f "$PID_FILE" ]; then
        echo "⚠️  Organizador não está rodando"
        return 1
    fi
    
    PID=$(cat "$PID_FILE")
    
    if ps -p $PID > /dev/null 2>&1; then
        echo "🛑 Parando Organizador (PID: $PID)..."
        kill $PID
        sleep 2
        
        if ps -p $PID > /dev/null 2>&1; then
            echo "⚠️  Forçando encerramento..."
            kill -9 $PID
        fi
        
        rm -f "$PID_FILE"
        echo "✅ Organizador parado"
    else
        echo "⚠️  Processo não encontrado"
        rm -f "$PID_FILE"
    fi
}

status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo "✅ Organizador está RODANDO"
            echo "📋 PID: $PID"
            echo "📁 Pasta: $SCRIPT_DIR"
            
            if [ -f "$LOG_FILE" ]; then
                echo ""
                echo "📊 Últimas 5 linhas do log:"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                tail -n 5 "$LOG_FILE"
            fi
        else
            echo "❌ Organizador NÃO está rodando (PID obsoleto)"
            rm -f "$PID_FILE"
        fi
    else
        echo "❌ Organizador NÃO está rodando"
    fi
}

restart() {
    echo "🔄 Reiniciando organizador..."
    stop
    sleep 1
    start
}

log() {
    if [ -f "$LOG_FILE" ]; then
        echo "📋 Mostrando log (Ctrl+C para sair):"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        tail -f "$LOG_FILE"
    else
        echo "⚠️  Arquivo de log não encontrado"
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    log)
        log
        ;;
    *)
        echo "🗂️  Organizador de Capturas - Controle"
        echo ""
        echo "Uso: $0 {start|stop|restart|status|log}"
        echo ""
        echo "Comandos:"
        echo "  start    - Inicia o organizador em background"
        echo "  stop     - Para o organizador"
        echo "  restart  - Reinicia o organizador"
        echo "  status   - Verifica se está rodando"
        echo "  log      - Mostra o log em tempo real"
        echo ""
        exit 1
        ;;
esac

exit 0
