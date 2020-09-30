const {
    app,
    BrowserWindow
} = require("electron");;
let mainWindow = null;;
app.on("ready", function() {
    console.log("hello from electron");
    console.log(`file://${__dirname}/index.html`);
    mainWindow = new BrowserWindow({
        webPreferences: {
            worldSafeExecuteJavaScript: true
        }
    });
    mainWindow.webContents.loadURL(`file://${__dirname}/index.html`);
});