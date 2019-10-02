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
if [[ "$1" == "--sign" ]] ; then
    [ -z "$(gpg -K)" ] && exit 1
fi
echo -e "\e[32mSanity checks passed\e[39m"

# create output dir
workdir=$(pwd)
outputdir="${workdir}/out-${version}"
[ -d ${outputdir} ] && rm -fr ${outputdir}
mkdir ${outputdir} || exit 1

# do the job for each type of cpu
for arch in x86_64 i686 ; do

    [ "$arch" == "x86_64" ] && javatgz=jre-${jrever}-linux-x64.tar.gz 
    [ "$arch" == "i686" ] && javatgz=jre-${jrever}-linux-i586.tar.gz
    appname="ValidDesk-${version}-${arch}"

    # create appdir
    appdir="${workdir}/${appname}.AppDir"
    [ -d ${appdir} ] && rm -fr ${appdir}
    mkdir ${appdir} || exit 1

    # copy template files
    cd ${workdir}/Templates/ || exit 1
    cp AppRun ValidDesk ValidDesk.desktop ValidDesk.png ${appdir}
    echo -e "\e[32mCreated AppDir ${appdir}\e[39m"

    # extract jre
    tar -C ${appdir} -xf ${workdir}/${javatgz} || exit 1
    cd ${appdir}
    jre="$(ls -1|grep -e '^jre[0-9.]*_[0-9]*$')"
    mv $jre jre || exit 1
    echo -e "\e[32mExtracted JRE ${javatgz}\e[39m"

    # copy app
    cd ${workdir}/app
    cp -r CSCSigner.jar libs ${appdir} || exit 1
    echo -e "\e[32mApp copied in the AppDir\e[39m"

    # build appimage
    cd ${workdir} || exit 1
    output="${appname}.AppImage"
    appimgx="appimagetool-${arch}.AppImage"
    options="-n $1"
    ./${appimgx} ${options} -n ${appdir} ${outputdir}/${output} || exit 1
    echo -e "\e[32mCreated appimage file ${output}\e[39m"

    # checksums
    cd ${outputdir} || exit 1
    sha256sum ${output} > ${output}.sha256sum || exit 1
    sha512sum ${output} > ${output}.sha512sum || exit 1

    # signing
    if [[ "$1" == "--sign" ]] ; then
        gpg -s -b ${output} || exit 1
        gpg -s -b -a ${output} || exit 1
        echo -e "\e[32mCreated appimage file ${output}\e[39m"
    fi

    # cleaning
    cd ${workdir} || exit 1
    rm -fr ${appdir} || exit 1
    echo -e "\e[32mAppDir removed.\e[39m"
    echo -e "\e[32mSuccess!\e[39m"

done
