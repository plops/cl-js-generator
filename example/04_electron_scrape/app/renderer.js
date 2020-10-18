const webview = document.querySelector("webview");;
webview.addEventListener("dom-ready", function() {
    let currentURL = webview.getURL();;
    let title = webview.getTitle();;
    console.log((("currentURL=") + (currentURL)));
    console.log((("title=") + (title)));
    webview.executeJavaScript(`function gethtml(){
return new Promise((resolve,reject)=>{resolve(document.documentElement.innerHTML);});}
gethtml();`).then(function(html) {
        console.log(html);
    });;
});