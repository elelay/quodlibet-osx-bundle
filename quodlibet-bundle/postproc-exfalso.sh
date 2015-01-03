#!/bin/sh
oldapp=~/Desktop/Quodlibet.app
app=~/Desktop/ExFalso.app
rm -Rf "$app"
rsync -av "$oldapp/" "$app"
rm -Rvf $app/Contents/Resources/lib/python2.7/*/test
rm -f $app/Contents/Resources/lib/python2.7/config/libpython2.7.a
find $app/Contents/Resources/lib/python2.7 -name '*.pyc' -delete
find $app/Contents/Resources/lib/python2.7 -name '*.pyo' -delete

# check for dynamic linking consistency : nothing should reference gtk/inst
find $app -name '*.so' -and -print -and  -exec sh -c 'otool -L $1 | grep /inst' '{}' '{}' ';'


# Set the version and copyright automatically
/usr/bin/xsltproc --stringparam app quodlibet -o $app/Contents/Info.plist info-plist.xsl Info-exfalso.plist

# Override the call to quodlibet with exfalso
mv $app/Contents/MacOS/{Quodlibet,ExFalso}
sed -i -e 's,bin/quodlibet,bin/exfalso,' $app/Contents/MacOS/ExFalso

# exfalso icons
rm $app/Contents/Resources/quodlibet.icns
cp exfalso.icns $app/Contents/Resources/

# list the provenance of every file in the bundle
./provenance.pl $app > ~/Desktop/ExFalso.contents
