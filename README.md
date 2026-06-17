# MP3 Player

[English version](#engVer)

Мобильный веб-плеер для локальных аудиофайлов. Он запускается как обычное локальное приложение через `MP3 Player.vbs`, открывается в браузере и хранит музыку внутри браузерного хранилища.

## Запуск плеера

1. Откройте папку проекта, это может быть любая папка `C:\Users\path\in\`

2. Откройте терминал в этой папке и введиете `git clone https://github.com/dumuzeyn/MP3-player-as-web-app`
> Если вы не знаете как запустить терминал в папке, то нажмите комбинацию клафишь `win + r`, напишите в появившемся окне `cmd`, откроется термнинал в котором надо ввести `cd C:\Users\path\in\`, а далее выполнить команду из второго пункта.

3. После загрузки репозитория в папке появиться файл `MP3 Player.vbs`, при его нажатии приложение запуститься
> Скрипт скрыто запускает локальный сервер на `127.0.0.1:4173`, а потом браузер открывает плеер автоматически

Для удобного доступа можете создать ссылку на `MP3 Player.vbs` на рабочем столе, начальном экране или панели задач.

## Как устроено приложение

Приложение состоит из статических файлов: `index.html`, `styles.css`, `app.js`, `manifest.webmanifest` и `icon.svg`. Сервер нужен только потому, что браузеры безопаснее работают с аудио, IndexedDB и локальными ресурсами через `http://127.0.0.1`, а не через прямое открытие HTML-файла.

`MP3 Player.vbs` запускает сервер скрыто, чтобы пользователь не держал открытой командную строку и не вводил адрес вручную. Поэтому приложение ощущается как отдельная программа, хотя внутри остается обычным веб-приложением.

## Хранение музыки

Когда пользователь добавляет аудиофайлы, приложение читает файл в браузере и сохраняет запись в IndexedDB. Это нужно, чтобы добавленные песни оставались в приложении после перезапуска страницы.

Избранное, плейлисты, режим темы и другие легкие настройки хранятся в `localStorage`. Так быстрее: сами аудиофайлы тяжелые и лежат в IndexedDB, а маленькие списки идентификаторов проще и быстрее держать отдельно.

Удаление песни из приложения удаляет только запись из IndexedDB и списков приложения. Исходный файл на устройстве не удаляется.

## Метаданные и обложки

При добавлении файла приложение пытается прочитать ID3-метаданные: название, исполнитель, альбом, жанр и обложку. Если в файле нет нужной информации, используются безопасные значения: имя файла, неизвестный исполнитель, неизвестный альбом или жанр.

Обложки берутся из метаданных песни. Если обложки нет, показывается простой резервный квадрат, чтобы карточки не ломались и интерфейс оставался ровным.

## Воспроизведение

Кнопка play у отдельной песни запускает только эту песню. Если она закончилась и повтор не включен, очередь очищается и мини-плеер исчезает.

Кнопка "Все подряд" собирает очередь из всех песен текущего раздела. Кнопка случайного воспроизведения перемешивает список перед запуском.

В большом плеере есть три режима повтора:

- `Выкл` - трек или очередь заканчиваются обычным образом.
- `Песня` - текущая песня повторяется заново.
- `Список` - после последней песни очередь начинается сначала.

Повтор одной песни имеет приоритет над одиночным запуском. Поэтому если песня была запущена как одиночная, а потом включен повтор песни, она будет повторяться.

## Мини-плеер и большой плеер

Мини-плеер закреплен снизу экрана через `position: fixed`, поэтому он доступен без прокрутки длинного списка. При открытии большого плеера мини-плеер скрывается, чтобы не дублировать управление. После выхода из большого плеера мини-плеер возвращается, если песня выбрана.

Большой плеер показывает обложку, название, исполнителя, позицию в очереди, таймер сна, лайк, повтор, прогресс и основные кнопки управления. Обложка ограничена по высоте, чтобы на телефоне она помещалась целиком и не вытесняла кнопки.

## Избранное

Песня добавляется в избранное через меню свойств или кнопку лайка в большом плеере. В разделе "Избранное" повторное нажатие на заполненное сердце убирает песню из избранного.

В режиме добавления в избранное можно отметить несколько песен. Отметка не запускает песню и не прокручивает список. Для прослушивания есть отдельная кнопка play в строке.

## Плейлисты

Плейлисты постоянные: они сохраняются в `localStorage` и остаются после перезапуска приложения. В карточке плейлиста показывается название, количество песен, обложка первой песни и список входящих треков.

Внутри плейлиста можно:

- запустить все песни подряд;
- запустить песни случайно;
- добавить новые песни;
- убрать песню из плейлиста;
- удалить плейлист с подтверждением.

Добавление песен в плейлист работает через режим выбора: пользователь отмечает несколько песен, потом подтверждает добавление кнопкой `+`. Это сделано, чтобы случайное нажатие по строке не меняло плейлист сразу.

## Жанры, исполнители и альбомы

Разделы "Жанры", "Исполнители" и "Альбомы" группируют песни по метаданным. Обложка группы берется из первой песни группы. Внутри группы можно открыть список песен, запустить его подряд или перемешать.

## Поиск

Поиск работает по совпадению части текста. Если ввести `во`, приложение показывает все песни или плейлисты, где эта последовательность есть в названии. Поиск не меняет сами данные, он только фильтрует текущий список на экране.

## Темы

В правом верхнем углу есть кнопка переключения темы. Доступны два режима:

- белый фон и черный текст;
- черный фон и белый текст.

Цветов намеренно только два. Это уменьшает визуальный шум, ускоряет дальнейший ретекстуринг и делает интерфейс проще для проверки.

## Почему сделано именно так

Приложение сделано без сборщика и тяжелого фреймворка, чтобы его можно было открыть, скопировать на GitHub и запускать простым локальным сервером. Вся логика находится в `app.js`, стили в `styles.css`, а структура в `index.html`.

IndexedDB выбран для песен, потому что аудиофайлы могут быть большими. `localStorage` выбран для плейлистов и настроек, потому что это маленькие данные, которые нужно быстро читать при старте.

Мини-плеер вынесен в фиксированный слой, потому что списки могут быть длинными. Без этого управление уезжает вниз страницы и пользоваться плеером неудобно.

Для скроллбара используется стабильное место, чтобы интерфейс не смещался при переходе между разделами с длинными и пустыми списками.

## Файлы

- `index.html` - структура интерфейса.
- `styles.css` - черно-белые темы, адаптивная верстка, карточки и панели.
- `app.js` - вся логика плеера, библиотеки, плейлистов, избранного и интерфейса.
- `manifest.webmanifest` - описание приложения для браузера.
- `icon.svg` - простая иконка приложения.
- `MP3 Player.vbs` - запуск приложения одним файлом без видимой командной строки.
- `start-server.bat` - запасной ручной запуск сервера.
- `LICENSE` - условия бесплатного личного и учебного использования.


## Лицензия

Проект можно бесплатно использовать, копировать и изменять для личных, учебных и некоммерческих целей. Коммерческое распространение запрещено без письменного разрешения автора. Подробности в `LICENSE`.

> **Автор проекта: Зейналов У.Р.о.**

---
<h1 id = engVer>
MP3 Player
</h1>

A mobile-style web player for local audio files. It launches like a local app through `MP3 Player.vbs`, opens in the browser, and stores imported music inside browser storage without deleting the original files from the device.

## How to start
1. Open the project tool; this can be any folder in C:\Users\path\in\.

2. Open a terminal in this menu and enter git clone https://github.com/dumuzeyn/MP3-player-as-web-app.
> If you don't know how to launch a terminal in the console, press win + r and type cmd in the window that appears. A terminal will open. Enter cd C:\Users\path\in\, followed by the command to adjust the settings from step 2.

3. After downloading the repository, the MP3 Player.vbs file will appear. Run the application if needed.
> The script silently launches a local server on 127.0.0.1:4173, and then the browser automatically opens the player.

For easy access, you can create a link to MP3 Player.vbs on your desktop, Start screen, or taskbar.

## Application Structure

The app is made from static files: `index.html`, `styles.css`, `app.js`, `manifest.webmanifest`, and `icon.svg`. The local server is used because browsers handle audio, IndexedDB, and local resources more reliably and safely through `http://127.0.0.1` than through a directly opened HTML file.

`MP3 Player.vbs` starts the server in the background, so the user does not need to keep a command window open or type the address manually. The app feels like a standalone program while staying a normal web application internally.

## Music Storage

When the user adds audio files, the app reads them in the browser and stores song records in IndexedDB. This keeps imported songs available after the page is restarted.

Favorites, playlists, theme mode, and other lightweight settings are stored in `localStorage`. This split is faster: large audio data belongs in IndexedDB, while small lists of IDs are quick and simple in `localStorage`.

Removing a song from the app deletes only the browser-side record and references inside the app. The original file on the device is not deleted.

## Metadata and Covers

During import, the app tries to read ID3 metadata: title, artist, album, genre, and cover image. If a file does not contain enough metadata, the app falls back to safe values such as the file name, unknown artist, unknown album, or unknown genre.

Covers are taken from song metadata. If no cover exists, the UI shows a simple fallback square so cards keep their shape.

## Playback

The play button on an individual song starts only that song. If it ends and repeat is disabled, the queue is cleared and the mini player disappears.

The "play all" button builds a queue from all songs in the current section. The shuffle button randomizes that queue before starting playback.

The full player has three repeat modes:

- `Off` - the current song or queue ends normally.
- `Song` - the current song restarts.
- `List` - the queue starts again after the last song.

Single-song repeat has priority over one-shot playback. So if a song was started as a one-shot track and repeat song is enabled later, it repeats correctly.

## Mini Player and Full Player

The mini player is fixed to the bottom of the viewport with `position: fixed`, so it stays available without scrolling through a long list. When the full player opens, the mini player hides to avoid duplicate controls. When the full player closes, the mini player returns if a song is selected.

The full player shows cover art, title, artist, queue position, sleep timer, like button, repeat mode, progress, and main transport controls. The cover is height-limited so it remains fully visible on phones and does not push the buttons off-screen.

## Favorites

A song can be added to favorites from the song menu or from the like button in the full player. In the Favorites section, pressing the filled heart again removes the song from favorites.

In add-to-favorites mode, multiple songs can be selected. Selecting a row does not start playback and does not scroll the list. Preview playback uses a separate play button in the row.

## Playlists

Playlists are persistent: they are stored in `localStorage` and remain after restarting the app. A playlist card shows its name, song count, the cover of the first song, and the list of included tracks.

Inside a playlist, the user can:

- play all songs in order;
- play songs randomly;
- add new songs;
- remove a song from the playlist;
- delete the playlist with confirmation.

Adding songs to a playlist uses a selection mode: the user selects several songs and confirms with the `+` button. This prevents accidental row taps from changing the playlist immediately.

## Genres, Artists, and Albums

Genres, Artists, and Albums group songs by metadata. Each group uses the first song cover as its cover. A group can be opened, played in order, or shuffled.

## Search

Search works by partial text match. If the user types `vo`, the app shows all songs or playlists whose names contain that sequence. Search does not change stored data; it only filters the visible list.

## Themes

The button in the top-right corner switches between two modes:

- white background with black text;
- black background with white text.

Only two colors are used on purpose. This keeps the interface quiet, makes future retexturing easier, and simplifies visual testing.

## Why It Works This Way

The app avoids build tools and heavy frameworks so it can be copied, uploaded to GitHub, and served by a simple local server. All behavior lives in `app.js`, styles live in `styles.css`, and structure lives in `index.html`.

IndexedDB is used for songs because audio files can be large. `localStorage` is used for playlists and settings because these are small pieces of data that should load immediately.

The mini player is fixed because song lists can be long. Without a fixed layer, playback controls would move to the bottom of the page and become inconvenient.

Stable scrollbar space is used so the layout does not shift when switching between long sections and empty sections.

## Files

- `index.html` - interface structure.
- `styles.css` - black/white themes, responsive layout, cards, and panels.
- `app.js` - player, library, playlist, favorites, and UI logic.
- `manifest.webmanifest` - browser app metadata.
- `icon.svg` - simple app icon.
- `MP3 Player.vbs` - one-file launch without a visible command window.
- `start-server.bat` - backup manual server launcher.
- `LICENSE` - free personal and educational use terms.


## License

The project may be used, copied, and modified for personal, educational, and non-commercial purposes free of charge. Commercial redistribution is not allowed without written permission from the author. See `LICENSE` for details.

> **Project author: Zeynalov U.R.o.**
