# Ubuntu Docker Image with systemd

[![Build](https://github.com/anubhavg-icpl/docker-ubuntu-systemd/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/anubhavg-icpl/docker-ubuntu-systemd/actions/workflows/build.yml) 
[![GPL License](https://img.shields.io/badge/license-GPL-blue.svg)](https://www.gnu.org/licenses/) 
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/anubhavg-icpl)
[![Docker Pulls](https://img.shields.io/docker/pulls/anubhavg-icpl/docker-ubuntu-systemd.svg)](https://hub.docker.com/r/anubhavg-icpl/docker-ubuntu-systemd)

Production-ready Ubuntu LTS Docker container with systemd support. Designed for testing infrastructure code with tools like `ansible` and `molecule`, as well as for applications requiring proper systemd initialization.

## Available Tags

| Tag | Ubuntu Version | Branch | Status |
|-----|----------------|--------|--------|
| `22.04`, `jammy`, `latest` | Ubuntu 22.04 LTS | main | Active Support |
| `20.04`, `focal` | Ubuntu 20.04 LTS | main | Active Support |
| `18.04`, `bionic` | Ubuntu 18.04 LTS | 18.04 | Maintenance Only |
| `16.04`, `xenial` | Ubuntu 16.04 LTS | 16.04 | End of Life |

## Quick Start

```bash
# Pull the image
docker pull anubhavg-icpl/docker-ubuntu-systemd:latest

# Run a container with systemd support
docker run --detach \
  --name ubuntu-systemd \
  --privileged \
  --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
  anubhavg-icpl/docker-ubuntu-systemd:latest
  
# Connect to the running container
docker exec -it ubuntu-systemd bash
```

## Security Considerations

This container requires the `--privileged` flag to function correctly with systemd. In production environments:

- Consider using this container primarily for testing or development
- Isolate containers running with privileged access on dedicated hosts
- Apply regular security updates to the base images
- Implement proper network security controls when exposing services
- Consider alternatives like Podman which can run systemd without privileged mode

## Usage with Ansible

```yaml
# Example molecule configuration (molecule.yml)
platforms:
  - name: ubuntu-systemd
    image: anubhavg-icpl/docker-ubuntu-systemd:22.04
    pre_build_image: true
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
```

## Building Custom Images

```bash
# Clone the repository
git clone https://github.com/anubhavg-icpl/docker-ubuntu-systemd.git
cd docker-ubuntu-systemd

# Build the image (Ubuntu 22.04)
docker build -t my-ubuntu-systemd:22.04 .

# Build for other versions (checkout the appropriate branch first)
git checkout 18.04
docker build -t my-ubuntu-systemd:18.04 .
```

## Container Management

```bash
# List running containers
docker ps

# Stop a container
docker stop ubuntu-systemd

# Remove a container
docker rm ubuntu-systemd

# Remove the image
docker image rm anubhavg-icpl/docker-ubuntu-systemd:latest
```

## Extending This Image

```dockerfile
FROM anubhavg-icpl/docker-ubuntu-systemd:22.04

# Add your packages
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable services
RUN systemctl enable nginx
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Author

Created in 2022 by Enio Carboni

## License

GNU GENERAL PUBLIC LICENSE (see [LICENSE](LICENSE) file)