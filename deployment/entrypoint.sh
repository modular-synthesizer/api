#!/usr/bin/env bash

function web {
  bundle exec rackup -p 80
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