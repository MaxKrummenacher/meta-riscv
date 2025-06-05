FILESEXTRAPATHS:prepend := "${THISDIR}/linux-toradex-upstream:"

DEPENDS:append:milkv-duo = "u-boot-mkimage-native dtc-native"

TDX_PATCHES:append:milkv-duo = " \
	file://0001-sophgo-add-reboot-shutdown-driver.patch \
	file://0002-sophgo-add-ethernet-driver.patch \
	file://0003-dts-exclude-memory-occupied-by-opensbi.patch \
	file://milkv-duo_defconfig \
	file://multi.its \
"

KERNEL_DEVICETREE:milkv-duo ?= "sophgo/cv1800b-milkv-duo.dtb"

A_DEPEND = ""
A_DEPEND:milkv-duo = "milkv-duo-fsbl:do_deploy"

do_deploy[depends] = "${A_DEPEND}"

do_deploy:append:milkv-duo() {
	cp ${B}/arch/riscv/boot/Image.gz ${B}
	cp ${UNPACKDIR}/multi.its ${B}
	mkimage -f ${B}/multi.its ${B}/uImage.fit
	install -m 744 ${B}/uImage.fit ${DEPLOYDIR}
	install -m 744 ${B}/arch/riscv/boot/dts/${KERNEL_DEVICETREE} ${DEPLOYDIR}/default.dtb
}

COMPATIBLE_MACHINE:milkv-duo = "milkv-duo"
