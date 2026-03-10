#!/bin/bash

COMMAND=$1
ARG_2=$2

if [ -z "$COMMAND" ]; then
echo "Usage: ./pipeline.sh {build|test|deploy|rollback|logs}"
exit 1
fi

build() {
./scripts/build.sh
}

test() {
./scripts/test.sh
}

deploy() {
./scripts/deploy.sh $ARG_2
}

rollback() {
./scripts/rollback.sh $ARG_2
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
