
## Requisiti

- cartella 'app' contenente il file CSCSigner.jar e la cartella libs
- Oracle Java JRE della stessa versione usata per lo sviluppo
- [appimagetool](https://github.com/Appimage/AppImageKit/releases)
- librerie 32bit (vedi nota 2)
- file di configurazione build.conf

## Istruzioni

Accertarsi di avere i reqisiti elencati sopra e aggiornare il file build.conf

Eseguire lo script `./build.sh`

### Note

1. se non si dispone della app è possibile estrarla dal pacchetto per OSX utilizzando tool di estrazione che supportino i formati xar+gzip+cpio; per la distribuzione CentOS esiste il pacchetto [xar](https://copr.fedorainfracloud.org/coprs/scx/xar/); la procedura di estrazione è esemplificata nello script `pkg2app.sh`

2. per produrre il pacchetto 32bit-i686 su una piattaforma 64bit-x86_64 è necessario installare alcune librerie 32bit; ad esempio su Ubunru eseguire `sudo apt install libfuse2:i386` mentre su CentOS7 eseguire `sudo yum install glibc.i686 zlib.i686 fuse-libs.i686 libgcc.i686`


