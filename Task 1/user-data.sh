#!/bin/bash
yum update -y

# Install Python
yum install python3 -y
yum install -y python3-pip
pip3 install flask

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install nodejs -y

# Backend
mkdir /backend
cat <<EOF > /backend/app.py
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

# Frontend
mkdir -p /frontend/views

# app.js
cat <<EOF > /frontend/app.js
const express = require("express");
const bodyParser = require("body-parser");
const fetch = require("node-fetch");
const path = require("path");

const app = express();

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.get("/", (req, res) => {
    res.render("index");
});

app.post("/submit", async (req, res) => {
    const backendURL = "http://localhost:5000/submit";

    try {
        const response = await fetch(backendURL, {
            method: "POST",
            body: new URLSearchParams(req.body),
            headers: { "Content-Type": "application/x-www-form-urlencoded" }
        });

        const text = await response.text();
        res.send(\`<h2>\${text}</h2><br><a href="/">Go Back</a>\`);
    } catch (error) {
        res.send("Error connecting to backend: " + error.message);
    }
});

app.listen(3000, '0.0.0.0', () => {
    console.log("Frontend running on port 3000");
});
EOF

# index.ejs
cat <<EOF > /frontend/views/index.ejs
<!DOCTYPE html>
<html>
<head>
    <title>Form</title>
</head>
<body>
<p>Form</p>

<form action="/submit" method="post">
    <label>Name</label>
    <input type="text" name="name" placeholder="Enter your name"><br>

    <label>Email</label>
    <input type="email" name="email" placeholder="Enter your email"><br>

    <input type="submit" value="Submit">
</form>

</body>
</html>
EOF

# package.json
cat <<EOF > /frontend/package.json
{
  "name": "frontend-node",
  "version": "1.0.0",
  "main": "app.js",
  "type": "commonjs",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "body-parser": "^1.20.2",
    "ejs": "^3.1.9",
    "express": "^4.18.2",
    "node-fetch": "^2.6.7"
  }
}
EOF

cd /frontend
npm install
nohup npm start &