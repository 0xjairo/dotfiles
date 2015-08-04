#!/bin/sh
HELPSTR="Reduce size of PDF file using GhostScript's ebook settings"

while getopts ":h" opt; do
    case $opt in
        h) echo $HELPSTR; exit 0;;
    esac
done

if [ -z "$1" ]; then
    echo $HELPSTR
    echo ""
    echo "usage: $0 inputfile [outputfile]"
    exit 1;
fi

if [ ! -z "$2" ]; then
    outfile=$2
else
    outfile="output.pdf"
fi

echo "Writing $outfile"
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.3 \
    -dPDFSETTINGS=/ebook \
    -sOutputFile=$outfile \
    $1 1>/dev/null
