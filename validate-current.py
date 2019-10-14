
import requests
import simplejson as json

baseuri = 'https://www.intesigroup.com/wp-content/apps/'
current = baseuri + 'current.json'
response = requests.get(current)
if not response:
    print("Error reading %s" % current)
else:
    data = response.json()
    for os in data.keys():
        pathname = data[os]['file']
        uri = baseuri + pathname
        response = requests.head(uri)
        if not response:
            print("Error: for os <%s> file <%s> not found!" % (os, pathname))
        else:
            print("os: %s, file: %s" % (os, pathname))
