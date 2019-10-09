const express = require("express");
const app = express();
var cors = require("cors")
var bodyParser = require("body-parser")

var port = process.env.PORT || 6000

app.use(bodyParser.json())
app.use(cors())
app.use(bodyParser.urlencoded({ extended: false }))

var API = require('./routes/API')

app.use(API)
app.listen(port, () => {
    console.log("Server running on port: " + port)
});