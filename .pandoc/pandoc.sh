#!/usr/bin/env bash

# pandoc --latex-engine=xelatex README.md -f markdown -o .pandoc/build/README.pdf

pandoc --latex-engine=xelatex .redcarpet/github.md -f markdown -o .pandoc/build/github.pdf