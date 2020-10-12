const {
    desktopCapturer,
    remote
} = require("electron");;
const {
    writeFile
} = require("fs");;
const {
    dialog,
    Menu
} = remote
;;

let mediaRecorder = null;;
const recordedChunks = [];;
const videoElement = document.querySelector("video");;

const startBtn = document.getElementById("startBtn");;
startBtn.onclick = function() {
    mediaRecorder.start();
    startBtn.classList.add("is-danger");
    startBtn.innerText = "Recording";
};

const stopBtn = document.getElementById("stopBtn");;
stopBtn.onclick = function() {
    mediaRecorder.stop();
    startBtn.classList.remove("is-danger");
    startBtn.innerText = "start";
};

const videoSelectBtn = document.getElementById("videoSelectBtn");;
videoSelectBtn.onclick = getVideoSources;

async function getVideoSources() {
    const inputSources = await deskopCapturer.getSources({
        types: (["window", "screen"])
    });;
    let videoOptionsMenu = Menu.buildFromTemplate(inputSources.map(function(source) {
        return {
            label: (source.name),
            click: (function() {
                selectSource(source);
            })
        };
    }));;
    videoOptionsMenu.popup();;
}
async function selectSource(source) {
    videoSelectBtn.innerText = source.name;
    const constraints = {
        audio: (false),
        video: ({
            mandatory: ({
                chromeMediaSource: ("desktop"),
                chromeMediaSourceId: (source.id)
            })
        })
    };;
    const stream = await navigator.mediaDevices.getUserMedia(constraints);;
    videoElement.srcObject = stream;
    videoElement.play();
    let options = {
        mimeType: ("video/webm; codecs=vp9")
    };;
    mediaRecorder = new MediaRecorder(stream, options);
    mediaRecorder.ondataavailable = handleDataAvailable;
    mediaRecorder.onstop = handleStop;;;;
}

function handleDataAvailable(e) {
    console.log("video data available");
    recordedChunks.push(e.data);
}
async function handleStop(e) {
    const blob = new Blob(recordedChunks, {
        type: ("video/webm; codecs=vp9")
    });;
    const buffer = Buffer.from(await blob.arrayBuffer());;
    let {
        filePath
    } = await dialog.showSaveDialog({
        buttonLabel: ("save video"),
        defaultPath: (`vid-${Date.now()}.webm`)
    });;
    if (filePath) {
        writeFile(filePath, buffer, function() {
            console.log("video saved successfully.");
        });
    };;
}