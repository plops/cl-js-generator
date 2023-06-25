# File Downloader WebExtension

The File Downloader WebExtension is a browser extension that allows
you to download images and videos from a specified URL. With this
extension, you can easily save media files from web pages to your
local machine.

## Features

- Easy configuration: Simply provide a JSON configuration that
  includes the target URL and output directory for downloaded files.
- Fetch and extract: The extension fetches the specified URL and
  extracts the image and video URLs from the page.
- Bulk download: All extracted media files are automatically
  downloaded and stored in the specified output directory.
- Cross-browser compatibility: The WebExtension is compatible with
  both Firefox and Chromium-based browsers.

## Getting Started

To get started, follow these steps:

1. Clone or download the repository to your local machine.
2. Load the extension in your browser:
   - For Firefox: Open Firefox and navigate to
     `about:debugging`. Click on "This Firefox" and choose "Load
     Temporary Add-on." Select any file within the downloaded
     repository to load the extension temporarily.
   - For Chromium-based browsers: Open your browser and navigate to
     the extensions management page (`chrome://extensions` in Google
     Chrome). Enable "Developer mode" and click on "Load unpacked" to
     select the downloaded repository folder.
3. Open the browser action popup of the extension and paste the JSON
   configuration in the provided textarea.
4. Click the "Start Download" button, and the extension will fetch the
   specified URL, extract the media URLs, and initiate the file
   downloads to the specified output directory.

## Configuration

The extension expects a JSON configuration with the following
properties:

- `targeturl`: The URL of the web page from which to download media
  files.
- `outputdirectory`: The directory where downloaded files should be
  saved. It should be in the format `path/to/directory`.

Example Configuration:
```json
{
  "targeturl": "https://example.com",
  "outputdirectory": "downloads/media"
}
```

<!-- ## Contributing -->

<!-- Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request. -->

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the code according to the terms of the license.

## Disclaimer

The File Downloader WebExtension is provided as-is without any
warranty. Use it at your own risk.

## Credits

This WebExtension is inspired by the work of [OpenAI
ChatGPT](https://openai.com/). Special thanks to the open-source
community for their contributions.

<!-- ## Contact -->

<!-- If you have any questions or feedback, you can reach out to us at [email@example.com](mailto:email@example.com). We'd love to hear from you! -->
