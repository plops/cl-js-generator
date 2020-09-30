const {
    app,
    BrowserWindow
} = require("electron");;
let mainWindow = null;;

function createWindow() {
    console.log("hello2 from electron");
    console.log(`node: ${process.versions.node}`);
    console.log(`chrome: ${process.versions.chrome}`);
    console.log(`electron: ${process.versions.electron}`);
    mainWindow = new BrowserWindow({
        width: (1480),
        height: (600),
        webPreferences: ({
            nodeIntegration: (true)
        })
    });
    mainWindow.webContents.loadURL(`file://${__dirname}/index.html`);
    mainWindow.webContents.openDevTools();
};
app.whenReady().then(createWindow);
require("electron-reload")(__dirname);
app.on("window-all-closed", function() {
    unless(((process.platform) == ("darwin")), app.quit());
});
app.on("activate", function() {
    if (((BrowserWindow.getAllWindows().length) === (0))) {
        createWindow();
    };
});