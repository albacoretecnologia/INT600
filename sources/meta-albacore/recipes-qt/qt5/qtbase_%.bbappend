FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://kms.json"

PACKAGECONFIG_append = " linuxfb eglfs gbm kms examples"

do_install_append() {
	install -d ${D}${sysconfdir}
	install -m 0664 ${WORKDIR}/kms.json ${D}${sysconfdir}/kms.json
}
