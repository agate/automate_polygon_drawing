#!/bin/bash

octave --silent --eval "pkg load image; process_image_to_polygen(\"$1\", $2)"
