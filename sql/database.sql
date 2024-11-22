-- 1. Crear las extensiones necesarias
CREATE EXTENSION IF NOT EXISTS azure_ai;
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Configurar Azure OpenAI
SELECT azure_ai.set_setting('azure_openai.endpoint', 'YOUR_ENDPOINT_AZUREOPENAI');
SELECT azure_ai.set_setting('azure_openai.subscription_key', 'YOUR_SUBSCRIPTION_KEY');

-- 3. Crear las tablas
CREATE TABLE documentos (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL
);

-- 4. Crear un índice en la columna de contenido
CREATE TABLE documentos_embeddings (
    documento_id INTEGER PRIMARY KEY REFERENCES documentos(id),
    embedding VECTOR(1536)
);
-- 4. Insertar datos de ejemplo para RAG
INSERT INTO documentos (contenido) VALUES
('¿Cómo puedo restablecer mi contraseña? Para restablecer tu contraseña, haz clic en "¿Olvidaste tu contraseña?" en la página de inicio de sesión, ingresa tu correo electrónico y sigue las instrucciones que te enviemos.'),
('Guía rápida para integrar la API de OpenAI: Primero, obtén tu API Key desde la consola de OpenAI. Luego, configura tu entorno de desarrollo instalando la biblioteca openai mediante pip. Utiliza la función openai.ChatCompletion.create para interactuar con los modelos.'),
('Actualización del producto: Hemos lanzado una nueva funcionalidad en nuestra plataforma que permite a los usuarios colaborar en tiempo real. Esta característica incluye chat en vivo, edición simultánea de documentos y notificaciones automáticas.'),
('Caso de éxito: Una empresa del sector financiero redujo sus costos operativos en un 20% al implementar nuestra solución de automatización de procesos. Esto fue posible gracias al uso de modelos de inteligencia artificial para analizar grandes volúmenes de datos en tiempo real.'),
('Pregunta frecuente: ¿Cuál es la diferencia entre un modelo GPT-3.5 y GPT-4? La principal diferencia radica en la capacidad de procesamiento y la complejidad del lenguaje. GPT-4 es más avanzado, lo que le permite comprender mejor contextos complejos y generar respuestas más precisas.'),
('Tutorial: Cómo configurar un clúster en Azure Kubernetes Service (AKS). Paso 1: Accede a tu portal de Azure y crea un nuevo recurso AKS. Paso 2: Configura los nodos y redes. Paso 3: Implementa tus aplicaciones mediante kubectl y Helm.'),
('Política de privacidad: Nos comprometemos a proteger tu información personal. No compartimos tus datos con terceros sin tu consentimiento, excepto cuando sea requerido por la ley. Puedes actualizar tus preferencias de privacidad en cualquier momento desde la configuración de tu cuenta.'),
('Informe de análisis de mercado: El mercado de la inteligencia artificial está proyectado a crecer a una tasa compuesta anual del 37% hasta 2030, impulsado por la demanda de automatización en diversos sectores, incluyendo salud, finanzas y retail.'),
('Consejo técnico: Para optimizar el rendimiento de los modelos GPT, considera utilizar técnicas de prompt engineering, como proporcionar contextos más específicos y limitar la longitud de la respuesta esperada.'),
('Anuncio de servicio: A partir de diciembre de 2024, nuestra plataforma incluirá soporte nativo para la integración con Microsoft Teams, facilitando la colaboración entre equipos de trabajo.'),
('Reporte de incidente: El 12 de noviembre de 2024, nuestro sistema experimentó una interrupción temporal debido a un fallo en la infraestructura de red. El problema fue solucionado en menos de 2 horas y no hubo pérdida de datos de clientes.'),
('Introducción al machine learning: El aprendizaje automático es una rama de la inteligencia artificial que permite a los sistemas aprender y mejorar automáticamente a partir de la experiencia sin ser programados explícitamente.'),
('Procedimiento: Para solicitar soporte técnico, accede a nuestro portal de ayuda, crea un ticket describiendo tu problema y nuestro equipo se pondrá en contacto contigo en un plazo de 24 horas.'),
('Resumen ejecutivo: Nuestra estrategia para 2025 se centra en la expansión a mercados internacionales, con un enfoque en la digitalización y automatización de servicios para mejorar la eficiencia operativa.'),
('Descripción de producto: Nuestro chatbot basado en inteligencia artificial ofrece soporte al cliente 24/7, capaz de responder preguntas frecuentes, guiar a los usuarios a través de procesos complejos y escalar consultas a agentes humanos cuando sea necesario.');


-- 5. Generar embeddings y almacenarlos
INSERT INTO documentos_embeddings (documento_id, embedding)
SELECT
    d.id,
    azure_openai.create_embeddings('text-embedding-ada-002', d.contenido)::vector
FROM
    documentos d;

-- 6. Crear un índice en la columna de embeddings
CREATE INDEX ON documentos_embeddings USING ivfflat (embedding vector_l2_ops) WITH (lists = 100);


-- 7. Realizar una búsqueda por similitud
SELECT
    d.contenido,
    e.embedding <-> azure_openai.create_embeddings('text-embedding-ada-002', 'Tutorail de como configurar un cluste de AKS')::vector AS distancia
FROM
    documentos d
JOIN
    documentos_embeddings e ON d.id = e.documento_id
ORDER BY
    distancia ASC
LIMIT 5;