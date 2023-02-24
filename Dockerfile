FROM ghcr.io/sdr-enthusiasts/docker-baseimage:qemu
RUN declare -rx DEBIAN_FRONTEND=noninteractive && \
declare -rx NEEDRESTART_MODE=a && \
export DEBIAN_FRONTEND && \
export NEEDRESTART_MODE && \
apt update && \
apt remove unattended-upgrades -y && \
apt install --no-install-recommends \
gpsd \
gpsd-clients \
ntp \
ntpdate \
-y && \
apt upgrade -y && \
apt autoremove -y && \
apt autoclean
# Copy in files
COPY --chown root:root ./rootfs/ /usr/docker-src-rootfs/
# Copy init script in
COPY --chown root:root ./init.bash /init
# Expose gpsd port tcp://2947
EXPOSE 2947
# Launch init when starting container
ENTRYPOINT ["/usr/bin/bash", "-c", "/init", "--"]
#ENTRYPOINT ["/bin/sh", "-c", "/sbin/syslogd -S -O - -n & exec /usr/sbin/gpsd -N -n -G ${*}","--"]
