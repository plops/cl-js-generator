const {
    app,
    BrowserWindow
} = require("electron");;
let mainWindow = null;;

function createWindow() {
    console.log("hello from electron");
    mainWindow = new BrowserWindow({
        width: (800),
        height: (600),
        webPreferences: ({
            nodeIntegration: (true)
        })
    });
    mainWindow.webContents.loadURL(`file://${__dirname}/index.html`);
    mainWindow.webContents.openDevTools();
};
app.whenReady().then(createWindow);