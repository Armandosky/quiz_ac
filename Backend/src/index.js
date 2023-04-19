const app = require('./app')
const port = app.get('port');
require('./connection');


require('./connection');

app.listen(port);
console.log('Servidor en Localhost:3000')