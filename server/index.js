const express = require("express");
const app = express();
var cors = require("cors")
var bodyParser = require("body-parser")

var port = process.env.PORT || 6000

// var allowCrossDomain = function(req, res, next) {
// 	res.header("Access-Control-Allow-Origin", "*"); // allow requests from any other server
// 	res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'); // allow these verbs
// 	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Cache-Control");
// }
 
// app.use(allowCrossDomain); // plumbing it in as middleware

app.use(bodyParser.json())
app.use(cors())

app.use(bodyParser.urlencoded({ extended: false }))

var API = require('./routes/API')
app.use(API)
app.listen(port, () => {
    console.log("Server running on port: " + port)
});
