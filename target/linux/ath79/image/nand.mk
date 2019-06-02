define Device/glinet_gl-ar300m-common
  ATH_SOC := qca9531
  DEVICE_VENDOR := GL.iNet
  DEVICE_MODEL := GL-AR300M
  DEVICE_PACKAGES := kmod-usb2
  KERNEL_SIZE := 2048k
  IMAGE_SIZE := 16000k
  PAGESIZE := 2048
  VID_HDR_OFFSET := 2048
endef

define Device/glinet_gl-ar300m-nand
  $(Device/glinet_gl-ar300m-common)
  DEVICE_VARIANT := NAND
  BLOCKSIZE := 128k
  IMAGES += factory.img
  IMAGE/factory.img := append-kernel | pad-to $$$$(KERNEL_SIZE) | append-ubi
  IMAGE/sysupgrade.bin := sysupgrade-tar alt-board=gl-ar300m alt-board=glinet_gl-ar300m-nor | append-metadata
  SUPPORTED_DEVICES += gl-ar300m glinet,gl-ar300m-nor
endef
TARGET_DEVICES += glinet_gl-ar300m-nand

define Device/glinet_gl-ar300m-nor
  $(Device/glinet_gl-ar300m-common)
  DEVICE_VARIANT := NOR
  BLOCKSIZE := 64k
  SUPPORTED_DEVICES += gl-ar300m glinet,gl-ar300m-nand
endef
TARGET_DEVICES += glinet_gl-ar300m-nor


define Device/glinet_gl-ar750s-common
  ATH_SOC := qca9563
  DEVICE_VENDOR := GL.iNet
  DEVICE_MODEL := GL-AR750S
  DEVICE_PACKAGES := kmod-ath10k-ct ath10k-firmware-qca9887-ct \
			kmod-usb2 kmod-usb-storage block-mount
  KERNEL_SIZE := 2048k
  IMAGE_SIZE := 16000k
  PAGESIZE := 2048
  VID_HDR_OFFSET := 2048
endef

define Device/glinet_gl-ar750s-nor-nand
  $(Device/glinet_gl-ar750s-common)
  DEVICE_VARIANT := NOR/NAND
  BLOCKSIZE := 128k
  IMAGES += factory.img
  IMAGE/factory.img := append-kernel | pad-to $$$$(KERNEL_SIZE) | append-ubi
  IMAGE/sysupgrade.bin := sysupgrade-tar alt-board=gl-ar750s alt-board=glinet_gl-ar750s-nor | append-metadata
  SUPPORTED_DEVICES += gl-ar750s glinet,gl-ar750s-nor
endef
TARGET_DEVICES += glinet_gl-ar750s-nor-nand

define Device/glinet_gl-ar750s-nor
  $(Device/glinet_gl-ar750s-common)
  DEVICE_VARIANT := NOR
  BLOCKSIZE := 64k
  SUPPORTED_DEVICES += gl-ar750s glinet,gl-ar750s glinet,gl-ar750s-nor-nand
endef
TARGET_DEVICES += glinet_gl-ar750s-nor
