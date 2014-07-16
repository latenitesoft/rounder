rounder
=======
Command line tool for Mac OS X, written in Swift, that makes image dimensions multiples of two. This is useful for processing retina images (@2x) from designers. Produces PNG output.

![rounder](http://cl.ly/image/0D040K0p1f0j/rounder.png)

Usage: 
rounder image-name-regex-pattern [-p]

The optional parameter -p makes rounder preserve the original file instead of replacing it. Files with dimensions which are already multiples of two are ignored.

Sample uages:
rounder myimage.png
rounder @2x.png$ -p

Compiles using Xcode 6 beta 3.
