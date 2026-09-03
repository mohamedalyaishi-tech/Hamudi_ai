import os
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)
GROQ_API_KEY = os.environ.get('GROQ_API_KEY')

@app.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.json
        response = requests.post(
            'https://api.groq.com/openai/v1/chat/completions',
            headers={
                'Authorization': f'Bearer {GROQ_API_KEY}',
                'Content-Type': 'application/json'
            },
            json=data
        )
        return jsonify(response.json())
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 10000))
    app.run(host='0.0.0.0', port=port)
