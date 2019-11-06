#!/bin/bash

# check osx pkg
[ -f "$1" ] || exit 1
osxpkg="$1"

# check or setup venv
which python3 >/dev/null || exit 1
if ! which pip3 >/dev/null 2>&1 ; then
    if [ ! -f .venv/bin/activate ] ; then
        python3 -m venv .venv || exit 1
    fi
fi

source .venv/bin/activate || exit 1
pip3 install --upgrade pip >/dev/null || exit 1


if ! pip3 show libarchive-c >/dev/null ; then
    pip3 install libarchive-c || exit 1
fi

# extract
workdir="$(pwd)"
extractdir=app_extract
rm -fr ${workdir}/${extractdir}
mkdir ${extractdir} || exit 1
cd ${extractdir} || exit 1
python3 ../extract.py ../${osxpkg} || exit 1
cd ValidDesk-app.pkg || exit 1
gunzip -c Payload | cpio -i || exit 1
rm -fr ${workdir}/app || exit 1
mv ValidDesk.app/Contents/Java ${workdir}/app || exit 1
cd ${workdir}
rm -fr ${workdir}/${extractdir}

# get app and jre version
version="$(echo ${osxpkg} | sed 's/^.*ValidDesk-//'|sed 's/.pkg$//')"
jrever="$(grep -A 1 BundleVersion ValidDesk.app/Contents/PlugIns/Java.runtime/Contents/Info.plist | grep string | sed 's/[ ]*<[\/]*string>//g')"
echo "version=${version}" > ${workdir}/app/versions
echo "jrever=${jrever}" >> ${workdir}/app/versions

# show versions
cat ${workdir}/app/versions
