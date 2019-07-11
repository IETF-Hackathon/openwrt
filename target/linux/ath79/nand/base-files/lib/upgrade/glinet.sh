#!/bin/sh

# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2019 Jeff Kletsky
#

glinet_using_boot_dev_switch() {
	if [ "$(fw_printenv -n boot_dev 2>/dev/null)" = "on" ] ; then
		>&2 echo "NOTE: boot_dev=on; use switch to control boot partition"
		true
	else
		false
	fi
}

glinet_set_next_boot_nand() {
	! glinet_using_boot_dev_switch &&	\
		fw_setenv bootcount 0 &&	\
		>&2 echo "Next boot set for NAND"
}

glinet_set_next_boot_nor() {
	! glinet_using_boot_dev_switch &&	\
		fw_setenv bootcount 3 &&	\
		>&2 echo "Next boot set for NOR"
}

glinet_nand_nor_do_upgrade() {
	set_next_boot_nand() { glinet_set_next_boot_nand; }
	set_next_boot_nor() { glinet_set_next_boot_nor; }
	nand_nor_do_upgrade "$1"
}
