#!/usr/bin/env bash

# Some useful variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

LANGUAGE_KEY='#Language: '
# All available languages aspell packages must be loaded from the .travis.yml file
# addons.apt.packages: [..., aspell-{lang}]
AVAILABLE_LANGUAGES='fr|en'

# Allow executing this file without being in the travis execution
if [ -z "$TRAVIS_COMMIT_RANGE" ]; then
	TRAVIS_COMMIT_RANGE=$(git rev-list HEAD | tail -n 1)
	TRAVIS_COMMIT_RANGE="$TRAVIS_COMMIT_RANGE...HEAD"
fi

# Only check markdown files
CHANGED_FILES=`(git diff --name-only $TRAVIS_COMMIT_RANGE || true) | grep .md`

echo -e "$BLUE>> Beginning spell checking$NC"

# Checks if there is at least one file to check
if [ -z "$CHANGED_FILES" ]; then
    echo -e "$GREEN>> No markdown file to check $NC"

    exit 0;
fi

# List MD files that have changed
echo -e "$BLUE>> Following markdown files were changed (commit range: $TRAVIS_COMMIT_RANGE):$NC"
echo "$CHANGED_FILES"
echo -e "$BLUE>> Text will be checked without metadata, html, and links:$NC"

# Check each file independently as each file has its own language
for CURRENT_FILE in $CHANGED_FILES; do

    FOUND_LANGUAGES=`echo "$CURRENT_FILE" | xargs cat | grep "$LANGUAGE_KEY" | sed -E "s/\[\/\/\]\:\ \#\ \($LANGUAGE_KEY($AVAILABLE_LANGUAGES)\)/\1/g"`

    while read LINE; do
        if [ "$LINE" != "en" ]
        then
            FILE_LANGUAGE="$LINE"
            echo -e "$BLUE>> Languages '$FILE_LANGUAGE' recognized from the metadata:$NC"
        fi
    done <<< "$FOUND_LANGUAGES"

    if [ -z "$FILE_LANGUAGE" ]; then
        FILE_LANGUAGE='en'
    fi

    # Get the content of all markdown files that changed
    CHANGED_CONTENT=`cat $(echo "$CURRENT_FILE" | sed -E ':a;N;$!ba;s/\n/ /g')`
    # Remove code blocks
    CHANGED_CONTENT=`echo "$CHANGED_CONTENT" | sed  -n '/^\`\`\`/,/^\`\`\`/ !p'`
    # Remove links
    CHANGED_CONTENT=`echo "$CHANGED_CONTENT" | sed -E 's/http(s)?:\/\/([^ ]+)//g'`


    # Check content spelling in English
    echo -e "$BLUE>> Checking in English (many technical words are in English anyway)...$NC"
    MISSPELLED_EN=`echo "$CHANGED_CONTENT" | aspell --lang=en --personal=./.aspell/aspell.en.pws list | sort -u`
    MISSPELLED_EN="$MISSPELLED_EN" | sed -E ':a;N;$!ba;s/\n/, /g'
    # echo $MISSPELLED_EN

    # Check content spelling in the detected language
    if [ "$FILE_LANGUAGE" != "en" ]; then
        echo -e "$BLUE>> Checking in '$FILE_LANGUAGE' too...$NC"
        MISSPELLED_LANG=`echo "$CHANGED_CONTENT" | aspell --lang=$FILE_LANGUAGE --personal=./.aspell/aspell.$FILE_LANGUAGE.pws list | sort -u`
        MISSPELLED_LANG="$MISSPELLED_LANG" | sed -E ':a;N;$!ba;s/\n/, /g'
        # echo $MISSPELLED_LANG
    fi

done

echo -e "filter matching"
# Only cry if there is an unknown word in English and the specific language of the document
MISSPELLED=()

while read LINE; do
        if [ "$LINE" != "en" ]
        then
            FILE_LANGUAGE="$LINE"
            echo -e "$BLUE>> Languages '$FILE_LANGUAGE' recognized from the metadata:$NC"
        fi
    done <<< "$FOUND_LANGUAGES"




while read WORD_EN; do
    while read WORD; do
        if [[ $WORD_EN = $WORD ]]; then
            MISSPELLED+=("$WORD_EN")
            echo -e "$RED>> Misspelled word found : $WORD_EN $NC"
        fi
    done <<< $MISSPELLED_EN
done <<< $MISSPELLED_LANG

if [ -n "$MISSPELLED" ] ; then
	NB_MISSPELLED=`echo "$MISSPELLED" | wc -l`
else 
	NB_MISSPELLED=0
fi

if [ "$NB_MISSPELLED" -gt 0 ]; then
    echo -e "$RED>> Words that might be misspelled, please check:$NC"
    MISSPELLED=`echo "$MISSPELLED" | sed -E ':a;N;$!ba;s/\n/, /g'`
    echo "$MISSPELLED"
    COMMENT="$NB_MISSPELLED words might be misspelled, please check them: $MISSPELLED"
else
    COMMENT="No spelling errors, congratulations!"
    echo -e "$GREEN>> $COMMENT $NC"
fi

echo $COMMENT

exit 0