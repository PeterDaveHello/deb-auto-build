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
    package=$1
    echo $package;
    $?=123
    until [ "$?" -eq 0 ]
    do
        tmux rename-window "building-dep $package"
        apt-get build-dep "$package" --force-yes -y 2>&1 | grep 'cannot be found' | cut -d ' ' -f 12 | build_sub_package
        apt-get build-dep "$package" --force-yes -y 2>&1 | grep 'but it is not going to be installed' | cut -d ' ' -f 5 | build_sub_package
        apt-get build-dep "$package" --force-yes -y 2>&1 | grep 'but it is not installable' | cut -d ' ' -f 5 | build_sub_package
        apt-get build-dep "$package" --force-yes -y
    done
    tmux rename-window "building $package"
    apt-get -b source "$package" \
    && tmux rename-window "moving $package" \
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
    package=$1
    echo $package;
    $?=123
    until [ "$?" -eq 0 ]
    do
        tmux rename-window "building-dep $package"
        apt-get build-dep "$package" --force-yes -y 2>&1 | grep 'cannot be found' | cut -d ' ' -f 12 | build_sub_package
        apt-get build-dep "$package" --force-yes -y 2>&1 | grep 'but it is not going to be installed' | cut -d ' ' -f 5 | build_sub_package
        apt-get build-dep "$package" --force-yes -y 2>&1 | grep 'but it is not installable' | cut -d ' ' -f 5 | build_sub_package
        apt-get build-dep "$package" --force-yes -y
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
