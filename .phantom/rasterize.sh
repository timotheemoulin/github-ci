#!/usr/bin/env bash

set -x

inputfile=$1
outputfile=$2
cssfile=.phantom/rasterize.css
tmpfile=/tmp/markdown2pdf${outputfile##*/}.html
 
echo "<html><head>" > $tmpfile
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"github.css\">" >> $tmpfile
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"$cssfile\">" >> $tmpfile
echo "</head><body>" >> $tmpfile
# Latin1 works with iso-8859-1 (.js)
markdown $inputfile | iconv -f utf8 -t l1 >> $tmpfile
echo "</body></html>" >> $tmpfile

phantomjs .phantom/rasterize.js $tmpfile $outputfile A4

pwd

find . -name "*README*"

find / -name "*README*"

rm $tmpfile