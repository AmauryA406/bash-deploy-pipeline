#!/bin/bash

PROJECT_DIR="$(dirname "$0")/.."
ENV=$1

if [ -z $ENV ]; then
echo "erreur : ./scripts/deploy.sh {local|staging|prod}"
exit 1
fi

if [ "$ENV" != "local" ] && [ "$ENV" != "staging" ] && [ "$ENV" != "prod" ]; then
echo "Erreur : environnement invalide"
exit 1
fi

if [ -f "$PROJECT_DIR/deploy/$ENV/index.html" ]; then
cp "$PROJECT_DIR/deploy/$ENV/index.html" "$PROJECT_DIR/deploy/$ENV/index.html.backup"
echo "backup sauvegardé : $PROJECT_DIR/deploy/$ENV/index.html.backup"
fi

cp "$PROJECT_DIR/build/index.html" "$PROJECT_DIR/deploy/$ENV/index.html"
echo "Modification déployés"

DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "$DATE | $ENV | status : success" >> $PROJECT_DIR/logs/deploy.log
