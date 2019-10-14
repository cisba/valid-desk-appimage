#!/bin/bash

jsonfile=current.json
if [ ! -f "${jsonfile}" ] ; then
   echo "Error: <${jsonfile}> file not found!"
   exit 1
fi

# check or setup venv
which python3 >/dev/null || exit 1
if ! which pip3 >/dev/null 2>&1 ; then
    if [ ! -f .venv/bin/activate ] ; then
        python3 -m venv .venv || exit 1
    fi
fi

source .venv/bin/activate || exit 1
pip3 install --upgrade pip >/dev/null || exit 1


if ! pip3 show simplejson >/dev/null ; then
    pip3 install simplejson || exit 1
fi
if ! pip3 show requests >/dev/null ; then
    pip3 install requests || exit 1
fi

source .venv/bin/activate
python3 validate-current.py
