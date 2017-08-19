# cmus-lyrics :musical_note:
**cmus-lyrics** is a bash script that fetches lyrics of current song playing in [[CMus](https://cmus.github.io/)] (C\* Music Player) or directly typed by user. To perform the former, the *Cmus Now Playing* script<sup id="f1">[1](#myfootnote1)</sup> is used.





### Prerequisites :
- `cmus` - is a small ncurses based music player.  It supports various output
methods by output-plugins. cmus has completely configurable keybindings and
can be controlled from the outside via *cmus-remote*
- `curl` - is a tool to transfer data from or to a server, using one of the supported protocols (DICT, FILE, FTP, FTPS, GOPHER, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, TELNET and TFTP). The command is designed to work without user interaction.
- `jq` - is a lightweight and flexible command-line JSON processor.
- `w3m` - is a pager/text-based WWW browser. You can browse local documents and/or documents on the WWW using a terminal emulator.
- `tr` - is an UNIX utility for translating, or deleting, or squeezing repeated characters.
- `awk` - is a powerful method for processing or analysing text files—in particular, data files that are organised by lines (rows) and columns.



### Files
#### Method A:
```sh
LyricsGet.sh SONG ARTIST ALBUM
```
It fetches information from azlyrics.com, but retrieving and parsing information from the webpage. Therefore, the data is parse with `w3m` and *regular expressions*.

#### Method B:  
```sh
LyricsGet_musix.sh SONG ARTIST ALBUM
```
It fetches information from musixmatch.com, and requires an *API key*.
The information is obtained in _json_ format, for which `jq` is used.

#### Cmus Now Playing
```sh
CmusNow.sh
```



### Installation and Use :

In any folder, download `cmus-lyrics` by cloning the project
```sh
git clone https://github.com/guxsousa/cmus-lyrics.git
```
or by getting a zip
```sh
wget https://github.com/guxsousa/cmus-lyrics/archive/master.zip
unzip cmus-lyrics-master.zip
```


Get inside the folder and check permissions to make the files executable
```sh
cd cmus-lyrics-master/
chmod 755 *.sh
cd ..
```

In some OSs, the relative path to `LyricsGet.sh` inside `CmusNowLyrics.sh` works well, in some others it requires further processing or an absolute path. Edit this field accordingly.
> ~ line 41



Run `./CmusNowLyrics.sh` and it will print information of the song currently playing in `CMus`
```sh
./CmusNowLyrics.sh
```


Run `./LyricsGet.sh` and it will use the values to fetch lyrics of the song
```sh
./LyricsGet.sh 'artist' 'title' 'album'
```

Likewise `./LyricsGet_musix.sh`, yet restricted to 30% of the text if using a basic account. Please mind the `API` field.
```sh
./LyricsGet_musix.sh 'artist' 'title' 'album'
```


## License

This software is licensed under the [GNU General Public License](LICENSE).



## Authors

Gus Sousa -- [guxsousa](https://github.com/guxsousa)


---
<a name="myfootnote1">1</a>: *Cmus Now Playing* by Michael Chris (@github/mcchrish) [↩](#f1)

<!--
# Metadata:
# <bitbar.title>Cmus Now Playing</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Michael Chris Lopez</bitbar.author>
# <bitbar.author.github>mcchrish</bitbar.author.github>
# <bitbar.desc>Displays currently playing song from cmus. Control cmus in menubar.</bitbar.desc>
# <bitbar.image>https://i.imgur.com/qeZCB0a.png</bitbar.image> -->
