#!/bin/bash

LOG_DIR="/logs/$(date +%Y%m%d_%H%M%S)"
RESULTS_FILE="$LOG_DIR/results.txt"
mkdir -p "$LOG_DIR"
touch "$RESULTS_FILE"

# Lista de servicios
SERVICES=("go_app" "java_app" "js_app" "python_app" "rust_app")

for SERVICE_NAME in "${SERVICES[@]}"; do
    SERVICE_LOG_DIR="$LOG_DIR/$SERVICE_NAME"
    mkdir -p "$SERVICE_LOG_DIR"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    LOG_FILE="$SERVICE_LOG_DIR/${TIMESTAMP}.log"

    # Construir solo el servicio actual
    docker-compose -f /app/docker-compose.yml build $SERVICE_NAME

    echo "Ejecutando contenedor: $SERVICE_NAME..."
    docker-compose -f /app/docker-compose.yml run --rm "$SERVICE_NAME" 2>&1 | tee "$LOG_FILE"

    # Extraer tiempo del log
    time=$(grep -oE '[0-9]+' "$LOG_FILE" | head -n1)
    
    # Mapear servicio a lenguaje
    case "$SERVICE_NAME" in
        "go_app") language="Go" ;;
        "rust_app") language="Rust" ;;
        "java_app") language="Java" ;;
        "js_app") language="JavaScript" ;;
        "python_app") language="Python" ;;
        *) language="Desconocido" ;;
    esac
    
    echo "$language|$time|ms" >> "$RESULTS_FILE"

    # Limpiar imágenes y capas intermedias
    docker image rm -f $SERVICE_NAME
    docker system prune -f
done

# Generar tabla de resumen
TABLE_FILE="$LOG_DIR/execution_summary.txt"
{
  echo "Lenguaje     | Tiempo (ms)"
  echo "-------------|------------"
  awk -F '|' '{printf "%-12s | %9s\n", $1, $2}' "$RESULTS_FILE"
} > "$TABLE_FILE"

echo -e "\n=== Resumen de Tiempos ==="
cat "$TABLE_FILE"
echo -e "\nTabla guardada en: $TABLE_FILE"