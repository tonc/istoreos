FROM scratch
# ADD istoreos.rootfs.tar.gz /
ADD /github/workspace/istoreos.rootfs.tar.gz /
CMD ["/sbin/init"]