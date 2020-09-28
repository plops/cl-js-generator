const logger = require("./logger");;
const path = require("path");;
const os = require("os");;

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