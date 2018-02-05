<!---
#Author: Timothée Moulin
#Date : 2018-01-02
#Language: en
-->

# Github-CI

[![Build Status](https://travis-ci.org/timotheemoulin/github-ci.svg?branch=master)](https://travis-ci.org/timotheemoulin/github-ci)

## Aspell

*Aspell* is a spell checker that can be used to check your *markdown* files.

Use it to ensure that you don't have misspelled words in your documentation.

You can also write in English in French files, but you can't write in French in English files. Only one language per file in addition to English is authorized.

### Configuration

First, add a `.travis.yml` file to your project and write the following content.

```yaml
# ruby is the language used to launch the instruction
language: ruby

# select the branches you want to check
branches:
  only:
  - master

# add cache to your bundler
cache: bundler

# add the aspell packages (one per language)
addons:
  apt:
    packages:
      - aspell
      - aspell-en
      - aspell-fr

# execute rake default task
script:
  - bundle exec rake
```

Then, add the `Rakefile`.

```ruby
# Default task
task :default => [:spell_check]

# Spell check task
task :spell_check do
  sh '.aspell/spell-check.sh'
end
```

You also need a `Gemfile` to fetch the needed ruby gems.

```ruby
source "https://rubygems.org"

group :test do
  gem 'rake'
end
```

Add the `.aspell/spell-check.sh` script (you can get it [here](https://github.com/timotheemoulin/github-ci/blob/master/.aspell/spell-check.sh)).

Finally, add the custom dictionaries in `.aspell/aspell.{lang}.pws`. You need at least one dictionary for English and one for all other language you specified in your `.travis.yml` file.

Dictionaries are structured like that :

```
personal_ws-1.1 en 999 utf-8
PHP
Javascript
Git
```

Where : 

* *en* stands for the language name (same as in the file name)
* *999* stands for the number of words in the dictionary (use a big number here if you don't want to change it everytime)
* *utf-8* is the encoding used in your file (keep it to *utf-8* if you need to use accents (like in French or German) or if your dictionnary is used for multiple languages)

### Global structure

```
.
├── .aspell
│   ├── aspell.en.pws
│   ├── aspell.fr.pws
│   └── spell-check.sh
├── Gemfile
├── Gemfile.lock
├── .gitignore
├── LICENSE
├── node_modules
├── Rakefile
├── README.fr.md
├── README.md
└── .travis.yml
```

## PhantomJS Markdown to PDF

What if I tell you that you can even provide an always up to date PDF version of your documentation? Sounds great right?

You can once again use Travis-CI to build and deploy your documentation right into your release files.

### Configuration

Travis-CI can only attach files to a release, not every commit will trigger the PDF generation.

Add the following lines to your `.travis` file.

```yaml
sudo: required
before_install:
  - sudo sh .phantom/install_phantomjs.sh
script:
  - sudo sh .phantom/rasterize.sh README.md .phantom/build/README.pdf
deploy:
  skip_cleanup: true
  provider: releases
  api_key:
    secure: xxx
  file: .phantom/build/README.pdf
  on:
    tags: true
```

This tells Travis-CI to execute your `.phantom/install_phantomjs.sh` script that installs PhantomJS before doing anything else.

Then on the `script` phase, execute the `rasterize.sh` script to generate the PDF version of your `README.md` file and store it somewhere (it doesn't really matter where).

Once your build ends, the Travis-CI deploys your application to Github and adds the `file` to the downloadable files attached to your release.

### Global structure

```
.
├── Gemfile
├── Gemfile.lock
├── .gitignore
├── LICENSE
├── node_modules
├── .phantom
│   ├── build
│   │   └── .gitkeep
│   ├── github.css
│   ├── install_phantomjs.sh
│   ├── rasterize.css
│   ├── rasterize.js
│   └── rasterize.sh
├── Rakefile
├── README.fr.md
├── README.md
└── .travis.yml
```