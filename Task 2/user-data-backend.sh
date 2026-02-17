#!/bin/bash
yum update -y
yum install -y python3 python3-pip
pip3 install flask

mkdir -p /backend

cat <<'EOF' > /backend/app.py
from flask import Flask, jsonify, request, render_template
import os
import json

app = Flask(__name__)

DATA_FILE = "data.txt"

def save_to_file(data):
    
    """Append data as JSON line in data.txt"""

    with open(DATA_FILE, "a") as f:
        f.write(json.dumps(data) + "\n")


def read_all_data():
    
    """Read all JSON lines from data.txt"""
    
    if not os.path.exists(DATA_FILE):
        return []

    result = []
    
    with open(DATA_FILE, "r") as f:
        for line in f:
            line = line.strip()
            if line:
                result.append(json.loads(line))
    
    return result

@app.route("/")
def home():
    return "Flask backend is running"


@app.route("/submit", methods=["POST"])
def submit():
    form_data = dict(request.form)
    save_to_file(form_data)

    return "Data submitted successfully"


@app.route("/api")
def api():
    data = read_all_data()
    return jsonify({"data": data})


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)

EOF

pip3 install flask
nohup python3 /backend/app.py &

