let player = document.getElementById("player");;

function logger(message) {
    if ((("object") == (typeof(message)))) {
        log.innnerHTML += (((((JSON) && (JSON.stringify))) ? (JSON.stringify(message)) : (message)) + ("<br />"));
    } else {
        log.innnerHTML += ((message) + ("<br />"));
    };
};