BOARDNAME := Generic devices with NAND flash

FEATURES += squashfs nand

DEFAULT_PACKAGES += wpad-basic

define Target/Description
	Firmware for boards based on MIPS 24kc Atheros/Qualcomm SoCs
	in the ar72xx and subsequent series with support for NAND flash
endef
