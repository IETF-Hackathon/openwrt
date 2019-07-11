#!/bin/sh

# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2019 Jeff Kletsky
#

PART_NAME=firmware

REQUIRE_IMAGE_METADATA=1
platform_check_image() {
	return 0
}

RAMFS_COPY_BIN='fw_printenv fw_setenv'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

nand_nor_do_upgrade() {
	local upgrade_file="$1"

	local pn
	local found=""
	local err

	case "$(get_magic_long "$upgrade_file")" in

	"27051956")	# U-Boot Image Magic

		for pn in "$PART_NAME" "nor_${PART_NAME}" ; do		# firmware
			if [ "$(find_mtd_index "$pn")" ] ; then
				PART_NAME="$pn"
				found="yes"
				break
			fi
		done
		if [ "$found" = "yes" ] ; then
			>&2 echo "Running NOR upgrade"
			default_do_upgrade "$upgrade_file"
			err=$?
			if [ "$err" != 0 ] ; then
				>&2 echo "ERROR: Upgrade failed ($err). Not changing next boot."
			else
				type set_next_boot_nor >/dev/null && set_next_boot_nor
			fi
		else
			>&2 echo "ERROR: UPGRADE FAILED: Unable to locate '$PART_NAME' or 'nor_${PART_NAME}'"
			exit 1
		fi
		;;


	*)	# otherwise a file that nand_do_upgrade can process

		for pn in "$CI_KERNPART" "nand_${CI_KERNPART}" ; do	# kernel
			if [ "$(find_mtd_index "$pn")" ] ; then
				CI_KERNPART="$pn"
				break
			fi
		done
		for pn in "$CI_UBIPART" "nand_${CI_UBIPART}" ; do	# ubi
			if [ "$(find_mtd_index "$pn")" ] ; then
				CI_UBIPART="$pn"
				break
			fi
		done
		for pn in "$CI_ROOTPART" "nand_${CI_ROOTPART}" ; do	#rootfs
			if [ "$(find_mtd_index "$pn")" ] ; then
				CI_ROOTPART="$pn"
				break
			fi
		done
		>&2 echo "Running NAND upgrade"
		# TODO: change order when NAND upgrade offers return
		type set_next_boot_nand >/dev/null && set_next_boot_nand
		nand_do_upgrade "$upgrade_file"
		;;
	esac
}


platform_do_upgrade() {
	local board="$(board_name)"

	case "$board" in
	glinet,gl-ar300m-nand |\
	glinet,gl-ar300m-nor)
		glinet_nand_nor_do_upgrade "$ARGV"
		;;
	glinet,gl-ar750s-nor |\
	glinet,gl-ar750s-nor-nand)
		nand_nor_do_upgrade "$ARGV"
		;;
	*)
		nand_do_upgrade "$ARGV"
		;;
	esac
}
