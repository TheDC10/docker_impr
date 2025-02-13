#!/bin/bash

REPO_URL=$1
CLONE_DIR=./repo
LOG_DIR="/logs/$(date +%Y%m%d_%H%M%S)"

mkdir -p $LOG_DIR

git clone $REPO_URL $CLONE_DIR
cd $CLONE_DIR

find . -name Dockerfile | while read dockerfile; do
  context_dir=$(dirname $dockerfile)
  image_name=$(basename $context_dir | tr '[:upper:]' '[:lower:]')
  image_log_dir="$LOG_DIR/$image_name"
  
  mkdir -p $image_log_dir
  
  echo "Construyendo imagen: $image_name"
  docker build -t $image_name $context_dir
  
  echo "Ejecutando contenedor y guardando resultados..."
  timestamp=$(date +%Y%m%d_%H%M%S)
  docker run --rm \
    --name "${image_name}_container" \
    $image_name \
    2>&1 | tee "$image_log_dir/${timestamp}.log"
  
  echo "Logs guardados en: $image_log_dir/${timestamp}.log"
done

echo "Todos los logs disponibles en: $LOG_DIR"