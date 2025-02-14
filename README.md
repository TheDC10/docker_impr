# Dockerfile-solution

### Ejecución de la imagen en Play with Docker (PWD)

Este repositorio contiene los recursos necesarios para construir y ejecutar un contenedor Docker que automatiza la construcción y ejecución de imágenes desde un repositorio de GitHub. A continuación, se detallan los pasos para ejecutarlo en [Play with Docker (PWD)](https://labs.play-with-docker.com/).

## 🚀 Pasos para ejecutar en PWD

### 1. Crear directorio para logs

```bash
mkdir logs
```

### 2. Actualizar paquetes e instalar Git

```bash
apk update && apk add git
```

### 3. Clonar el repositorio del Dockerfile

```bash
git clone https://github.com/dygeraldino/Dockerfile-solution.git
```

### 4. Acceder al directorio del proyecto

```bash
cd Dockerfile-solution
```

### 5. Construir la imagen `docker-builder`

```bash
docker build -t docker-builder .
```

### 6. Ejecutar el contenedor con Docker-in-Docker (DinD)

```bash
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /root/logs:/logs \
  docker-builder \
  https://github.com/dygeraldino/Test-Codes.git
```

## 🔍 Explicación de los comandos

- **Montaje de `/var/run/docker.sock`**: Permite al contenedor interactuar con el Docker host para construir imágenes.
- **Volumen `/root/logs:/logs`**: Persiste los logs generados en el directorio `logs` del host.
- **Repositorio de GitHub**: Se especifica el repositorio objetivo (`Test-Codes.git`) como argumento final.

## 📌 Notas importantes

- **Play with Docker (PWD)**:

  - Las sesiones son temporales (máximo 4 horas). Descarga los logs manualmente si necesitas conservarlos.
  - El directorio `logs` se crea en la raíz del usuario (`/root/logs`).

- **Seguridad**: El uso de `docker.sock` otorga privilegios completos de Docker. Solo ejecuta contenedores de confianza.

---

El contenedor ejecutará las imágenes definidas en el repositorio `Test-Codes.git` y guardará los logs en `/root/logs`.
