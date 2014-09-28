#!/bin/sh

set -e

usage="Usage: $0 /path/to/Quodlibet.app version_buildnumber"

if [ -z "$1" ] ; then
	echo $usage
	exit -1
elif [ ! -d "$1" ] ; then
	echo $usage
	echo "$1 doesn't exist or is not a directory (give me /path/to/Quodlibet.app)"
else
	app=$1
	shift
fi

if [ -z "$1" ] ; then
	echo $usage
	exit -1
else
	version=$1
	shift
fi

zip="${app%.app}-$version.zip"
if [ -f "$zip" ] ; then
	echo "$zip already exists!"
	exit -1
fi
echo "Creating $zip..."
zip -rq "$zip" "$app"

echo "Checksumming..."
(cd $(dirname "$zip") && shasum -a256 $(basename "$zip")) > "$zip.sha256"
(cd $(dirname "$zip") && md5 $(basename "$zip")) > "$zip.md5"

echo "Compressing contents..."
contents="${app%.app}.contents"
bzip2 -c "$contents" > "$contents-$version.bz2"

echo "Done"
