document.getElementById("startButton").addEventListener("click", function () {
  const configText = document.getElementById("config").value;
  const config = JSON.parse(configText);

  // Send the config to the background script
  chrome.runtime.sendMessage({ config: config });
});
