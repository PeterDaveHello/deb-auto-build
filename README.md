This is a beta verion
=====================
No dangerous and harm, but it's not complete!

deb-auto-build
=========================
Try to build deb packages and handle dependencies automatically.

Because we use Debian-wheezy on a sh4 platform, there is no official binary repository and support, we need to build the packages from source by ourselves, but the dependencies of packages make people crazy, we need a solution to handle it, so I an writing this shell script for a practice.

Required
========
Package and it's dependencies:
devscripts bash tmux

And you need to be root!

Before use it
============
varible REPO in the script is a local apt repo's path

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
start a tmux session and run:
./build.sh Package1 Package2 ... Package-N

Notes
=====
I am doing thins on  a NextVodBox, but it may works on other platform.
