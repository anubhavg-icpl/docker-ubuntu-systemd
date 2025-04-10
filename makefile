.PHONY: all build-all push-all build-ubuntu build-debian build-redhat build-rocky build-almalinux build-fedora build-opensuse build-alpine build-archlinux

REGISTRY := mranv
IMAGE_NAME := systemd-images

all: build-all

# Build all images
build-all: build-ubuntu build-debian build-redhat build-rocky build-almalinux build-fedora build-opensuse build-alpine build-archlinux

# Push all images to registry
push-all:
	docker push $(REGISTRY)/$(IMAGE_NAME):latest
	docker push $(REGISTRY)/$(IMAGE_NAME):ubuntu-22.04
	docker push $(REGISTRY)/$(IMAGE_NAME):ubuntu-jammy
	docker push $(REGISTRY)/$(IMAGE_NAME):debian-12
	docker push $(REGISTRY)/$(IMAGE_NAME):debian-bookworm
	docker push $(REGISTRY)/$(IMAGE_NAME):redhat-ubi9
	docker push $(REGISTRY)/$(IMAGE_NAME):ubi9
	docker push $(REGISTRY)/$(IMAGE_NAME):redhat-centos7
	docker push $(REGISTRY)/$(IMAGE_NAME):centos7
	docker push $(REGISTRY)/$(IMAGE_NAME):rocky-el9
	docker push $(REGISTRY)/$(IMAGE_NAME):rocky9
	docker push $(REGISTRY)/$(IMAGE_NAME):almalinux-el9
	docker push $(REGISTRY)/$(IMAGE_NAME):alma9
	docker push $(REGISTRY)/$(IMAGE_NAME):fedora-39
	docker push $(REGISTRY)/$(IMAGE_NAME):fedora39
	docker push $(REGISTRY)/$(IMAGE_NAME):opensuse-leap15
	docker push $(REGISTRY)/$(IMAGE_NAME):leap15
	docker push $(REGISTRY)/$(IMAGE_NAME):alpine-3.19
	docker push $(REGISTRY)/$(IMAGE_NAME):alpine
	docker push $(REGISTRY)/$(IMAGE_NAME):archlinux-latest
	docker push $(REGISTRY)/$(IMAGE_NAME):arch

# Build Ubuntu image
build-ubuntu:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):ubuntu-22.04 -t $(REGISTRY)/$(IMAGE_NAME):ubuntu-jammy -t $(REGISTRY)/$(IMAGE_NAME):latest ./ubuntu/22.04

# Build Debian image
build-debian:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):debian-12 -t $(REGISTRY)/$(IMAGE_NAME):debian-bookworm ./debian/12

# Build Red Hat images
build-redhat:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):redhat-ubi9 -t $(REGISTRY)/$(IMAGE_NAME):ubi9 ./redhat/ubi9
	docker build -t $(REGISTRY)/$(IMAGE_NAME):redhat-centos7 -t $(REGISTRY)/$(IMAGE_NAME):centos7 ./redhat/centos7

# Build Rocky Linux image
build-rocky:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):rocky-el9 -t $(REGISTRY)/$(IMAGE_NAME):rocky9 ./rocky/el9

# Build AlmaLinux image
build-almalinux:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):almalinux-el9 -t $(REGISTRY)/$(IMAGE_NAME):alma9 ./almalinux/el9

# Build Fedora image
build-fedora:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):fedora-39 -t $(REGISTRY)/$(IMAGE_NAME):fedora39 ./fedora/39

# Build openSUSE image
build-opensuse:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):opensuse-leap15 -t $(REGISTRY)/$(IMAGE_NAME):leap15 ./opensuse/leap15

# Build Alpine image
build-alpine:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):alpine-3.19 -t $(REGISTRY)/$(IMAGE_NAME):alpine ./alpine/3.19

# Build Arch Linux image
build-archlinux:
	docker build -t $(REGISTRY)/$(IMAGE_NAME):archlinux-latest -t $(REGISTRY)/$(IMAGE_NAME):arch ./archlinux/latest

# Test a specific image (usage: make test-image IMAGE=ubuntu-22.04)
test-image:
	docker run --rm -it --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro $(REGISTRY)/$(IMAGE_NAME):$(IMAGE) systemctl status

# Clean up all local images
clean:
	docker rmi $$(docker images $(REGISTRY)/$(IMAGE_NAME) -q) || true