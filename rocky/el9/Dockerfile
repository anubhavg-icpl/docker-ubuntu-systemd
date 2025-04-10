FROM rockylinux:9
LABEL maintainer="Anubhav Gain"

# Install dependencies and clean up in a single layer to reduce image size
RUN dnf -y update \
    && dnf -y install \
        systemd \
        systemd-sysv \
        rsyslog \
        sudo \
        procps-ng \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && rm -rf /usr/share/doc /usr/share/man

# Disable imklog module in rsyslog as it's not needed in containers
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Container-specific systemd configuration
# Remove unnecessary systemd units that might cause conflicts in containers
RUN (cd /lib/systemd/system/sysinit.target.wants/; \
    for i in *; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Configure required volumes for systemd
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]

# Set stop signal to SIGRTMIN+3 (systemd best practice)
STOPSIGNAL SIGRTMIN+3

# Use init system as entry point
ENTRYPOINT ["/usr/sbin/init"]
CMD [""]

# Note: To run this container with systemd, use the following command:
# docker run -d --name systemd-container --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro your-image-name