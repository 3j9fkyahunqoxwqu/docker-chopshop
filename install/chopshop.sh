#!/bin/sh

set -x

git clone --recursive git://github.com/MITRECND/chopshop

cd chopshop

make
make install
