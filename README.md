ChopShop Dockerfile
==================

This repository contains a **Dockerfile** of [ChopShop](https://github.com/MITRECND/chopshop) for [Docker](://www.docker.io/)'s [trusted build](://index.docker.io/u/blacktop/chopshop/) published to the public [Docker Registry](://index.docker.io/).

### Dependencies
* [debian:wheezy](://index.docker.io/_/debian/)

### Image Sizes
| Image | Virtual Size | ChopShop 4| TOTAL     |
|:------:|:-----------:|:---------:|:---------:|
| debian | 85.19 MB    | 432.61 MB | 517.8 MB  |

### Image Tags
```bash
$ docker images

REPOSITORY          TAG                 IMAGE ID           VIRTUAL SIZE
blacktop/chopshop   latest              3c2c99892865       531.7 MB
blacktop/chopshop   4.1                 818430bd5aba       517.8 MB
```

### Installation

1. Install [Docker](://www.docker.io/).

2. Download [trusted build](://index.docker.io/u/blacktop/chopshop/) from public [Docker Registry](://index.docker.io/): `docker pull blacktop/chopshop`

#### Alternatively, build an image from Dockerfile
```bash
$ docker build -t blacktop/chopshop github.com/blacktop/docker-chopshop
```
### Usage
```bash
$ docker run -i -t -v /path/to/folder/pcap:/pcap:rw blacktop/chopshop -f my.pcap "http | http_extractor"
```
#### Output:
```bash

```

### To Run on OSX
 - Install [Homebrew](http://brew.sh)

```bash
$ brew install cask
$ brew cask install virtualbox
$ brew install docker
$ brew install boot2docker
$ curl http://static.dockerfiles.io/boot2docker-v1.2.0-virtualbox-guest-additions-v4.3.14.iso > ~/.boot2docker/boot2docker.iso
$ VBoxManage sharedfolder add boot2docker-vm -name home -hostpath /Users
$ boot2docker up
```
Add the following to your bash or zsh profile

```bash
alias chopshop='docker run -it --rm -v `pwd`:/pcap:rw blacktop/chopshop $@'
```
#### Usage

```bash
chopshop -f malware.pcap "(dns, icmp) | malware_detector"
```

### Todo
- [x] Install/Run ChopShop
- [ ] Start Daemon and watch folder with supervisord
- [ ] Have container take a URL as input and download/scan pcap
