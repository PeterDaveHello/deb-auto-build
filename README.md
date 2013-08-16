This is a beta verion
=====================
no dangerous and harm, but it's not complete!

wheezy-sh4-deb-auto-build
=========================
try to build deb packages and handle dependencies automatically

Required
========
Package and it's dependencies:
devscripts bash

And you need to be root!

Before use it
============
var REPO is  a local apt repo's path

You need to check the path in the script is correct for you.

I will show you my directory structure here:

/root
|----/temp
      Building packages here!so the script will be here!
|----/apt-repo/dists/wheezy-sh4/main/binary-sh4
      Local apt repo

It's very simple!

Usage
=====
./build.sh Package1 Package2 ... Package-N

Notes
=====
I am doing thins on  a NextVodBox, but it may works on other platform.
