const Logger = require("./logger");;
const logger = new Logger();;
const path = require("path");;
const os = require("os");;
const fs = require("fs");;
const http = require("http");;
logger.on("messageLogged", function(arg) {
    console.log("listener called", arg);
});
const server = http.createServer(function(req, res) {
    if (((req.url) === ("/"))) {
        res.write("hello world")
        res.end();
    };
    if (((req.url) === ("/api/courses"))) {
        res.write(JSON.stringify([1, 2, 3]))
        res.end();
    };
});;
server.listen(3000);
console.log("listening on port 3000 ...");;

function sayHello(name) {
    logger.log((("hello") + (name)));
};
sayHello("Mosh");