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
        center: (true),
        show: (false),
        width: (1450),
        height: (600),
        webPreferences: ({
            worldSafeExecuteJavaScript: (true),
            nodeIntegration: (true),
            webviewTag: (true)
        })
    });
    mainWindow.webContents.openDevTools();
    mainWindow.webContents.loadURL(`file://${__dirname}/index.html`);
    mainWindow.webContents.on("dom-ready", function() {
        console.log("user-agent:", mainWindow.webContents.getUserAgent());
        mainWindow.webContents.openDevTools();
        mainWindow.maximize();
        mainWindow.show();
    });
};
app.whenReady().then(createWindow);
app.on("window-all-closed", function() {
    unless(((process.platform) == ("darwin")), app.quit());
});
app.on("activate", function() {
    if (((BrowserWindow.getAllWindows().length) === (0))) {
        createWindow();
    };
});