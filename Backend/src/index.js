const express = require('express')
const app = express()
const port = app.get('port');
require('./connection');


app.listen(port);
console.log('Servidor en Localhost:3000')
