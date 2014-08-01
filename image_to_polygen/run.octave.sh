#!/bin/bash

octave --eval "pkg load image; process_image_to_polygen(\"$1\")"
