#!/bin/bash

# Create QR codes for cases
echo "Creating QR codes for cases..."
if [ "$(cat FREEZE_QRCODE)" == "True" ]; then
    echo "QR code already published."
else
    echo "Publishing QR code ..."
    python create_cases.py
    echo "QR code published."
fi

# Clone gh-pages branch into _site/
echo "Clone gh-pages branch into _site/ ..."
rm -rf _site
mkdir -p _site/
git clone -b gh-pages "$(git config remote.origin.url)" _site
echo "Clone gh-pages branch into _site/ done."

# Jekyll build, default output is _site/
echo "Jekyll build, default output is _site/ ..."
jekyll build
echo "Jekyll build, default output is _site/ done."

# Push _site to gh-pages
echo "Push _site to gh-pages ..."
wd="$(pwd)"
cd _site || exit
git config pull.rebase false
git pull
rm -f README.md
git add -A
git commit -a -m "update"
git status
git push
cd "$wd" || exit
echo "Push _site to gh-pages done."

echo "Publish done."
