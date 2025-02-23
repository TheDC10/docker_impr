# Ejecución de la imagen en Play with Docker (PWD)

- **Devs**: Daniel Geraldino Rivadeneira, Camilo De La Rosa Castañeda

Este repositorio contiene los recursos necesarios para construir y ejecutar un contenedor Docker que automatiza la construcción y evaluación de imágenes Docker para aplicaciones en múltiples lenguajes. A continuación, se detallan los pasos para ejecutarlo en [Play with Docker (PWD)](https://labs.play-with-docker.com/).

---

## 🚀 Pasos para ejecutar en PWD

### 1. Crear directorio para logs y actualizar paquetes
```bash
mkdir logs && apk update && apk add git
```

### 2. Clonar el repositorio del proyecto
```bash
git clone https://github.com/TheDC10/docker_impr
```

### 3. Acceder al directorio del proyecto
```bash
cd docker_impr/build_base
```

### 4. Construir la imagen `docker-builder`
```bash
docker build -t docker-builder .
```

### 5. Ejecutar el contenedor con Docker-in-Docker (DinD)
```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/logs:/logs \
  docker-builder
```

---

## 🔍 Explicación de los comandos
- **`-v /var/run/docker.sock:/var/run/docker.sock`**:  
  Permite al contenedor interactuar con el Docker host para construir/ejecutar imágenes.

- **`-v $(pwd)/logs:/logs`**:  
  Persiste los logs generados en el directorio `logs` del host.

---

## 📌 Notas importantes
- **Play with Docker (PWD)**:  
  - Sesiones temporales (máximo 4 horas). Descarga los logs manualmente si necesitas conservarlos.  
  - Los logs se guardan en `docker_impr/build_base/logs/`.  

- **Seguridad**:  
  El uso de `docker.sock` otorga privilegios completos de Docker. Solo ejecuta contenedores de confianza.

---

## 📈 Ventajas del Proyecto Mejorado

### 1. 🧩 Gestión centralizada con Docker Compose
- **Definición declarativa**: Cada servicio (Go, Java, etc.) se configura en `docker-compose.yml`.  
- **Construcción paralelizable**: Servicios independientes y escalables.  
- **Ejemplo**:  
  ```yaml
  services:
    go_app:
      build: /repo/go_app
    # ...otros servicios
  ```

### 2. 🧹 Limpieza automatizada
- Elimina imágenes intermedias después de cada ejecución:  
  ```bash
  docker image rm -f $SERVICE_NAME
  docker system prune -f
  ```

### 3. 🔄 Flujo optimizado
- **Logs estructurados por servicio**:  
  ```bash
  /logs/
    ├── go_app/
    ├── rust_app/
    └── ... 
  ```
- **Mapeo directo servicio-lenguaje**: Evita ambigüedades (ej: `js_app` → JavaScript).

### 4. 🛠️ Configuración predecible
- **Repositorio integrado**:  
  ```dockerfile
  RUN git clone https://github.com/dygeraldino/Test-Codes /repo
  ```
  No requiere argumentos externos para clonar repositorios.

### 5. 📊 Resultados confiables
- **Aislamiento de servicios**: Cada contenedor se ejecuta en un contexto independiente.  
- **Tabla de resumen automática**:  
  ```
  === Resumen de Tiempos ===
  Lenguaje     | Tiempo (ms)
  -------------|------------
  Go          |        120
  Rust        |         95
  ```

---

## 🚨 Comparativa vs. Proyecto Original
| Característica          | Proyecto Original               | Proyecto Mejorado               |
|-------------------------|---------------------------------|---------------------------------|
| Gestión de servicios    | Búsqueda dinámica de Dockerfiles | Definición en `docker-compose.yml` |
| Limpieza                | Manual                          | Automatizada                    |
| Logs                   | Directorio único                | Estructurados por servicio      |
| Dependencias           | Requería URL como argumento     | Repo pre-clonado en la imagen   |
| Mantenibilidad         | Frágil (scripts complejos)      | Modular y escalable             |

---

✨ **Conclusión**:  
El proyecto mejorado ofrece un flujo *estructurado*, *reproducible* y *eficiente en recursos*, ideal para escenarios de benchmarking o CI/CD donde el orden y la trazabilidad son críticos.
```
