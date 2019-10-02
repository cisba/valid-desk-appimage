#!/bin/bash

# get parameters
[ -f build.conf ] || exit 1
source build.conf

# sanity checks
[ -f ${jre32bit} ] || exit 1
[ -f ${jre64bit} ] || exit 1
[ -f appimagetool-i686.AppImage ] || exit 1
[ -f appimagetool-x86_64.AppImage ] || exit 1
[ -x appimagetool-i686.AppImage ] || chmod +x ${appimgx}
[ -x appimagetool-x86_64.AppImage ] || chmod +x ${appimgx}
[ -f app/CSCSigner.jar ] || exit 1
ls app/libs/*.jar >/dev/null || exit 1
echo -e "\e[32mSanity checks passed\e[39m"

for arch in x86_64 i686 ; do

    [ "$arch" == "x86_64" ] && javatgz=jre-${jrever}-linux-x64.tar.gz 
    [ "$arch" == "i686" ] && javatgz=jre-${jrever}-linux-i586.tar.gz

    # create appdir
    workdir=$(pwd)
    appdir="${workdir}/ValidDesk-${version}-${arch}.AppDir"
    [ -d ${appdir} ] && rm -fr ${appdir}
    mkdir ${appdir}

    # copy template files
    cd ${workdir}/Templates/
    cp AppRun ValidDesk ValidDesk.desktop ValidDesk.png ${appdir}
    echo -e "\e[32mCreated AppDir ${appdir}\e[39m"

    # extract jre
    tar -C ${appdir} -xf ${workdir}/${javatgz}
    cd ${appdir} 
    jre="$(ls -1|grep -e '^jre[0-9.]*_[0-9]*$')"
    mv $jre jre
    echo -e "\e[32mExtracted JRE ${javatgz}\e[39m"

    # copy app
    cd ${workdir}/app
    cp -r CSCSigner.jar libs ${appdir}
    echo -e "\e[32mApp copied in the AppDir\e[39m"

    # build appimage
    cd ${workdir}
    appimgx="appimagetool-${arch}.AppImage"
    ./${appimgx} -n ${appdir} ${output}
    echo -e "\e[32mCreated appimage file ${output}\e[39m"

    # cleaning
    rm -fr ${appdir}
    echo -e "\e[32mAppDir removed.\e[39m"

done
