FROM scratch
ADD istoreos.rootfs.tar.gz /
CMD ["/sbin/init"]