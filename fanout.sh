#!/bin/sh

set -x

F=$(cat fanout.lua | sed 's/^/          /') \
  perl -i.bak -pe 's/\{fanout\}/$ENV{F}/' ./config.yml
