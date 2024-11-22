import os
from typing import List

import requests
from openai import AzureOpenAI
from openai.types.chat import ChatCompletionAssistantMessageParam


class OpenAIHelper:
    def __init__(self):

        self.client = AzureOpenAI(
            api_key=os.getenv("AZURE_OPENAI_API_KEY"),
            api_version="2024-06-01",
            azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
        )

    def generate_embedding(self, text, engine="text-embedding-ada-002"):

        response = self.client.embeddings.create(
            input=text,
            model=engine
        )
        embedding = response.data[0].embedding
        return embedding

    def get_completion(self, prompt, temperature=0.7, top_p=0.95, max_tokens=800):

        tokens = prompt.split("\n")  # Divide el texto en tokens

        chat_prompt: List[ChatCompletionAssistantMessageParam] = [
            {
                "role": "system",
                "content": "You are an AI assistant that helps people find information."
            },
        ]

        for segment in tokens:
            # Prepara el prompt de chat para cada segmento
            chat_prompt.append({
                "role": "user",
                "content": f"{segment}"  # Une los tokens del segmento en un solo texto
            })

        # Include speech result if speech is enabled
        speech_result = chat_prompt

        # print("Chat Prompt:" + str(chat_prompt))

        # Generate the completion
        completion = self.client.chat.completions.create(
            model="gpt-35-turbo",
            messages=chat_prompt,
            max_tokens=max_tokens,
            temperature=temperature,
            top_p=top_p,
            frequency_penalty=0,
            presence_penalty=0,
            stop=None,
            stream=False
        )

        try:
            return completion.choices[0].message.content
        except requests.RequestException as e:
            raise SystemExit(f"Failed to make the request. Error: {e}")

