import os
from flask import Flask, request, jsonify, send_from_directory
from openai import AzureOpenAI
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

api_key = os.getenv("AZURE_OPENAI_API_KEY") 
endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
deployment_id = os.getenv("AZURE_OPENAI_DEPLOYMENT_ID")

client = AzureOpenAI(
    api_key=api_key,
    api_version="2024-02-01",
    azure_endpoint=endpoint
)

@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/embed', methods=['POST'])
def embed():
    data = request.json
    user_input = data.get('text')

    if not user_input:
        return jsonify({"error": "No text provided"}), 400

    response = client.embeddings.create(
        input=user_input,
        model=deployment_id  # Use deployment_id as model
    )

    embedding = response.data[0].embedding

    return jsonify({"embedding": embedding})

if __name__ == '__main__':
    app.run(debug=True)