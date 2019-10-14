
import requests
import simplejson as json


with open('current.json') as json_file:
    data = json.load(json_file)
    for os in data.keys():
#pathname = "pub/ValidDesk-1.0_290.exe"
        pathname = data[os]['file']
        baseuri = 'https://www.intesigroup.com/wp-content/apps/'
        uri = baseuri + pathname
        response = requests.head(uri)
        if not response:
            print("Error: for os <%s> file <%s> not found!" % (os, pathname))
        else:
            print("os: %s, file: %s" % (os, pathname))
