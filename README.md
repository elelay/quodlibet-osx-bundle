# Quodlibet.app bundle

This is a collection of files required to build Quodlibet.app :
Quodlibet as a native GTK+ Quartz application for Mac OS X 10.6 and 10.7

I used them to build on a 10.6 X86_64 machine.

## Getting the bundle

Go to the [Releases](https://github.com/elelay/quodlibet-osx-bundle/releases/)
section and choose the latest and greatest.

Every release (starting from 3.3.0_0) is attached to the tag it has
been produced from.

### Contents

 - *Quodlibet-X.Y.Z_B.zip* is the QuodLibet application,
 - *Quodlibet.contents-X.Y.Z_B.bz2* lists the package each file in the bundle
    comes from,
 - *Quodlibet-X.Y.Z_B.zip.md5* and *Quodlibet-X.Y.Z_B.zip.sha256* are checksums
   for the zip file.

 - *ExFalso-X.Y.Z_B.zip* is the ExFalso application,
 - *ExFalso.contents-X.Y.Z_B.bz2* lists the package each file in the bundle
    comes from,
 - *ExFalso-X.Y.Z_B.zip.md5* and *ExFalso-X.Y.Z_B.zip.sha256* are checksums
   for the zip file.

**X.Y.Z** stands for the Quodlibet release by Christoph, **B** stands for the
build I've made (0 for the first build, increasing).


## Issues

If you experience any issue with these bundles, please open a
[github issue](/elelay/quodlibet-osx-bundle/issues).


# Using Quodlibet.app

## Supported audio types:

FLAC, MIDI, MP3, MPEG-4 AAC,
Monkey's Audio, Musepack, Ogg FLAC, Ogg Opus,
Ogg Speex, Ogg Theora, Ogg Vorbis, SPC700,
True Audio, VGM, WAVE, WavPack,
Windows Media Audio

## Plugins

Following plugins are not loading.

 - cddb
 - crossfeed (gstreamer plugin *bs2b* missing)
 - fingerprint (gstreamer plugin *chromaprint* missing)
 - kakasi
 - lyricwiki (requires WebKit, which is difficult to build)
 - pitch (gstreamer plugin *pitch* missing)

Other plugins are disabled on OS X (e.g. zeitgeist).


## For Developpers

### Building

git clone into ```~/qlmymodules```

copy ```dot_jhbuildrc-custom``` to ```~/.jhbuildrc-custom``` or better, merge my modifications to your config file

```touch ~/.jhbuildrc-QL``` (empty file, but required)

If you have MacPorts installed, you must ensure to remove it from the path,
to only build against system libraries.
It might also be a good idea to move it to some non standard location
during the build: some configure scripts are a bit too clever and will use it even
if it's not in the path.

Follow instructions in http://live.gnome.org/GTK%2B/OSX/Building

    export JHB=QL

    jhbuild bootstrap

    jhbuild build python

    jhbuild build meta-gtk-osx-bootstrap

    jhbuild build gtk-doc
(builds a newer version of gtk-doc for glib)

    jhbuild build meta-gtk-osx-freetype
(this is the key to getting pangoft2 and also fontconfig for librsvg)

    jhbuild build meta-gtk-osx-gtk3

    jhbuild buildone -f bison
(builds a newer version of bison for gstreamer)

    jhbuild build quodlibet


### Bundling

These need to be modifiable, otherwise install-name-tool fails to
rewrite paths to libraries in them

    chmod u+w /Volumes/MAC2/QLGtkOSX/inst/lib/libreadline.6.3.dylib 
    chmod u+w /Volumes/MAC2/QLGtkOSX/inst/lib/libpython2.7.dylib 

install gtk-mac-bundler, following http://live.gnome.org/GTK%2B/OSX/Bundling

    cd qlmymodules/quodlibet-bundle
    export JHB=QL
    jhbuild shell
    gtk-mac-bundler quodlibet.bundle && ./postproc.sh 

produces Quodlibet.app in Desktop

test by double-clicking on Quodlibet.app

test by moving ```/Volumes/MAC2/QLGtkOSX/inst``` away and re-launching

## Releasing
    cd qlmymodules/quodlibet-bundle
    ./release.sh ~/Desktop/Quodlibet.app X.Y.Z_buildnr
    ./postproc-exfalso.sh
    ./release.sh ~/Desktop/ExFalso.app X.Y.Z_buildnr

where ```X.Y.Z``` is QuodLibet's version and ```buildnr``` is
the bundle version, incremented at each release of the same version.

