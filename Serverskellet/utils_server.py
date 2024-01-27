from flask import Flask, request, jsonify
import pandas as pd

app = Flask(__name__)

def process_csv(data):
    df = pd.read_csv(data)
    result = df.describe().to_dict()
    return result

@app.route('/upload_csv', methods=['POST'])
def upload_csv():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})
    
    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No selected file'})

    try:
        result = process_csv(file)
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
