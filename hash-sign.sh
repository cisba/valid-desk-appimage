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

# check packages exist
versionrpm="$(echo ${version}|sed 's/_/-/')"
if [ -f validdesk-${versionrpm}.x86_64.rpm ] ; then
    mv validdesk-${versionrpm}.x86_64.rpm validdesk-${version}.x86_64.rpm
fi
filelist1="$(ls ValidDesk-${version}{.exe,.pkg,-{i686,x86_64}.AppImage})"
#filelist1="$(ls ValidDesk-${version}{.exe,.pkg,-i686.AppImage,-x86_64.AppImage})"
filelist2="validdesk-${version}.deb validdesk-${version}.x86_64.rpm"
filelist="${filelist1} ${filelist2}"
for file in ${filelist} ; do
    if ! [ -f ${file} ] ; then
        echo "ERROR: file ${file} not present"
        exit 1
    fi
done

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

echo ${version} > current

# FIXME: add public key copy to directory (?)
