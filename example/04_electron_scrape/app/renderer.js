const webview = document.querySelector("webview");;
const cheerio = require("cheerio");;

function extractLinks(html) {
    const h = cheerio.load(html);;
    h("a").each(function(i, element) {
        console.log((("href: ") + (h(element).attr("href"))))
        console.log((("text: ") + (h(element).text())));
    });;
};
webview.addEventListener("dom-ready", function() {
    let currentURL = webview.getURL();;
    let title = webview.getTitle();;
    console.log((("currentURL=") + (currentURL)));
    console.log((("title=") + (title)));
    webview.executeJavaScript(`function gethtml(){
return new Promise((resolve,reject)=>{resolve(document.documentElement.innerHTML);});}
gethtml();`).then(function(html) {
        extractLinks(html);
    });;
});