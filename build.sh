#!/bin/bash

# get parameters
[ -f build.conf ] || exit 1
source build.conf

# sanity checks
[ -f ${javatgz} ] || exit 1
[ -f ${appimgx} ] || exit 1
[ -x ${appimgx} ] || chmod +x ${appimgx}
[ -f app/CSCSigner.jar ] || exit 1
ls app/libs/*.jar >/dev/null || exit 1
echo -e "\e[32mSanity checks passed\e[39m"

# create appdir
workdir=$(pwd)
appdir="${workdir}/ValidDesk-${version}-${arch}.AppDir"
[ -d ${appdir} ] && rm -fr ${appdir}
mkdir ${appdir}

# copy template files
cd ${workdir}/Templates/
cp AppRun ValidDesk ValidDesk.desktop ValidDesk.png ${appdir}
echo -e "\e[32mCreted AppDir ${appdir}\e[39m"

# extract jre
tar -C ${appdir} -xf ${workdir}/${javatgz}
echo -e "\e[32mExtracted JRE ${javatgz}\e[39m"

# copy app
cd ${workdir}/app
cp -r CSCSigner.jar libs ${appdir}
echo -e "\e[32mApp copied in the AppDir\e[39m"

# build appimage
cd ${workdir}
./${appimgx} ${appdir} ${output}
echo -e "\e[32mCreated appimage file ${output}\e[39m"

# cleaning
rm -fr ${appdir}
echo -e "\e[32mCleaning done, exit.\e[39m"

