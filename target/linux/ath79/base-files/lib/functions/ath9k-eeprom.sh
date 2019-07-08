#!/bin/sh

ath9k_eeprom_die() {
	echo "ath9k eeprom: " "$*"
	exit 1
}

ath9k_eeprom_extract() {
	local part=$1
	local offset=$2
	local count=$3
	local mtd

	mtd=$(find_mtd_chardev $part)
	[ -n "$mtd" ] || \
		ath9k_eeprom_die "no mtd device found for partition $part"

	dd if=$mtd of=/lib/firmware/$FIRMWARE iflag=skip_bytes bs=$count skip=$offset count=1 2>/dev/null || \
		ath9k_eeprom_die "failed to extract from $mtd"
}

ath9k_eeprom_extract_reverse() {
	local part=$1
	local offset=$2
	local count=$3
	local mtd
	local reversed
	local caldata

	mtd=$(find_mtd_chardev "$part")
	reversed=$(hexdump -v -s $offset -n $count -e '/1 "%02x "' $mtd)

	for byte in $reversed; do
		caldata="\x${byte}${caldata}"
	done

	printf "%b" "$caldata" > /lib/firmware/$FIRMWARE
}

xor() {
	local val
	local ret="0x$1"
	local retlen=${#1}

	shift
	while [ -n "$1" ]; do
		val="0x$1"
		ret=$((ret ^ val))
		shift
	done

	printf "%0${retlen}x" "$ret"
}

ath9k_patch_fw_mac() {
	local mac=$1
	local mac_offset=$2
	local chksum_offset=$3
	local xor_mac
	local xor_fw_mac
	local xor_fw_chksum

	[ -z "$mac" -o -z "$mac_offset" ] && return

	[ -n "$chksum_offset" ] && {
		xor_mac=${mac//:/}
		xor_mac="${xor_mac:0:4} ${xor_mac:4:4} ${xor_mac:8:4}"

		xor_fw_mac=$(hexdump -v -n 6 -s $mac_offset -e '/1 "%02x"' /lib/firmware/$FIRMWARE)
		xor_fw_mac="${xor_fw_mac:0:4} ${xor_fw_mac:4:4} ${xor_fw_mac:8:4}"

		xor_fw_chksum=$(hexdump -v -n 2 -s $chksum_offset -e '/1 "%02x"' /lib/firmware/$FIRMWARE)
		xor_fw_chksum=$(xor $xor_fw_chksum $xor_fw_mac $xor_mac)

		printf "%b" "\x${xor_fw_chksum:0:2}\x${xor_fw_chksum:2:2}" | \
			dd of=/lib/firmware/$FIRMWARE conv=notrunc bs=1 seek=$chksum_offset count=2
	}

	macaddr_2bin $mac | dd of=/lib/firmware/$FIRMWARE conv=notrunc oflag=seek_bytes bs=6 seek=$mac_offset count=1
}

ath9k_patch_fw_mac_crc() {
	local mac=$1
	local mac_offset=$2
	local chksum_offset=$((mac_offset - 10))

	ath9k_patch_fw_mac "${mac}" "${mac_offset}" "${chksum_offset}"
}
