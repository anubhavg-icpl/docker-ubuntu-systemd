# Systemd-Enabled Docker Images

[![Build Status](https://github.com/anubhavg-icpl/docker-systemd-images/actions/workflows/build.yml/badge.svg)](https://github.com/anubhavg-icpl/docker-systemd-images/actions/workflows/build.yml)
[![License](https://img.shields.io/badge/license-GPL-blue.svg)](LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/anubhavg-icpl/systemd-images.svg)](https://hub.docker.com/r/anubhavg-icpl/systemd-images)

Production-ready Docker containers with systemd/init system support for various Linux distributions. These images are designed for testing infrastructure code with tools like Ansible and Molecule, as well as for applications requiring proper init systems.

## Repository Structure

```
.
├── README.md
├── debian
│   ├── 11
│   │   └── Dockerfile
│   └── 12
│       └── Dockerfile
├── redhat
│   ├── alma9
│   │   └── Dockerfile
│   ├── centos7
│   │   └── Dockerfile
│   ├── fedora39
│   │   └── Dockerfile
│   ├── rocky9
│   │   └── Dockerfile
│   └── ubi9
│       └── Dockerfile
├── suse
│   └── leap15.5
│       └── Dockerfile
├── ubuntu
│   ├── 20.04
│   │   └── Dockerfile
│   └── 22.04
│       └── Dockerfile
└── other
    ├── alpine3.19
    │   └── Dockerfile
    └── arch
        └── Dockerfile
```

## Available Images

| Distribution | Tag | Base Image | Init System | Status |
|--------------|-----|------------|------------|--------|
| Ubuntu | `22.04`, `jammy`, `latest` | `ubuntu:22.04` | systemd | Active Support |
| Ubuntu | `20.04`, `focal` | `ubuntu:20.04` | systemd | Active Support |
| Debian | `12`, `bookworm` | `debian:12` | systemd | Active Support |
| Debian | `11`, `bullseye` | `debian:11` | systemd | Active Support |
| Red Hat UBI | `9`, `ubi9` | `registry.access.redhat.com/ubi9/ubi` | systemd | Active Support |
| CentOS | `7`, `centos7` | `centos:7` | systemd | Maintenance Only |
| Rocky Linux | `9`, `rocky9` | `rockylinux:9` | systemd | Active Support |
| AlmaLinux | `9`, `alma9` | `almalinux:9` | systemd | Active Support |
| Fedora | `39`, `fedora39` | `fedora:39` | systemd | Active Support |
| openSUSE Leap | `15.5`, `leap15.5` | `opensuse/leap:15.5` | systemd | Active Support |
| Arch Linux | `latest`, `arch` | `archlinux:latest` | systemd | Rolling Release |
| Alpine Linux | `3.19`, `alpine3.19` | `alpine:3.19` | OpenRC | Active Support |

## Quick Start Guide

### Pull an Image

```bash
# Pull the Ubuntu 22.04 image (default)
docker pull anubhavg-icpl/systemd-images:22.04

# Pull a specific distribution
docker pull anubhavg-icpl/systemd-images:ubi9
docker pull anubhavg-icpl/systemd-images:debian12
docker pull anubhavg-icpl/systemd-images:rocky9
```

### Run a Container

```bash
# Run with systemd support
docker run -d \
  --name systemd-container \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  anubhavg-icpl/systemd-images:22.04
```

### Connect to a Running Container

```bash
docker exec -it systemd-container bash
```

### Test Systemd Functionality

```bash
# Inside the container
systemctl status
```

## Building Images Locally

### Build a Specific Distribution

```bash
# Clone the repository
git clone https://github.com/anubhavg-icpl/docker-systemd-images.git
cd docker-systemd-images

# Build Ubuntu 22.04
docker build -t systemd-ubuntu:22.04 -f ubuntu/22.04/Dockerfile .

# Build Red Hat UBI 9
docker build -t systemd-ubi:9 -f redhat/ubi9/Dockerfile .

# Build Debian 12
docker build -t systemd-debian:12 -f debian/12/Dockerfile .
```

### Build All Images with Docker Compose

```bash
# Build all images
docker-compose build
```

## Security Considerations

### Privileged Mode Requirements

These containers require the `--privileged` flag to function correctly with systemd, which has security implications. For production environments:

1. **Use with caution:** These images are primarily designed for testing or development scenarios
2. **Apply least privilege:** When possible, use more specific capabilities instead of full privileged mode:

```bash
docker run -d --name systemd-container \
  --cap-add SYS_ADMIN \
  --security-opt seccomp=unconfined \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  anubhavg-icpl/systemd-images:22.04
```

3. **Consider Podman:** Podman can run systemd containers without privileged mode
4. **Implement proper network isolation:** Use custom networks and restrict exposure

### Security Hardening

All images follow these security best practices:

1. **Minimal package installation:** Only necessary packages are included
2. **Up-to-date base images:** Latest versions with security patches
3. **Proper cleanup:** Removal of cache, temporary files, and documentation
4. **Secure default configurations:** Unnecessary services disabled

## Usage with Infrastructure Tools

### Ansible Integration

```yaml
# Example inventory file
[containers]
systemd-container ansible_connection=docker

# Run a playbook against the container
ansible-playbook -i inventory playbook.yml
```

### Molecule Configuration

```yaml
# molecule.yml
platforms:
  - name: ubuntu-22
    image: anubhavg-icpl/systemd-images:22.04
    pre_build_image: true
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
```

### CI/CD Integration Examples

#### GitHub Actions

```yaml
# .github/workflows/test.yml
jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: anubhavg-icpl/systemd-images:22.04
      options: --privileged
    steps:
      - uses: actions/checkout@v2
      - name: Test systemd
        run: systemctl status
```

#### GitLab CI

```yaml
# .gitlab-ci.yml
test:
  image: anubhavg-icpl/systemd-images:22.04
  variables:
    DOCKER_HOST: tcp://docker:2375
  services:
    - docker:dind
  script:
    - systemctl status
```

## Advanced Usage

### Creating Custom Service-Enabled Images

```dockerfile
FROM anubhavg-icpl/systemd-images:22.04

# Install and configure a service
RUN apt-get update && apt-get install -y nginx \
    && systemctl enable nginx

# Expose the service port
EXPOSE 80

# The entrypoint from the base image (systemd) will be used
```

### Multi-Service Containers

While generally not recommended for production, you can run multiple services in development:

```dockerfile
FROM anubhavg-icpl/systemd-images:ubi9

# Install multiple services
RUN dnf -y install nginx mariadb-server \
    && dnf clean all \
    && systemctl enable nginx mariadb

# Create a custom startup check script
COPY healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

HEALTHCHECK CMD /usr/local/bin/healthcheck.sh
```

## Distribution-Specific Notes

### Ubuntu/Debian

- Uses `/lib/systemd/systemd` as entrypoint
- Requires the `systemd-sysv` package for compatibility symlinks
- Preferred for Ansible testing due to widespread use

### Red Hat Family (UBI, CentOS, Rocky, Alma)

- Uses `/usr/sbin/init` as entrypoint
- Includes SELinux packages by default (disabled in container context)
- Requires `systemd-sysv` for proper systemd operation

### Alpine Linux

- Uses OpenRC instead of systemd
- Lighter weight alternative for simple service management
- Uses `/sbin/init` as entrypoint with special OpenRC configuration

### Arch Linux

- Uses `/usr/lib/systemd/systemd` as entrypoint
- Rolling release model provides latest packages
- Best for testing with bleeding-edge components

## Troubleshooting

### Common Issues

1. **Container exits immediately:** Ensure the cgroup volume is properly mounted
   ```bash
   docker run -d --name systemd-test --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro anubhavg-icpl/systemd-images:22.04
   ```

2. **Systemd services fail to start:** Check if you're running with `--privileged` flag
   ```bash
   docker logs systemd-test
   ```

3. **Cannot enable service:** Some services need additional volumes or capabilities
   ```bash
   docker run -d --name systemd-test --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /run/lock:/run/lock anubhavg-icpl/systemd-images:22.04
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the GPL License - see the [LICENSE](LICENSE) file for details.

## Author

Created by Anubhav Gain

## Acknowledgments

- The Docker and container community
- Red Hat, Canonical, and other distribution maintainers
- Ansible/Molecule projects for inspiration and testing methodologies