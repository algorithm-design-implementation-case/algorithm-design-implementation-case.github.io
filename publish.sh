#!/bin/bash

if [ "$(cat FREEZE_QRCODE)" == "True" ]; then
    echo "QR code already published."
    exit 0
else
    echo "Publishing QR code ..."
    python create_cases.py
    echo "QR code published."
fi

rm -rf _site
mkdir -p _site/
git clone -b gh-pages "$(git config remote.origin.url)" _site
git status

jekyll build

wd="$(pwd)"
cd _site || exit
git config pull.rebase false
git pull
rm -f README.md
git add -A
git commit -a -m "update"
git push
cd "$wd" || exit
