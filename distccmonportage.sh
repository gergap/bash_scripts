#!/bin/bash
# Simply monitores a DistCC build using portage,
# because portage uses a separate DISTCC_DIR
export DISTCC_DIR=/var/tmp/portage/.distcc
distccmon-gui &

