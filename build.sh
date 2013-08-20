#!/bin/bash -x

REPO="dists/wheezy-sh4/main/binary-sh4"

function build_sub_package()
{
    while read package_a; do
        build_a_package $package_a
    done
}

function build_a_package()
{
    build_a_package_dep $1;
    echo "now building $1 ...";
    tmux rename-window "building $1"
    apt-get -b source "$1" \
    && tmux rename-window "moving $1" \
    && mv *.deb ../apt-repo/${REPO} \
    && tmux rename-window "rebuilding repo" \
    && cd ../apt-repo \
    && dpkg-scanpackages ${REPO} > ${REPO}/Packages \
    && gzip -c ${REPO}/Packages > ${REPO}/Packages.gz \
    && tmux rename-window "updating apt db" \
    && apt-get update \
    && cd -
}

function build_a_package_dep()
{
    echo "now building $1 dep ...";
    $?=123
    until [ "$?" -eq 0 ]
    do
        tmux rename-window "building-dep $1"
        apt-get build-dep "$1" --force-yes -y 2>&1 | grep 'cannot be found' | cut -d ' ' -f 12 | build_sub_package
        apt-get build-dep "$1" --force-yes -y 2>&1 | grep 'but it is not going to be installed' | cut -d ' ' -f 5 | build_sub_package
        apt-get build-dep "$1" --force-yes -y 2>&1 | grep 'but it is not installable' | cut -d ' ' -f 5 | build_sub_package
        apt-get build-dep "$1" --force-yes -y 2>&1 | grep 'Failed to satisfy Build-Depends dependency' | cut -d ' ' -f 9 | build_sub_package
        apt-get build-dep "$1" --force-yes -y
    done
}

if [ "$#" -lt 1 ]; then
    exit
elif [ "$#" -eq 1 ]; then
    if [ "$1" == "--build-dep-only" ]; then
        exit
    fi
fi

tmux rename-window "updating apt db"
apt-get update

tmux rename-window "upgrading packages"
apt-get upgrade --force-yes -y

if [ "$1" == "--build-dep-only" ]; then
    shift
    for packages in $@
    do
        build_a_package_dep $packages
    done
else
    for packages in $@
    do
        build_a_package $packages
    done
fi

tmux rename-window "Done."
