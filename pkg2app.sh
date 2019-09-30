#!/bin/bash

# get parameters
if [ -z "$1" ] ; then
    echo "Usage: $0 <OS X Valid-Desk package file>"
else
    osxfile=$1
fi

# sanity checks
if ! [ -f ${osxfile} ] ; then 
    echo -e "\e[31mERROR: file ${osxfile} not found\e[39m"
    exit 1
fi
if ! which xar >/dev/null ; then
    echo -e "\e[31mERROR: xar executable not found\e[39m"
    exit 1    
fi
echo -e "\e[32mSanity checks passed\e[39m"

# create app directory
workdir=$(pwd)
appdir=${workdir}/app
[ -d ${appdir} ] && rm -fr ${appdir}
mkdir ${appdir}

# extract app from osx file
[ -d osx-pkg ] && rm -fr osx-pkg
mkdir -p osx-pkg
cd osx-pkg
xar -xvf ${workdir}/${osxfile} >/dev/null
cd ValidDesk-app.pkg/
gunzip -c Payload | cpio -i >/dev/null
cd ValidDesk.app/Contents/Java
mv CSCSigner.jar libs ${appdir}
echo -e "\e[32mExtracted ValidDesk app and libs from ${osxfile}\e[39m"

# cleaning
rm -fr ${workdir}/osx-pkg
echo -e "\e[32mCleaning done, exit.\e[39m"

