#!/bin/sh
# Renames all files in the current directory to lower case.
# Our coding style forces to name all files lowercase to avoid spelling mistakes,
# that Windows developer don't even notice, because Windows file systems are not 
# case sensitive. With this rule Windows devs wont break builds anymore. At least
# not that way ;-)

# get files with upper case letters
FILELIST=`ls | grep "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"`

if [ -z $FILELIST ]; then
  echo "No files with upper case letters found in this directory that could be renamed."
  exit 0
fi

if [ "$1" !=  "--notest" ]; then
    echo "Following files would be renamed:"
    for file in $FILELIST; do
        FILE=`echo $file | sed -e'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
        echo $file "->" $FILE
    done
    echo "Run ./rename2lower.sh --notest to really rename the subversion files."
else
    for file in $FILELIST; do
        FILE=`echo $file | sed -e'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
        echo $file "->" $FILE
        svn rename $file $FILE
    done
fi
