var jsonServer = require('json-server');

// return an Express server 
var server = jsonServer.create();

// Set default middlewares (logger, static, cors and no-cache)
server.use(jsonServer.defaults());

var router = jsonServer.router('db.json');
server.use(router);

console.log('Listening at 4000');
server.listen(4000);
