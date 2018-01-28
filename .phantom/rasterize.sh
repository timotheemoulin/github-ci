#!/usr/bin/env bash
inputfile=$1
outputfile=$2
cssfile=/data/.phantom/rasterize.css
tmpfile=/tmp/markdown2pdf${outputfile##*/}.html
 
echo "<html><head>" > $tmpfile
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"/data/.phantom/github.css\">" >> $tmpfile
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"$cssfile\">" >> $tmpfile
echo "</head><body>" >> $tmpfile
# Latin1 works with iso-8859-1 (.js)
markdown $inputfile | iconv -f utf8 -t l1 >> $tmpfile
echo "</body></html>" >> $tmpfile
phantomjs /data/.phantom/rasterize.js $tmpfile $outputfile A4
rm $tmpfile