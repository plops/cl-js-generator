const Logger = require("./logger");;
const logger = new Logger();;
const path = require("path");;
const os = require("os");;
const fs = require("fs");;
logger.on("messageLogged", function(arg) {
    console.log("listener called", arg);
});

function sayHello(name) {
    logger.log((("hello") + (name)));
};
sayHello("Mosh");