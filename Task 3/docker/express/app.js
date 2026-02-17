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
    const backendURL = process.env.BACKEND_URL || "http://localhost/submit";

    try {
        const response = await fetch(backendURL, {
            method: "POST",
            body: new URLSearchParams(req.body),
            headers: { "Content-Type": "application/x-www-form-urlencoded" }
        });

        const text = await response.text();
        res.send(`<h2>${text}</h2><br><a href="/">Go Back</a>`);
    } catch (error) {
        res.send("Error connecting to backend: " + error.message);
    }
});

app.listen(3000, '0.0.0.0', () => {
    console.log("Frontend running on port 3000");
});

