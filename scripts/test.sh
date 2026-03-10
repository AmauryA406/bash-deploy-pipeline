#!/bin/bash

PROJECT_DIR="$(dirname "$0")/.."
ERRORS=0

if [ -f "$PROJECT_DIR/build/index.html" ]; then
echo "succès : Le fichier a bein été transféré"
else
echo "erreur : build/index.html introuvable"
ERRORS=$((ERRORS + 1))
fi

if grep -q "VERSION" $PROJECT_DIR/build/index.html; then
echo "succès : Test commentaire VERSION OK"
else
echo "erreur : Commentaire VERSION manquant"
ERRORS=$((ERRORS + 1))
fi

if grep -q 'id="version">v' $PROJECT_DIR/build/index.html; then
echo "succès : Test version OK"
else
echo "erreur : Numéro de version manquant"
ERRORS=$((ERRORS + 1))
fi

NB_DIV=$(grep -o "<div" $PROJECT_DIR/build/index.html | wc -l)
NB_DIV_CLOSE=$(grep -o "</div>" $PROJECT_DIR/build/index.html | wc -l)

if [ $NB_DIV -ne $NB_DIV_CLOSE ]; then
echo "erreur : div non fermé"
ERRORS=$((ERRORS + 1))
else
echo "succès : div equal"
fi

grep 'rel="stylesheet"' $PROJECT_DIR/build/index.html | while read ligne; do
CSS=$(echo $ligne | sed 's/.*href="\([^"]*\)".*/\1/')
if [ -f "$PROJECT_DIR/app/$CSS" ]; then
echo "succès : CSS $CSS  trouvé"
else
echo "erreur : CSS $CSS introuvable"
exit 1
fi
done

if [ $ERRORS -ne 0 ]; then
echo "$ERRORS erreur(s) détéctée(s) - déploiement bloqué"
exit 1
else
echo "Tous les tests sont passés"
fi
