#!/bin/bash

PROJECT_DIR="$(dirname "$0")/.."

rm -rf $PROJECT_DIR/build/*
echo "Suppression des fichiers existant de : build"

if [ -f "$PROJECT_DIR/app/index.html" ]; then
cp $PROJECT_DIR/app/index.html $PROJECT_DIR/build
echo "Transfère de : app/index.html, vers : build/index.html"
else
echo "Erreur : app/index.html introuvable"
exit 1
fi
