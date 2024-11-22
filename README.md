

Para configurar y ejecutar tu proyecto, necesitarás el siguiente software y dependencias:

1. **Python**: Asegúrate de tener Python 3.11.00 o superior instalado. Puedes descargarlo desde [python.org](https://www.python.org/downloads/).

2. **pip**: El instalador de paquetes de Python, que generalmente se incluye con las instalaciones de Python.

3. **pgAdmin**: Para administrar tu base de datos PostgreSQL. Puedes descargarlo desde [pgadmin.org](https://www.pgadmin.org/download/).

4. **Git**: Para control de versiones y clonar el repositorio. Puedes descargarlo desde [git-scm.com](https://git-scm.com/downloads).

5. **Paquetes de Python requeridos**: Listados en tu archivo `requirements.txt`. Estos se pueden instalar usando pip.

6. **Variables de entorno**: Asegúrate de tener un archivo `.env` con las variables de entorno necesarias.

7. **Bing Search API Key**: Necesitarás una clave de suscripción de Bing Search para acceder a los servicios de búsqueda de Bing.

8. **Azure OpenAI API Key**: Necesitarás una clave de API de Azure OpenAI para acceder a los servicios de Azure OpenAI. 

9. **Terrafom**: Para la infraestructura como código, necesitarás Terraform instalado en tu máquina. Puedes descargarlo desde [terraform.io](https://www.terraform.io/downloads.html).

10. **Azure CLI**: Para interactuar con Azure desde la línea de comandos, necesitarás Azure CLI instalado en tu máquina. Puedes descargarlo desde [docs.microsoft.com](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

11. **Docker Desktop**: Para ejecutar la aplicación en un contenedor Docker, necesitarás Docker Desktop instalado en tu máquina. Puedes descargarlo desde [docker.com](https://www.docker.com/products/docker-desktop).

12. **Pycharm**: Para editar y ejecutar el código, necesitarás un editor de código como Pycharm. Puedes descargarlo desde [jetbrains.com](https://www.jetbrains.com/pycharm/download/).


Aquí tienes un resumen de los pasos para configurar tu proyecto:

1. **Clonar el repositorio**:
   ```sh
   git clone <repository_url>
   cd <repository_directory>
   ```

2. **Crear un entorno virtual** (opcional pero recomendado):
   ```sh
   python -m venv venv
   source venv/bin/activate  # En Windows usa `venv\Scripts\activate`
   ```

3. **Instalar las dependencias**:
   ```sh
   pip install -r requirements.txt
   ```

4. **Configurar las variables de entorno**: Crea un archivo `.env` en el directorio raíz de tu proyecto con el siguiente contenido:
   ```env
   AZURE_OPENAI_API_KEY="your_azure_openai_api_key"
   AZURE_OPENAI_ENDPOINT="your_azure_openai_endpoint"
   DB_HOST="your_db_host"
   DB_NAME="your_db_name"
   DB_USER="your_db_user"
   DB_PASSWORD="your_db_password"
   BING_SUBSCRIPTION_KEY="your_bing_subscription_key"
   BING_SEARCH_URL="your_bing_search_url"
   ```

5. **Ejecutar el proyecto**:
   ```sh
   python main.py
   ```

### Ejecutar con Docker

Build the Docker image using the docker build command. Open a terminal, navigate to your project directory, and run:  
```shell 
docker build -t my-streamlit-app .
```
This command will build the Docker image and tag it as my-streamlit-app.  
Run the Docker container using the docker run command:  
```shell
docker run -p 8501:8501 my-streamlit-app
```
