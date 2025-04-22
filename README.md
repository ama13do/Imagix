# Imagix
Monorepo(Backend y frontend) de el previsualizador de imagenología para el track de salud digna
# Plataforma de Previsualización DICOM Inclusiva para Comunidades Marginadas

[![Licencia](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Contribuciones](https://img.shields.io/badge/Contribuciones-Bienvenidas-brightgreen.svg)](https://github.com/TU_USUARIO/TU_REPOSITORIO/CONTRIBUTING.md)

Esta plataforma innovadora ofrece una solución completa para la previsualización de imágenes DICOM (.dcm) y directorios DICOM (PACS/DICOMDIR), enfocándose en la accesibilidad y la inclusión para comunidades indígenas marginadas, personas con daltonismo, adultos mayores y personas con poca familiaridad con la tecnología digital. Nuestra aplicación multiplataforma busca ser intuitiva, amigable y promover una salud digna.

## Características Principales

La plataforma se divide en dos secciones principales: el Backend y el Frontend.

### Backend

* **Tecnología:** API desarrollada con **TypeScript** y **Node.js**.
* **Infraestructura en la Nube:** Desplegado en **Amazon Web Services (AWS)**.
* **Compatibilidad con Código Científico:** Gestiona la ejecución y compatibilidad con código desarrollado en **MATLAB** y **Python**, permitiendo la aplicación de filtros y scripts personalizados a las imágenes DICOM.
* **Escalabilidad y Confiabilidad:** La infraestructura en AWS garantiza la escalabilidad y alta disponibilidad de la API.

### Frontend

El frontend se compone de dos aplicaciones distintas:

* **Aplicación Móvil (Flutter):**
    * Desarrollada con **Flutter** para ofrecer una experiencia nativa en dispositivos **Android** e **iOS**.
    * **Acceso Offline:** Todos los recursos visualizados se guardan automáticamente en el dispositivo, permitiendo el acceso sin conexión a internet o con conexiones de banda ancha limitada.
    * **Diseño Inclusivo:** Interfaz de usuario intuitiva y amigable, con consideraciones especiales para personas con daltonismo, adultos mayores y usuarios con poca experiencia digital.

* **Aplicación Web (React + Vite):**
    * Desarrollada con **React** y **Vite** para una experiencia web rápida y moderna.
    * **Previsualización Completa:** Ofrece todas las funcionalidades esenciales de un previsualizador DICOM para médicos.
    * **Funcionalidades Únicas:** Permite la aplicación de filtros y la ejecución de scripts desarrollados en MATLAB y Python, integrando capacidades avanzadas de procesamiento de imágenes.

## Instalación

A continuación, se describen los comandos básicos para instalar las dependencias necesarias para cada parte del frontend.

### React + Vite (Aplicación Web)

1.  **Requisitos:** Asegúrate de tener **Node.js** y **npm** (o **yarn** o **pnpm**) instalados en tu sistema. Puedes descargarlos desde [https://nodejs.org/](https://nodejs.org/).

2.  **Clonar el repositorio:**
    ```bash
    git clone TU_REPOSITORIO_WEB.git
    cd TU_REPOSITORIO_WEB
    ```

3.  **Instalar las dependencias:**
    Con **npm:**
    ```bash
    npm install
    ```
    Con **yarn:**
    ```bash
    yarn install
    ```
    Con **pnpm:**
    ```bash
    pnpm install
    ```

4.  **Iniciar el servidor de desarrollo:**
    Con **npm:**
    ```bash
    npm run dev
    ```
    Con **yarn:**
    ```bash
    yarn dev
    ```
    Con **pnpm:**
    ```bash
    pnpm dev
    ```

    La aplicación web estará disponible en `http://localhost:5173` (u otra dirección proporcionada por Vite).

### Flutter (Aplicación Móvil)

1.  **Requisitos:** Asegúrate de tener el **SDK de Flutter** instalado y configurado en tu sistema. Sigue las instrucciones de instalación para tu sistema operativo en la documentación oficial de Flutter: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install). También necesitarás **Android Studio** o **Xcode** configurados para el desarrollo móvil.

2.  **Clonar el repositorio:**
    ```bash
    git clone TU_REPOSITORIO_MOVIL.git
    cd TU_REPOSITORIO_MOVIL
    ```

3.  **Obtener las dependencias:**
    ```bash
    flutter pub get
    ```

4.  **Ejecutar la aplicación:**
    Conecta un dispositivo móvil o inicia un emulador/simulador y ejecuta:
    ```bash
    flutter run
    ```

    Esto construirá e instalará la aplicación en tu dispositivo o emulador.

## Despliegue en la Nube

A continuación, se presentan los comandos y conceptos básicos para el despliegue en AWS y Google Cloud.

### Amazon Web Services (AWS)

El backend de esta plataforma está diseñado para ser desplegado en AWS. A continuación, se mencionan algunos de los servicios clave que podrían estar involucrados y los conceptos básicos para su despliegue:

* **Servicios de Contenedores (Opcional):**
    * **Amazon ECS (Elastic Container Service) o Amazon EKS (Elastic Kubernetes Service):** Para contenerizar y orquestar la aplicación Node.js. Necesitarás Dockerfiles para construir las imágenes de tus contenedores y definiciones de tareas/pods para desplegarlos.
        * **Docker:** `docker build -t backend-api .`
        * **AWS CLI (para ECS):** `aws ecs register-task-definition --cli-input-json file://task-definition.json` y `aws ecs run-task --cluster tu-cluster --task-definition tu-definicion-de-tarea`
        * **kubectl (para EKS):** `kubectl apply -f deployment.yaml` y `kubectl apply -f service.yaml`
* **AWS Lambda (Alternativa para API):** Para desplegar la API de Node.js como funciones sin servidor. Necesitarás empaquetar tu código y definir la función Lambda.
    * **AWS CLI:** `aws lambda create-function --function-name tu-funcion --zip-file fileb://tu-paquete.zip --handler index.handler --runtime nodejsXX.x --role arn:aws:iam::TU_CUENTA:role/tu-rol-lambda`
* **Amazon EC2 (Elastic Compute Cloud):** Para desplegar la aplicación Node.js en servidores virtuales. Necesitarás configurar una instancia EC2, instalar Node.js y desplegar tu código.
    * **AWS CLI:** `aws ec2 run-instances --image-id ami-XXXXXXXXXXXXXXX --instance-type t2.micro --key-name tu-par-de-claves --security-group-ids sg-XXXXXXXXXXXXXXX`
* **Amazon RDS (Relational Database Service) o Amazon DynamoDB (NoSQL):** Para la base de datos de la aplicación.
    * **AWS CLI (para RDS):** `aws rds create-db-instance --db-instance-identifier tu-basededatos --engine mysql --master-username tuusuario --master-password tucontraseña --db-instance-class db.t2.micro --allocated-storage 20`
* **Amazon S3 (Simple Storage Service):** Para almacenamiento de archivos, como imágenes DICOM.
    * **AWS CLI:** `aws s3 mb s3://tu-bucket-dicom` y `aws s3 cp archivo.dcm s3://tu-bucket-dicom/`
* **AWS API Gateway:** Para crear y gestionar la API que el frontend consumirá.
    * Configuración a través de la consola de AWS o con herramientas como AWS CloudFormation o Serverless Framework.

**Nota:** Estos son comandos y conceptos muy básicos. El despliegue real en AWS requerirá una configuración más detallada de la infraestructura, seguridad, redes, etc. Te recomendamos consultar la documentación oficial de AWS para cada servicio.

### Google Cloud Platform (GCP)

Si bien el backend actual está en AWS, aquí te presentamos alternativas y comandos básicos para un despliegue similar en Google Cloud:

* **Google Cloud Run:** Para desplegar aplicaciones en contenedores de forma serverless. Necesitarás un Dockerfile para tu aplicación Node.js.
    * **Docker:** `docker build -t gcr.io/tu-proyecto-id/backend-api .` y `docker push gcr.io/tu-proyecto-id/backend-api`
    * **gcloud CLI:** `gcloud run deploy --image gcr.io/tu-proyecto-id/backend-api --platform managed`
* **Google Cloud Functions:** Para desplegar la API de Node.js como funciones serverless. Necesitarás empaquetar tu código.
    * **gcloud CLI:** `gcloud functions deploy tu_funcion --runtime nodejs18 --entry-point index --trigger-http --source .`
* **Google Compute Engine (GCE):** Para desplegar la aplicación Node.js en máquinas virtuales. Necesitarás crear una instancia, instalar Node.js y desplegar tu código.
    * **gcloud CLI:** `gcloud compute instances create tu-instancia --zone us-central1-a --machine-type e2-medium --image-project debian-cloud --image-family debian-11`
* **Cloud SQL (MySQL, PostgreSQL, SQL Server) o Firestore (NoSQL):** Para la base de datos de la aplicación.
    * **gcloud CLI (para Cloud SQL):** `gcloud sql instances create tu-instancia --database-version MYSQL_8_0 --region us-central1 --tier db-f1-micro`
* **Google Cloud Storage:** Para almacenamiento de archivos DICOM.
    * **gsutil CLI:** `gsutil mb gs://tu-bucket-dicom` y `gsutil cp archivo.dcm gs://tu-bucket-dicom/`
* **Cloud Endpoints o API Gateway:** Para crear y gestionar la API.
    * Configuración a través de la consola de Google Cloud o con herramientas como Service Infrastructure.

**Nota:** Al igual que con AWS, estos son comandos y conceptos introductorios. Un despliegue completo en GCP requerirá una configuración más exhaustiva de la infraestructura, seguridad, redes, etc. Consulta la documentación oficial de Google Cloud para obtener detalles específicos.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, revisa nuestro [CONTRIBUTING.md](https://github.com/TU_USUARIO/TU_REPOSITORIO/CONTRIBUTING.md) para obtener más detalles sobre cómo puedes ayudar.

## Licencia

Este proyecto está bajo la licencia [MIT](https://opensource.org/licenses/MIT). Consulta el archivo `LICENSE` para obtener más información.

## Contacto

[TU_NOMBRE] - [TU_CORREO_ELECTRÓNICO]
[ENLACE_A_TU_PERFIL_DE_GITHUB]
