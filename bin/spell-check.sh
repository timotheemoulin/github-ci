#!/bin/bash

# Some useful variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Only work on markdown files
MARKDOWN_FILES_CHANGED=`(git diff --name-only $TRAVIS_COMMIT_RANGE || true) | grep .md`

echo -e "Beginning spell checking"

# Checks if there is at least one file to check
if [ -z "$MARKDOWN_FILES_CHANGED" ]
then
    echo -e "$GREEN>> No markdown file to check $NC"

    exit 0;
fi

# List MD files that have change
echo -e "$BLUE>> Following markdown files were changed (commit range: $TRAVIS_COMMIT_RANGE):$NC"
echo "$MARKDOWN_FILES_CHANGED"

# Get found language (en|fr only)
FOUND_LANGUAGES=`echo "$MARKDOWN_FILES_CHANGED" | xargs cat | grep "permalink: /" | sed -E 's/permalink: \/(fr|en)\/.*/\1/g'`
echo -e "$BLUE>> Languages recognized from the permalinks:$NC"
echo "$FOUND_LANGUAGES"

while read LINE
do
    if [ "$LINE" != "en" ]
    then
        USE_LANGUAGE="$LINE"

    fi
done <<< "$FOUND_LANGUAGES"

if [ -z "$USE_LANGUAGE" ]
then
    USE_LANGUAGE='en'
fi

echo -e "$BLUE>> Will use this language as main one:$NC"
echo "$USE_LANGUAGE"

# Cat all markdown files that changed
TEXT_CONTENT_WITHOUT_METADATA=`cat $(echo "$MARKDOWN_FILES_CHANGED" | sed -E ':a;N;$!ba;s/\n/ /g')`
# Remove metadata tags
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | grep -v -E '^(layout:|permalink:|date:|date_gmt:|authors:|categories:|tags:|cover:)(.*)'`
# Remove { } attributes
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed -E 's/\{:([^\}]+)\}//g'`
# Remove html
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed -E 's/<([^<]+)>//g'`
# Remove code blocks
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed  -n '/^\`\`\`/,/^\`\`\`/ !p'`
# Remove links
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed -E 's/http(s)?:\/\/([^ ]+)//g'`

echo -e "$BLUE>> Text content that will be checked (without metadata, html, and links):$NC"
echo "$TEXT_CONTENT_WITHOUT_METADATA"

# Check content spelling in English
echo -e "$BLUE>> Checking in 'en' (many technical words are in English anyway)...$NC"
MISSPELLED=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | aspell --lang=en --encoding=utf-8 --personal=./.aspell.en.pws list | sort -u`

# Check content spelling in the detected language
if [ "$USE_LANGUAGE" != "en" ]
then
    echo -e "$BLUE>> Checking in '$USE_LANGUAGE' too..."
    MISSPELLED=`echo "$MISSPELLED" | aspell --lang=$USE_LANGUAGE --encoding=utf-8 --personal=./.aspell.$USE_LANGUAGE.pws list | sort -u`
fi

NB_MISSPELLED=`echo "$MISSPELLED" | wc -l`

if [ "$NB_MISSPELLED" -gt 0 ]
then
    echo -e "$RED>> Words that might be misspelled, please check:$NC"
    MISSPELLED=`echo "$MISSPELLED" | sed -E ':a;N;$!ba;s/\n/, /g'`
    echo "$MISSPELLED"
    COMMENT="$NB_MISSPELLED words might be misspelled, please check them: $MISSPELLED"
else
    COMMENT="No spelling errors, congratulations!"
    echo -e "$GREEN>> $COMMENT $NC"
fi

exit 0