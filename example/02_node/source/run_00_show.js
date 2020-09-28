const logger = require("./logger");;
const EventEmitter = require("events");;
let emitter = new(EventEmitter);;
const path = require("path");;
const os = require("os");;
const fs = require("fs");;

function sayHello(name) {
    logger.log((("hello") + (name)));
};
sayHello("Mosh");
console.log(module);
console.log(__filename);
console.log(__dirname);
console.log(path.parse(__filename));
console.log(`totalmem ${os.totalmem()}`);
console.log(`freemem ${os.freemem()}`);
fs.readdir("./", function(err, files) {
    if (err) {
        console.log("Error", err);
    } else {
        console.log("Result", files);
    };
});
emitter.on("messageLogged", function(arg) {
    console.log("listener called", arg);
});
emitter.emit("messageLogged", {
    id: (1),
    url: ("http://")
});