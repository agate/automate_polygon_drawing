#!/bin/bash

ruby map_html_builder.rb $@ > map.html
phantomjs snapshot.js
