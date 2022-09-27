#!/usr/bin/env bash

function web {
  bundle exec rackup -p $PORT
}

function shell {
  /bin/sh
}

case "$1" in
  "web")
  web
  ;;

  "shell")
  shell
  ;;
esac