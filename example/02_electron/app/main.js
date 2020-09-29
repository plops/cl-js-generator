const {
    app,
    BrowserWindow
} = require("electron");;
let mainWindow = null;;
app.on("ready", function() {
    console.log("hello from electron");
    mainWindow = new BrowserWindow;
    mainWindow.webContents.loadFile("index.html");
});