#!/bin/bash

# get parameters
if ! [ -f app/versions ] ; then
    echo "ERROR: file app/versions not present"
    exit 1
fi
source app/versions

# check signature
[ -z "$(gpg -K)" ] && exit 1
# FIXME: check publication on keyserver
# FIXME: select key from keyring (?)
# FIXME: add public key copy to ftp directory (?)

# check packages exist
versionrpm="$(echo ${version}|sed 's/_/-/')"
filelist="$(ls *-${version}*{exe,pkg,deb,{x86_64,i686}.AppImage})"
ret=$?
filelist="$filelist $(ls *-${versionrpm}*rpm)"
ret=$(( $? + ret ))
if (( ret > 0 )) ; then
    read -p "some file not found, continue anyway? (yes/no): " response
    [ "${response}" == "yes" ] || exit 1
fi
for file in ${filelist} ; do
    echo ${file}
done
read -p "File list complete. Confirm? (yes/no): " response
[ "${response}" == "yes" ] || exit 1

# move packages in outdir
mkdir "out-${version}" || exit 1
for file in ${filelist} ; do
    mv ${file} "out-${version}" || exit 1
done

# generate checksum and signature
cd "out-${version}" || exit 1
for file in ${filelist} ; do
    sha256sum ${file} > ${file}.sha256sum || exit 1
    gpg -s -b -a ${file} || exit 1
done

#echo ${version} > current

