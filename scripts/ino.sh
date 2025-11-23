#!/bin/bash

LIBRARY_DIR="../mcopy/ino/lib/McopySerial/"

if [[ ! -d ../mcopy ]]; then
	echo "Please install mcopy repo as a peer to intval2 to update Arduino scripts"
	exit 1
fi

function cplib () {
	cp "${LIBRARY_DIR}"* "${1}"
	echo "McopySerial copied to $(basename $1)"

}

cplib ./ino/intval2_3_serial/
cplib ./ino/intval2_4_serial/
cplib ./ino/intval2_debug/
