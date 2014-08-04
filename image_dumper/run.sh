#!/bin/bash

ruby map_html_builder.rb $1 $2 $3 > $4/map.html

http_proxy=www-proxy.corp.factual.com:3128

if [ -z "$http_proxy" ]; then
  phantomjs snapshot.js $4
else
  phantomjs --proxy=$http_proxy snapshot.js $4
fi  
