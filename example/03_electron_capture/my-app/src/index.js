const {
    app,
    BrowserWindow
} = require("electron");;
let path = require("path");;
let mainWindow = null;;
if (require("electron-squirrel-startup")) {
    app.quit();
};

function createWindow() {
    console.log(`node: ${process.versions.node}`);
    console.log(`chrome: ${process.versions.chrome}`);
    console.log(`electron: ${process.versions.electron}`);
    mainWindow = new BrowserWindow({
        width: (800),
        height: (600),
        webPreferences: ({
            nodeIntegration: (true)
        })
    });
    mainWindow.loadFile(path.join(__dirname, "index.html"));
    mainWindow.webContents.openDevTools();
};
app.on("ready", createWindow);
app.on("window-all-closed", function() {
    unless(((process.platform) == ("darwin")), app.quit());
});
app.on("activate", function() {
    if (((BrowserWindow.getAllWindows().length) === (0))) {
        createWindow();
    };
});