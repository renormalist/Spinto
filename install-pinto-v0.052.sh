#! /bin/bash

# Install the perfect Pinto (v0.052 plus the 'add --force' feature)

set -x
set -e

MYTMP=/tmp/pinto52
mkdir -p $MYTMP

git_clone () {
    if [ -e $1 ] ; then
        (
            cd $1
            git stash
            git stash clear
            git clean -dxf
            git co master
            git pull
        )
    else
        git clone git://github.com/renormalist/$1.git
    fi
}

dzil_install () {
    dzil authordeps | cpanm
    dzil listdeps | grep -v '^Pinto' | cpanm
    dzil install
}

install_pinto_common () {
    cd $MYTMP
    git_clone Pinto-Common
    cd Pinto-Common
    git checkout release-0.047
    dzil_install
}

install_pinto () {
    cd $MYTMP
    git_clone Pinto
    cd Pinto
    git checkout remotes/origin/combined
    dzil_install
}

install_app_pinto () {
    cd $MYTMP
    git_clone App-Pinto
    cd App-Pinto
    dzil_install
}

install_pinto_common
install_pinto
install_app_pinto
