
## Requisiti

- cartella 'app' contenente il file CSCSigner.jar e la cartella libs
- Oracle Java JRE della stessa versione usata per lo sviluppo
- [appimagetool](https://github.com/Appimage/AppImageKit/releases)
- file di configurazione build.conf

## Istruzioni

Accertarsi di avere i reqisiti elencati sopra e aggiornare il file build.conf

Eseguire lo script `./build.sh`

### Note

1. se non si dispone della app è possibile estrarla dal pacchetto per OSX utilizzando tool di estrazione che supportino i formati xar+gzip+cpio; per la distribuzione CentOS esiste il pacchetto [xar](https://copr.fedorainfracloud.org/coprs/scx/xar/); la procedura di estrazione è esemplificata nello script `pkg2app.sh`

2. per realizzare il pacchetto 32bit su una piattaforma x86_64 è necessario installare alcune librerie 32bit; ad esempio su CentOS7 è sufficente eseguire il comando `sudo yum install glibc.i686 zlib.i686 fuse-libs.i686`
This doesn't look like a squashfs image.

### Bugs

Il pacchetto 32bit-i686 se realizzato su una macchina 64bit-x86_64 non funziona.
L'errore segnalato è il seguente:

Cannot mount AppImage, please check your FUSE setup.
You might still be able to extract the contents of this AppImage 
if you run it with the --appimage-extract option. 
See https://github.com/AppImage/AppImageKit/wiki/FUSE 
for more information
open dir error: No such file or directory

