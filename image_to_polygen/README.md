# How to use
## input
  test.png

## output
  point - contains only boundary point, style as 'x y' for each line

## shell command
  ./run.sh

------------------------------

# OPENSOURCE SOLUTION - Octave

## Site

http://www.octave.org/

## Install
### Mac

1. [http://wiki.octave.org/Octave_for_MacOS_X](http://wiki.octave.org/Octave_for_MacOS_X)
2. Recommanded: [Binary DMG](http://sourceforge.net/projects/octave/files/Octave%20MacOSX%20Binary/2013-12-30%20binary%20installer%20of%20Octave%203.8.0%20for%20OSX%2010.9.1%20%28beta%29/)

### Install Packages

1. ALL IN [http://octave.sourceforge.net/](http://octave.sourceforge.net/)
2. run your octave
    1. pkg install -forge general
    2. pkg install -forge control
    3. pkg install -forge signal
    4. pkg install -forge image   # this is what we need
3. ./run.octave.sh <xxx.png>
