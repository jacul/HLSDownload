# HLSDownload
Download HLS format video with bash command line.

## Usage
You need bash environment at least.

* Download download-hls.sh to a folder.

* Open terminal.

* Change directory to the folder where you put the download.sh file.

* You may need to give it proper permission to execute. Type following command:
```
chmod u+x download-hls.sh
```
  This only needs to be run once.
  
* Download the media file. You need the remote file(.m3u8)'s URL.
```
./download-hls.sh <URL> [filename]
```
filename is optional. If empty, save as "save.ts".

## Notes
Only supports certain types of HLS format.
