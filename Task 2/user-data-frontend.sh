#!/bin/bash
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

export BACKEND_URL="http://${backend_private_ip}:5000/submit"

mkdir -p /frontend/views
cd /frontend

cat <<'EOF' > app.js
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
    const backendURL = process.env.BACKEND_URL || "http://localhost:5000/submit";

    try {
        const response = await fetch(backendURL, {
            method: "POST",
            body: new URLSearchParams(req.body),
            headers: { "Content-Type": "application/x-www-form-urlencoded" }
        });

        const text = await response.text();
        res.send(`<h2>$${text}</h2><br><a href="/">Go Back</a>`);
    } catch (error) {
        res.send("Error connecting to backend: " + error.message);
    }
});

app.listen(3000, '0.0.0.0', () => {
    console.log("Frontend running on port 3000");
});

EOF

cat <<'EOF' > views/index.ejs
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

cat <<'EOF' > package.json
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
