<!---
#Author: Timothée Moulin
#Date : 2018-01-02
#Language: en
-->

# Github-CI

[Version française ici](README.fr.md)

Build status [![Build Status](https://travis-ci.org/timotheemoulin/github-ci.svg?branch=master)](https://travis-ci.org/timotheemoulin/github-ci)

## Aspell

Aspell is a spell checker that can be used to check your *markdown* files.

Use is to ensure that you don't have misspelled words in your documentation.

You can also write in English in French files, but you can't write in French in English files. Only one language per file is authorized.

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
  sh './bin/spell-check.sh'
end
```

You also need a `Gemfile` to fetch the needed ruby gems.

```ruby
source "https://rubygems.org"

group :test do
  gem 'rake'
end
```

Add the `bin/spell-check.sh` script (you can get it [here](https://github.com/timotheemoulin/github-ci/blob/master/bin/spell-check.sh)).

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
├── bin
│   └── spell-check.sh
├── doc
│   └── foo.md
├── Gemfile
├── Rakefile
├── README.md
```