#!/bin/bash

set -eux

env PATH=${PREFIX}/bin:${PATH} C_INCLUDE_PATH=${PREFIX}/include \
  LD_LIBRARY_PATH=${PREFIX}/lib LIBRARY_PATH=${PREFIX}/lib \
  PYTHONPATH=${PREFIX}/lib/graphviz/python3 \
  TCLLIBPATH=${PREFIX}/lib/graphviz/tcl \
  PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig \
  graphviz_ROOT=${PREFIX} \
  python3 -m pytest tests
