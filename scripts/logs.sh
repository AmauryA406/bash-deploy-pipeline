#!/bin/bash

PROJECT_DIR="$(dirname "$0")/.."

if [ -f $PROJECT_DIR/logs/deploy.log ]; then
cat "$PROJECT_DIR/logs/deploy.log"
else
echo "Aucun déploiement trouvé"
exit 1
fi
