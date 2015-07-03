#!/bin/sh

hugo

git add .
git commit -m "updating source files"
git push origin master

cd public
git add .
git commit -m "updating static files"
git push origin gh-pages
