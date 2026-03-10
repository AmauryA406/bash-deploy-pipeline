#!/bin/bash

PROJECT_DIR="$(dirname "$0")/.."
ENV=$1

if [ -z $ENV ]; then
echo "erreur usage : ./scripts/rollback.sh {local|staging|prod}"
exit 1

elif [ $ENV != "local" ] && [ $ENV != "staging" ] && [ $ENV != "prod" ]; then
echo "erreur usage : ./scripts/rollback.sh {local|staging|prod}"
exit 1
fi

if [ -f "$PROJECT_DIR/deploy/$ENV/index.html.backup" ]; then
echo "backup disponible"
else
echo "Erreur : aucun backup disponible pour $ENV"
exit 1
fi

cp $PROJECT_DIR/deploy/$ENV/index.html.backup $PROJECT_DIR/deploy/$ENV/index.html
echo "Succès : fichier restauré"

DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "$DATE | $ENV | status : rollback" >> $PROJECT_DIR/logs/deploy.log
