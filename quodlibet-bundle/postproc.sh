#!/bin/sh
app=~/Desktop/Quodlibet.app
rm -Rvf $app/Contents/Resources/lib/python2.7/*/test
rm -f $app/Contents/Resources/lib/python2.7/config/libpython2.7.a
find $app/Contents/Resources/lib/python2.7 -name '*.pyc' -delete
find $app/Contents/Resources/lib/python2.7 -name '*.pyo' -delete
rm -f $app/Contents/MacOS/Quodlibet-bin

# check for dynamic linking consistency : nothing should reference gtk/inst
find $app -name '*.so' -and -print -and  -exec sh -c 'otool -L $1 | grep /inst' '{}' '{}' ';'

# Set the version and copyright automatically 
/usr/bin/xsltproc --stringparam app quodlibet -o $app/Contents/Info.plist info-plist.xsl Info-quodlibet.plist
# list the provenance of every file in the bundle
./provenance.pl $app > ~/Desktop/Quodlibet.contents
