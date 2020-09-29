const {
    app,
    BrowserWindow
} = require("electron");;
let mainWindow = null;;
app.on("ready", function() {
    console.log("hello from electron");
    console.log(`file://${__dirname}/index.html`);
    mainWindow = new BrowserWindow;
    mainWindow.webContents.loadFile(`file://${__dirname}/index.html`);
});