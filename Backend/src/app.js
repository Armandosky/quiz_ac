const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.set('port', 3000);

app.use(require('./controllers/users.controller'));

module.exports = app;