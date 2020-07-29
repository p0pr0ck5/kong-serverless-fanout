#!/bin/sh

cp ./config.yml.tpl ./config.yml
F=$(cat fanout.lua | sed 's/^/          /') \
  perl -i -pe 's/\{fanout\}/$ENV{F}/' ./config.yml
