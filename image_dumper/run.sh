#!/bin/bash

DIR="../results/$1+$2"
mkdir -p $DIR

ruby map_html_builder.rb $@ > $DIR/map.html

http_proxy=www-proxy.corp.factual.com:3128

if [ -z "$http_proxy" ]; then
  phantomjs snapshot.js $DIR
else
  phantomjs --proxy=$http_proxy snapshot.js $DIR
fi  
