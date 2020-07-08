export QT_QPA_PLATFORM=eglfs
sleep 1
export QT_QPA_EGLFS_KMS_CONFIG=/etc/kms.json
sleep 1
/usr/share/qt5/examples/opengl/hellowindow/hellowindow --multiscreen