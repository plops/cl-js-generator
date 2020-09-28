let url = "http://mylogger.io/log";;
const EventEmitter = require("events");;
let emitter = new(EventEmitter);;

function log(message) {
    console.log(message);
    emitter.emit("messageLogged", {
        id: (1),
        url: ("http://")
    });
};
module.exports = log;