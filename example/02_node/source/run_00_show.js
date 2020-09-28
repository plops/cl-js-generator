const Logger = require("./logger");;
const logger = new Logger();;
const path = require("path");;
const os = require("os");;
const fs = require("fs");;
const http = require("http");;
logger.on("messageLogged", function(arg) {
    console.log("listener called", arg);
});
const server = http.createServer();;
server.on("connection", function() {
    console.log("new connection ...");
});
server.listen(3000);
console.log("listening on port 3000 ...");;

function sayHello(name) {
    logger.log((("hello") + (name)));
};
sayHello("Mosh");