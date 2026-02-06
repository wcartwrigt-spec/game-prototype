# Testing

## Windows
1. Open the repo folder.
2. Double-click `export-html5/index.html` to open in your default browser.
3. Verify the page loads and the title reads "MagiWolf Quest".

## Chromebook
1. Open the repo folder in Files.
2. Navigate to `export-html5/index.html` and open it in Chrome.
3. Verify the page loads and the title reads "MagiWolf Quest".
4. If clicking "New Adventure" does nothing, use the fallback local server below (file:// can block localStorage).

## Chrome autoplay notes
- This build has no audio, so autoplay prompts should not appear.
- If you add audio later, Chrome may require a click before playback.

## Fallback local server
If the browser blocks file access, run a local server from the repo root:

```powershell
python -m http.server 8000
```

Then open `http://localhost:8000/export-html5/index.html` in your browser.
