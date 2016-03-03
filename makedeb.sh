#!/bin/bash

# 
# makedeb.sh
# 
#  Creates a Debian package for the LogicNet Utilities
#
#  John Willis <jpw@coherent-logic.com>
#
#  Copyright (C) 2016 Coherent Logic Development LLC
#  All rights reserved.
#
#  This file is part of logicnet-utils.
#  
#  logicnet-utils is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#  
#  You should have received a copy of the GNU Affero General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>.
#

SCRIPTS=`ls -1 bin/`
MANPAGES=`ls -1 doc/`
VERSION=`cat VERSION`
DEBDIR="logicnet-utils-${VERSION}/"
PKGNAME="logicnet-utils"

export DEBEMAIL="jpw@coherent-logic.com"
export DEBFULLNAME=

echo "Generating Debian package for logicnet-utils ${VERSION}..."

rm -f logicnet-utils_*

if [ -d ${DEBDIR} ]; then
    rm -rf ${DEBDIR}
fi

mkdir ${DEBDIR}

for SCRIPT in ${SCRIPTS}
do
    cp bin/${SCRIPT} ${DEBDIR}
done

OLDDIR=`pwd`
cd ${DEBDIR}

dh_make -s --indep --createorig
cp ../dpkg-control debian/control
grep -v makefile debian/rules > debian/rules.new
mv debian/rules.new debian/rules

rm -f debian/manpages

for MANPAGE in ${MANPAGES}
do
    cp ../doc/${MANPAGE} debian/
    echo "debian/${MANPAGE}" >> debian/manpages
done

for SCRIPT in ${SCRIPTS}
do
    echo ${SCRIPT} usr/sbin >> debian/install
done

echo "1.0" > debian/source/format
rm debian/*.ex

debuild -us -uc

cd ${OLDDIR}

