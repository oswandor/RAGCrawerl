import os
import streamlit as st
from dotenv import load_dotenv
from src.database import Database
from src.openai_helper import OpenAIHelper
from src.crawler import Crawler
from langchain_community.utilities import BingSearchAPIWrapper


# Cargar las variables de entorno desde el archivo .env
load_dotenv()

def main():

    st.title("RAG Scripting")

    # Sesiones para mantener el historial de chat
    if 'history' not in st.session_state:
        st.session_state['history'] = []

    # Obtener la consulta del usuario
    query_text = st.text_input("Escribe tu consulta y presiona Enter", key='user_input')

    if st.button("Enviar"):
        if query_text:

            # Guardar la consulta en el historial
            st.session_state['history'].append({"role": "user", "content": query_text})

            # Inicializar OpenAIHelper y generar embedding
            openai_helper = OpenAIHelper()
            query_embedding = openai_helper.generate_embedding(query_text)
            vector_embedding = '[' + ','.join(map(str, query_embedding)) + ']'

            # Conectar a la base de datos y obtener contexto
            db = Database()
            db.connect()
            context = db.fetch_context(vector_embedding)
            db.close()

            # Si no hay contexto suficiente, usar el Crawler
            if not context.strip():
                print("No se encontró suficiente contexto en la base de datos. Usando el Crawler...")
                os.environ["BING_SUBSCRIPTION_KEY"] = os.environ.get('BING_SUBSCRIPTION_KEY')
                os.environ["BING_SEARCH_URL"] = os.environ.get('BING_SEARCH_URL')
                search = BingSearchAPIWrapper()
                listofresult = search.results(query_text, 1)
                crawler = Crawler(listofresult)
                data = crawler.crawl()
                internet_context = data[0]['content'] if data else "No se encontró información relevante."
                context += "\n" + internet_context

            # Crear el prompt con el contexto y la consulta
            prompt = f"""Usando la siguiente información:
            Claro, también puede dar más contexto a la respuesta con tal que sea más nutrida de información.
            {context}
            Responde a la siguiente pregunta:
            {query_text}"""

            print("Prompt:" + prompt)
            print("\n")
            # Obtener la respuesta de OpenAI
            answer = openai_helper.get_completion(prompt)

            # Guardar la respuesta en el historial
            st.session_state['history'].append({"role": "assistant", "content": answer})


    # Mostrar el historial de conversación
    if st.session_state['history']:

        for chat in st.session_state['history']:
            if chat['role'] == 'user':
                st.markdown(f"**👤 Usuario:** {chat['content']}")
            else:
                st.markdown(f"**🤖 Asistente:** {chat['content']}")


if __name__ == "__main__":
    main()