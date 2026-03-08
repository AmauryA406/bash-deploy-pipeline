#!/bin/bash

COMMAND=$1

if [ -z "$COMMAND" ]; then
echo "Usage: ./pipeline.sh {build|test|deploy|rollback|logs}"
exit 1
fi

build() {
./scripts/build.sh
}

test() {
echo "test"
}

deploy() {
echo "deploy"
}

rollback() {
echo "rollback"
}

logs() {
echo "logs"
}

case $COMMAND in
"build")
build
;;
"test")
test
;;
"deploy")
deploy
;;
"rollback")
rollback
;;
"logs")
logs
;;
*)
echo "commande inconnue : $COMMAND"
;;
esac
