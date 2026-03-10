#!/bin/bash

set -eux

cd `dirname $0`

if [[ -z "${PREFIX:-}" ]]; then
	echo 1>&2 'must define PREFIX first'
	echo 1>&2 'try "export PREFIX=`mktemp -d`"'
	exit 1
fi

# Do we need to run autogen.sh?
if [[ ! -f autogen.stamp ]] || [[ ! -x configure ]] || [[ configure -nt autogen.stamp ]] ; then
	./autogen.sh
	touch autogen.stamp
fi

# Do we need to run configure?
if [[ ! -f config.status ]] || [[ config.status -ot configure ]] ; then
	./configure --prefix=${PREFIX}
fi

if [[ ! -f install.stamp ]] || [[ install.stamp -ot Makefile ]] ; then
	make -j 20
	make install
	touch install.stamp
fi

env PATH=${PREFIX}/bin:${PATH} C_INCLUDE_PATH=${PREFIX}/include \
  LD_LIBRARY_PATH=${PREFIX}/lib LIBRARY_PATH=${PREFIX}/lib \
  PYTHONPATH=${PREFIX}/lib/graphviz/python3 \
  TCLLIBPATH=${PREFIX}/lib/graphviz/tcl \
  PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig \
  graphviz_ROOT=${PREFIX} \
  python3 -m pytest -m "not slow" tests
