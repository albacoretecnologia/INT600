FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
	https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.2.tar.xz \
	file://0001-da9063hwmon.patch \
	file://0002-config.patch \
	file://0003-albacore.patch \
        file://0004-uartpwrenable.patch \
	file://0005-disable-edid.patch \
	"

SRC_URI[md5sum] = "07a4df090466eb7b24eec5fe4fbd5500"
SRC_URI[sha256sum] = "32f98256877ca6b016715ffffcf184f1603df9e17a324787f252cd602e03a557"

S="${WORKDIR}/linux-5.4.2"

FILES_kernel-base += "/lib/modules/5.4.2/modules.builtin.modinfo"

do_preconfigure() {
}

COMPATIBLE_MACHINE = "(ccimx6ul|use-mainline-bsp)"
