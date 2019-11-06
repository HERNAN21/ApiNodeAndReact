const express = require("express")
const api = express.Router()
const cors = require('cors')
// const db = require("../database/db_local")
api.use(cors())
// process.env.SECRET_KEY = 'secret'
const api_name = "/pdr_api/v1";

// const AWS = require('aws-sdk');
// global.fetch = require('node-fetch');

// Start api solicitud
// Parameters
api.get(api_name + '/test', (req, res) => {
    // console.log('Hola Mundo')
    res.json({'result':'success','mesage':'hello world'});
    console.log('Hola')
    // db.sequelize
    //     .query('select codigo as value, descripcion as label,* from general where grupo = :grupo',
    //         { replacements: { grupo: req.params.grupo }, type: db.sequelize.QueryTypes.SELECT }
    //     )
    //     .then((result) => {
    //         res.json(result);
    //     });
});


module.exports = api

// https://www.youtube.com/watch?v=WxhFq64FQzA
// https://www.youtube.com/watch?v=hyERULl9jns


