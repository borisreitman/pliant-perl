#!/bin/sh
# generate Makefile from a source noweb file
nowebfile=$1
FAIL=1
SUCCESS=0
NOTANGLE=/usr/bin/notangle

if [ "$nowebfile" == "" ]; 
then 

  echo "Usage: bootstrap.sh file_with_Makefile_chunk.nw";
  exit $FAIL;

fi

$NOTANGLE -t8 -RMakefile $nowebfile > Makefile
exit $SUCCESS;
