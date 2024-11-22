import psycopg2
import os
import time

class Database:
    def __init__(self):
        self.conn = None
        self.cursor = None
        self.db_params = {
            "host": os.environ.get('DB_HOST'),
            "database": os.environ.get('DB_NAME'),
            "user": os.environ.get('DB_USER'),
            "password": os.environ.get('DB_PASSWORD')
        }

    def connect(self, max_retries=5, retry_delay=10):
        for attempt in range(max_retries):
            try:
                self.conn = psycopg2.connect(**self.db_params)
                self.cursor = self.conn.cursor()
                print("Conexión a la base de datos exitosa")
                break
            except psycopg2.OperationalError as e:
                print(f"Error de conexión: {e}")
                if attempt < max_retries - 1:
                    print(f"Reintentando en {retry_delay} segundos...")
                    time.sleep(retry_delay)
                else:
                    print("No se pudo conectar a la base de datos después de varios intentos")
                    raise

    def fetch_context(self, vector_embedding, limit=5):
        self.cursor.execute("""
            SELECT d.contenido
            FROM documentos d
            JOIN documentos_embeddings e ON d.id = e.documento_id
            ORDER BY e.embedding <-> %s::vector ASC
            LIMIT %s
        """, (vector_embedding, limit))
        results = self.cursor.fetchall()
        context = "\n".join([row[0] for row in results])
        return context

    def close(self):
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
