#!/bin/bash

echo "====> Starting from dev entrypoint..."

>&2 echo "Installing dependencies..."
mix do deps.get


if [ -z ${NODE_IP+x} ]; then
  export NODE_IP="$(hostname -i | cut -f1 -d' ')"
fi
echo "NODE_IP=${NODE_IP} set"


### Start the app or console
if [ "$1" = 'init' ]; then
  elixir --name ${NODE_BASENAME}@${NODE_IP} --cookie ${ERLANG_COOKIE} -S mix phx.server
elif [ "$1" = 'console' ]; then
  iex --name ${NODE_BASENAME}@${NODE_IP} --cookie ${ERLANG_COOKIE} -S mix
else
  /bin/sh
fi
