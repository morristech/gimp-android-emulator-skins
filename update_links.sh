#!/bin/bash

SDK_DIR=`echo $PATH | grep --color=never -o "[^:]*android[^:]*sdk[^:]*/tools[^:]*"`
OIFS=$IFS
IFS=$'\n'
for d in $SDK_DIR; do
    SDK_DIR=`dirname $d`
done

# Check SDK_DIR
if [ ! -d $SKIN_DIR]; then
    echo "Error : Cannot find Android SDK directory in PATH."
    return 1
else
    echo "Using Android SDK directory: \"$SDK_DIR\""
fi

# Update links
for android_skin_dir in $(find $SDK_DIR/platforms/android-* -type d -name skins); do
    # Remove links
    for eskin_link in $(find $android_skin_dir -type l -iname "ESKIN_*" ); do
        echo "remove link: $eskin_link"
        rm "$eskin_link"
    done
    
    # Create links
    for eskin_dir in $(find ./ -type d -iname "ESKIN_*" ); do
        target=$(readlink -f "$eskin_dir")
        link=$(readlink -f "$android_skin_dir/$eskin_dir")
        echo "create link: $target  ->  $link"
        ln -s "$target" "$link"
    done
done

IFS=$OIFS

