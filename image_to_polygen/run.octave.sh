#!/bin/bash

export PATH=/usr/local/octave/3.8.0/bin:/usr/local/octave/3.8.0/sbin:${PATH}
export GNUTERM=qt
/usr/local/octave/3.8.0/bin/octave --eval "pkg load image; process_image_to_polygen(\"$1\")"
