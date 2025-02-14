#!/bin/bash

REPO_URL=$1
CLONE_DIR=./repo
LOG_DIR="/logs/$(date +%Y%m%d_%H%M%S)"
RESULTS_FILE="$LOG_DIR/results.txt"

mkdir -p "$LOG_DIR"
touch "$RESULTS_FILE"

git clone "$REPO_URL" "$CLONE_DIR"
cd "$CLONE_DIR"

find . -name Dockerfile | while read dockerfile; do
  context_dir=$(dirname "$dockerfile")
  image_name=$(basename "$context_dir" | tr '[:upper:]' '[:lower:]')
  image_log_dir="$LOG_DIR/$image_name"
  
  mkdir -p "$image_log_dir"
  
  echo "Construyendo imagen: $image_name"
  docker build -t "$image_name" "$context_dir"
  
  echo "Ejecutando contenedor..."
  timestamp=$(date +%Y%m%d_%H%M%S)
  log_file="$image_log_dir/${timestamp}.log"
  docker run --rm --name "${image_name}_container" "$image_name" 2>&1 | tee "$log_file"
  
  time=$(grep -oE '[0-9]+' "$log_file" | head -n1)
  case "$image_name" in
    "go_app") language="Go" ;;
    "rust_app") language="Rust" ;;
    "java_app") language="Java" ;;
    "js_app") language="JavaScript" ;;
    "python_app") language="Python" ;;
    *) language="Desconocido" ;;
  esac
  
  echo "$language|$time|ms" >> "$RESULTS_FILE"
done

TABLE_FILE="$LOG_DIR/execution_summary.txt"
{
  echo "Lenguaje     | Tiempo (ms)"
  echo "-------------|------------"
  awk -F '|' '{printf "%-12s | %9s\n", $1, $2}' "$RESULTS_FILE"
} > "$TABLE_FILE"

echo -e "\n=== Resumen de Tiempos ==="
cat "$TABLE_FILE"
echo -e "\nTabla guardada en: $TABLE_FILE"