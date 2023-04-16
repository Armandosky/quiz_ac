import userRouter from './routes/users.route';

const express = require('express')
const app = express()

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.set('port', 3000);

app.use('api/user', userRouter);

module.exports = app
