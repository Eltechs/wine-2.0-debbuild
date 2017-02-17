#!/bin/bash -x 


function die
{
    echo $1
    exit 1
}

[ -z ${WINE_ORIG} ] && die "Usage: WINE_ORIG=<path-to-orig-tarball> ${0}"
pushd `dirname ${0}`

. ppa-credentials

ln -s ${WINE_ORIG}
bzcat ${WINE_ORIG} | tar -x
cp -ra debian wine-2.0/
pushd  wine-2.0
debuild -S -sa || die "Failed to build deb-src package"
popd
dput ${PPA} `ls | grep \.changes` || die "Failed to forward deb-src package to ppa"
popd

