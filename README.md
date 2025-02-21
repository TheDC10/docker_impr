# Ejecución de la imagen en Play with Docker (PWD)

- Devs: Daniel Geraldino Rivadeneira, Camilo De La Rosa Castañeda

Este repositorio contiene los recursos necesarios para construir y ejecutar un contenedor Docker que automatiza la construcción de imágenes desde un repositorio de GitHub. A continuación, se detallan los pasos para ejecutarlo en [Play with Docker (PWD)](https://labs.play-with-docker.com/).

## 🚀 Pasos para ejecutar en PWD

### 1. Crear directorio para logs y actualizar paquetes e instalar Git

```bash
mkdir logs && apk update && apk add git
```

### 2. Clonar el repositorio del Dockerfile

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

## 🔍 Explicación de los comandos

- **Montaje de `/var/run/docker.sock`**: Permite al contenedor interactuar con el Docker host para construir imágenes.
- **Volumen `/root/logs:/logs`**: Persiste los logs generados en el directorio `logs` del host.
- **Repositorio de GitHub**: Se especifica el repositorio objetivo ([Test-Codes.git](https://github.com/dygeraldino/Test-Codes.git)) como argumento final.

## 📌 Notas importantes

- **Play with Docker (PWD)**:

  - Las sesiones son temporales (máximo 4 horas). Descarga los logs manualmente si necesitas conservarlos.
  - El directorio `logs` se crea en la raíz del usuario (`/root/logs`).

- **Seguridad**: El uso de `docker.sock` otorga privilegios completos de Docker. Solo ejecuta contenedores de confianza.

---

El contenedor construirá y ejecutara las imágenes definidas en el repositorio `Test-Codes.git` y guardará los logs en `/root/logs` para finalmente mostrar los resultados de los benchmarks en una tabla.
