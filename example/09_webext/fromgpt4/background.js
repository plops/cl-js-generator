chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {
  if (message.config) {
    const { targeturl, outputdirectory } = message.config;

    // Fetch the specified URL
    fetch(targeturl)
      .then(function (response) {
        return response.text();
      })
      .then(function (html) {
        // Parse the HTML to extract image and video URLs
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, "text/html");
        const mediaUrls = [];

        // Extract image URLs
        const imageElements = doc.getElementsByTagName("img");
        for (let i = 0; i < imageElements.length; i++) {
          const imageUrl = imageElements[i].src;
          mediaUrls.push(imageUrl);
        }

        // Extract video URLs
        const videoElements = doc.getElementsByTagName("video");
        for (let i = 0; i < videoElements.length; i++) {
          const videoUrl = videoElements[i].src;
          mediaUrls.push(videoUrl);
        }

        // Download the media files
        mediaUrls.forEach(function (url) {
          chrome.downloads.download({ url: url, filename: outputdirectory + "/" + getFilename(url) });
        });
      });
  }
});

function getFilename(url) {
  const urlParts = url.split("/");
  return urlParts[urlParts.length - 1];
}
