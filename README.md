This is a beta verion
=====================
No dangerous and harm, but it's not complete! <br />

deb-auto-build
=========================
Try to build deb packages and handle dependencies automatically. <br />
 <br />
Because we use Debian-wheezy on a sh4 platform, there is no official binary repository and support, we need to build the packages from source by ourselves, but the dependencies of packages make people crazy, we need a solution to handle it, so I an writing this shell script for a practice.

Required
========
Package and it's dependencies: <br />
devscripts bash tmux <br />
<br />
And you need to be root! <br />

Before use it
============
varible REPO in the script is a local apt repo's path <br />
 <br />
You need to check the path in the script is correct for you. <br />
 <br />
I will show you my directory structure here: <br />
 <br />
/root <br />
|----/temp <br /> 
      Building packages here!so the script will be here! <br />
|----/apt-repo/dists/wheezy-sh4/main/binary-sh4 <br />
      Local apt repo <br />
<br />
It's very simple! <br />

Usage
=====
start a tmux session and run: <br />
./build.sh Package1 Package2 ... Package-N <br />

Notes
=====
I am doing thins on  a NextVodBox, but it may works on other platform.
