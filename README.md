# MP3 Player Web

MP3 Player Web is a local music player that runs in a desktop browser from this project folder. It does not upload songs anywhere. The user selects local audio files, and the app stores its library inside the browser on the same computer.

## Quick Start

1. Open the project folder.
2. Double-click `MP3 Player.vbs`.
3. The helper starts the local server and opens the app in the browser.
4. If the browser does not open automatically, go to `http://127.0.0.1:4173/`.

Do not open `index.html` directly for normal use. Audio files, IndexedDB storage, and browser permissions work more reliably through the local `127.0.0.1` address.

## Project Files

`index.html` contains the app structure: the header, tabs, song lists, favorites, playlists, group views, full player, mini player, and modal panels.

`styles.css` controls the visual design. The top of the file defines the main color variables. The bottom contains `Web final polish layer`, which applies the current final style: borderless buttons, rounded covers, draggable tabs, equal playlist card height, and corrected shuffle icon alignment.

`app.js` contains the app logic: importing songs, reading metadata, storing songs, searching, favorites, playlists, playback queue, shuffle, repeat, timer, modal panels, full player, and mini player.

`manifest.webmanifest` describes the web app metadata for browsers and PWA-like use.

`icon.svg` is the app icon. It is also shown before the `MP3 Player` title in the header. The header icon is inverted by CSS when dark mode is active.

`MP3 Player.vbs` starts the app with one click and hides the command window.

`start-server.bat` starts the local server on port `4173`.

## Adding Music

Open the `Songs` tab and press `+`. Select one or more audio files. The app adds them to the library and tries to read title, artist, album, genre, and cover art from metadata.

If a file does not contain metadata, the app uses fallback values. The original audio file on disk is not modified.

## Storage

Songs are stored in browser IndexedDB. This keeps the library available after restarting the browser. Removing a song from the app removes it only from the browser library. It does not delete the original file from the computer.

Favorites, playlists, theme, and small settings are stored in `localStorage`.

## Tabs

`Songs` shows the full music library.

`Favorites` shows songs marked with a heart.

`Playlists` shows persistent playlists. They can be created, deleted, opened, played in order, or shuffled.

`Genres`, `Artists`, and `Albums` are generated from song metadata. If metadata is missing, songs are placed into fallback groups.

The tab bar can be moved with a mouse drag, trackpad, or mouse wheel. It is built as a looping strip, so it should feel like it can keep spinning.

## Playback

The play button on a song starts that song. Clicking a song cover also starts that song and opens the full player.

`Play all` builds a queue from the current section and plays it in order.

Shuffle randomizes the entire current section and plays that shuffled queue. It does not play only one random song.

The mini player stays fixed at the bottom of the screen while a song is selected. When it is visible, the list gets extra bottom space so the last song is not hidden behind the mini player.

## Full Player

The full player opens from a song cover or from the mini player. It shows cover art, title, artist, queue position, seek bar, previous button, play or pause, next button, timer, like, repeat, and queue controls.

Repeat has three states: off, repeat one song, and repeat the current list.

## Search

Search opens as an in-app panel styled like the rest of the player. It matches text inside song titles and artists. For example, typing `vo` shows all songs containing `vo` in their searchable fields.

## Playlists

In the `Playlists` tab, `+` creates a playlist. The search button filters playlists by name.

Click a playlist card to open it. Inside a playlist you can play all songs, shuffle them, add songs, and remove songs from that playlist.

Deleting a playlist asks for confirmation. Songs inside the playlist remain in the app library.

Playlist cards are intentionally the same height family as song rows, so the section feels compact and consistent.

## Song Actions

Each song row has a properties button with three dots. It opens actions for the selected song: add to favorites, add to playlist, or remove from the app.

Removing a song asks for confirmation. The original file on the computer is not deleted.

## Themes

The top-right button switches between light and dark two-color modes. The main colors are controlled by CSS variables in `:root` and `body.theme-dark` inside `styles.css`.

Important color variables:

```css
--bg
--panel
--text
--muted
--line
--strong-line
```

## Changing The Design

To change song row size, edit `.song-row`.

To change cover size or corner radius, edit `.song-cover`, `.group-cover`, and `.cover-art`.

To change the top tab strip, edit `.toolbar` and `.pill`.

To change buttons, edit `.icon-button`, `.tiny-button`, `.round-button`, `.play-button`, and `.play-mode-button`.

To change playlist cards, edit `.playlist-card`, `.playlist-header`, `.playlist-name`, and `.playlist-preview`.

To change the mini player, edit `.mini-player`, `#miniTitle`, and `#miniState`.

For the latest design overrides, start with the `Web final polish layer` block at the bottom of `styles.css`.

## Changing Behavior

File import starts from the `fileInput` handler and the song loading functions in `app.js`.

Sorting is handled by `sortedSongs()`.

Shuffle behavior is handled by `shuffleSongs()` and the shuffle button handlers.

Playback starts through `playSong()` and the song row event handlers.

The mini player is controlled by `updateMiniPlayerVisibility()` and `renderPlayer()`.

Playlist display and editing are handled by `renderPlaylists()`, `renderPlaylist()`, `openPlaylistDetailPanel()`, and the state saving functions.

Modal panels are controlled by `openPanel()`, `closePanel()`, `openConfirmDialog()`, and related panel functions.

The looping tab bar is initialized in `setupInfiniteToolbar()`. Mouse drag support is also inside that function.

## Replacing The Icon

Replace `icon.svg` with another SVG file. If the header icon should continue to invert with the theme, keep `.brand-icon { filter: var(--icon-filter); }` in `styles.css`.

## Moving The Project

Copy the whole project folder. Run `MP3 Player.vbs` from the new location. The folder moves the app code, but the music library itself is stored in the browser profile on one computer. On a new computer, add songs again with the `+` button.

## Common Problems

If the app does not open, check `http://127.0.0.1:4173/`.

If the port is busy, close the old server process or change the port in both `start-server.bat` and `MP3 Player.vbs`.

If songs disappear after clearing browser data, IndexedDB was probably cleared. Add the songs again.

If cover art does not appear, the file may not contain embedded cover art or the browser could not read it.

If search finds nothing, clear the search panel and check the current tab. Search filters only the active section.
