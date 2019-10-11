
## Requisiti

- Pacchetti ValidDesk forniti dallo sviluppo per osx, win, deb, rpm
- Oracle Java JRE della stessa versione usata per lo sviluppo
- [appimagetool](https://github.com/Appimage/AppImageKit/releases)
- librerie 32bit (vedi nota 1)

## Istruzioni

Accertarsi di avere i requisiti elencati sopra

Eseguire il comando `./pkg2app.sh ValidDesk-<version>.pkg` che crea la directory `app` e il file `app/versions` che contiene le versioni.

Se necessario scaricare le vesioni jre a 32bit e 64bit coerenti con quanto presente nel file `app/versions`

Eseguire il comando `./build.sh` che genera i pacchetti AppImage

Eseguire il comando `./hash-sign.sh` che crea la cartella `out_<version>` con tutti i pacchetti, i file sha256 e le firme

### Note

1. per produrre il pacchetto 32bit-i686 su una piattaforma 64bit-x86_64 è necessario installare alcune librerie 32bit; ad esempio su Ubuntu eseguire `sudo apt install libc6:i386 zlib1g:i386 libfuse2:i386 libgcc1:i386` mentre su CentOS7 eseguire `sudo yum install glibc.i686 zlib.i686 fuse-libs.i686 libgcc.i686`

