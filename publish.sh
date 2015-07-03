#!/bin/sh

cd public
git add .
git commit -m "site update"
git push origin gh-pages
