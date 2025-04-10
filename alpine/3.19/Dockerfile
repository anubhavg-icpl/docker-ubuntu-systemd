FROM alpine:3.19
LABEL maintainer="Anubhav Gain"

# Install dependencies (Alpine uses OpenRC instead of systemd)
RUN apk update \
    && apk add --no-cache \
        openrc \
        sudo \
        rsyslog \
        rsyslog-openrc \
        procps \
    && rm -rf /var/cache/apk/*

# Prepare OpenRC for container usage
# OpenRC requires special configuration for container environments
RUN mkdir -p /run/openrc \
    && touch /run/openrc/softlevel \
    && ln -sf /dev/null /etc/udev/rules.d/80-net-setup-link.rules \
    && sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab \
    && sed -i \
        -e 's/^#\(rc_sys=".*"\)$/\1/g' \
        -e 's/^rc_sys=".*"/rc_sys="docker"/g' \
        -e 's/^\(rc_provide=".*"\)$/#\1/g' \
        -e 's/^#\(rc_provide=".*"\)$/\1/g' \
        -e 's/^\(rc_provide=".*"\)$/\1 docker/g' \
        -e 's/^#\(rc_logger=".*"\)$/\1/g' \
        -e 's/^rc_logger=".*"/rc_logger="YES"/g' \
        /etc/rc.conf

# Disable imklog module in rsyslog as it's not needed in containers
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Configure required volumes
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# Set up startup command
ENTRYPOINT ["/sbin/init"]
CMD [""]

# Note: To run this container, use the following command:
# docker run -d --name openrc-container --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro your-image-name