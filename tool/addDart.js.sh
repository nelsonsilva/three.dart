#!/bin/sh
# Ugly stuff... adds the dart.js file to every example
if [ -z "$DART_SDK" ]; then
    echo "Please set your DART_SDK env variable before running this script"
    exit 1
fi

PUB=$DART_SDK/bin/pub

$PUB install
for example in `find example -maxdepth 1 -type d ! -name example`
do
    rm $example/packages
    mkdir -p $example/packages/browser
    cp packages/browser/dart.js $example/packages/browser
    git add -f $example/packages/browser/dart.js
done;
