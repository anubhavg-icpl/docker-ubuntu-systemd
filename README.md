# Multi-Distro Docker Images with systemd

Production-ready Docker containers with systemd support for various Linux distributions. Designed for testing infrastructure code with tools like `ansible` and `molecule`, as well as for applications requiring proper init systems.

## Available Base Images

| Distribution | Base Image | Notes |
|--------------|------------|-------|
| Ubuntu 22.04 | `ubuntu:22.04` | Uses `/lib/systemd/systemd` as entrypoint |
| RHEL/UBI 9   | `registry.access.redhat.com/ubi9/ubi:latest` | Uses `/sbin/init` as entrypoint |
| CentOS 7     | `centos:7` | Uses `/usr/sbin/init` as entrypoint |

## Security Considerations

These containers require the `--privileged` flag to function correctly with systemd. For production environments:

- Use these images primarily for testing or development scenarios
- Apply the principle of least privilege when possible
- Implement proper container isolation and network controls
- Keep base images updated with security patches
- Consider alternatives like Podman which can run systemd without privileged mode

## Distribution-Specific Usage

### Ubuntu 22.04

```bash
# Build
docker build -f Dockerfile.ubuntu -t systemd-ubuntu:22.04 .

# Run
docker run -d --name systemd-ubuntu --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro systemd-ubuntu:22.04
```

### Red Hat UBI 9

```bash
# Build
docker build -f Dockerfile.ubi -t systemd-ubi:9 .

# Run
docker run -d --name systemd-ubi --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro systemd-ubi:9
```

### CentOS 7

```bash
# Build
docker build -f Dockerfile.centos7 -t systemd-centos:7 .

# Run
docker run -d --name systemd-centos --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro systemd-centos:7
```

## Testing Systemd Services

You can verify systemd is working properly inside the container:

```bash
# Connect to a running container
docker exec -it systemd-container bash

# Check systemd status
systemctl status

# Install and enable a service
# For Ubuntu:
apt-get update && apt-get install -y nginx
systemctl enable --now nginx

# For RHEL/CentOS:
yum install -y nginx
systemctl enable --now nginx

# Verify service status
systemctl status nginx
```

## Additional Configuration Options

For enhanced security in production, consider these options:

```bash
# Run with limited capabilities instead of --privileged
docker run -d --name systemd-container \
  --cap-add SYS_ADMIN \
  --security-opt seccomp=unconfined \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  systemd-image:tag
```

## Extending Images for CI/CD

Example `.gitlab-ci.yml` for testing with these images:

```yaml
test:
  image: systemd-ubuntu:22.04
  variables:
    DOCKER_HOST: tcp://docker:2375
  services:
    - docker:dind
  script:
    - systemctl status
    - # your testing commands here
```

## License

This project is licensed under the GPL License - see the LICENSE file for details.