#!/usr/bin/env bash

set -x

currentpath="$( cd "$(dirname "$0")" ; pwd -P )"

# in and out files are relative to the calling path
inputfile=$1
outputfile=$2

# css and js files are relative to the current script
cssfile=$currentpath/rasterize.css

# tmp file can be anywhere
tmpfile=/tmp/markdown2pdf${outputfile##*/}.html

# echo the basic html structure and add some nice css to it 
echo "<html><head>" > $tmpfile
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"$currentpath/github.css\">" >> $tmpfile
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"$cssfile\">" >> $tmpfile
echo "</head><body>" >> $tmpfile

# Latin1 works with iso-8859-1 (.js)
#markdown $inputfile | iconv -f utf8 -t l1 >> $tmpfile
bundle exec rake md_html | iconv -f utf8 -t l1 >> $tmpfile
echo "</body></html>" >> $tmpfile

# convert our html version of markdown to pdf
phantomjs $currentpath/rasterize.js $tmpfile $outputfile A4

# clean the mess
rm $tmpfile