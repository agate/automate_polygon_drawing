#!/bin/bash

ruby map_html_builder.rb $@ > map.html
phantomjs --proxy=www-proxy.corp.factual.com:3128 snapshot.js
