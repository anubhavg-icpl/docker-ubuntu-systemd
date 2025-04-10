FROM ubuntu:22.04
LABEL maintainer="Anubhav Gain"

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies and clean up in a single layer to reduce image size
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        software-properties-common \
        rsyslog \
        systemd \
        systemd-cron \
        sudo \
    && apt-get clean \
    && rm -rf /usr/share/doc /usr/share/man \
    && rm -rf /var/lib/apt/lists/* \
    && touch -d "2 hours ago" /var/lib/apt/lists

# Disable imklog module in rsyslog as it's not needed in containers
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Container-specific systemd configuration
# Remove unnecessary systemd units that might cause conflicts in containers
RUN rm -f /lib/systemd/system/systemd*udev* \
    && rm -f /lib/systemd/system/getty.target \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    && rm -f /lib/systemd/system/systemd-update-utmp*

# Configure required volumes for systemd
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# Use init system as entry point
ENTRYPOINT ["/lib/systemd/systemd"]
CMD [""]

# Note: To run this container with systemd, use the following command:
# docker run -d --name systemd-container --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro your-image-name