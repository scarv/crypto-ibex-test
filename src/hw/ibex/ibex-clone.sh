#!/bin/bash

# Copyright (C) 2021 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

#export IBEX_COMMIT="3a1eb7c62fcab217468b2c0e494e432141fad38e"
export IBEX_COMMIT="47f2dc98047b9833b985b3ed8373c62f10e60b40"
export BRANCH="crypto-ibex"

# =============================================================================

if [ ! -d ${IBEX_REPO} ] ; then
  git clone https://github.com/scarv/ibex.git ${IBEX_REPO}
fi

cd ${IBEX_REPO}
git fetch origin ${IBEX_COMMIT}:${BRANCH}
git checkout ${BRANCH}
git submodule update --init

# =============================================================================
