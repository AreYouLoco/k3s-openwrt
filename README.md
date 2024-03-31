[![Build Packages](https://github.com/AreYouLoco/k3s-turris/actions/workflows/main.yml/badge.svg)](https://github.com/AreYouLoco/k3s-turris/actions/workflows/main.yml)

# k3s on Turris Router
Makefile to generate OpenWrt .ipkg packages from official k3s binaries for Turris Omnia router. But should work on any armhf device.

## Usage
This requires a custom kernel with support for various cgroup, namespaces, vxlan, cfs
scheduler etc. See here for my openwrt config: https://github.com/5pi-home/openwrt/blob/master/config

### Firewall
To allow the k3s' flannel bridge to access the internet, configure a interface
for cni0 in uci:

/etc/config/network:
```
config interface 'k8s'
	option proto 'none'
	option ifname 'cni0'
```

/etc/config/firewall
```
config zone
        option name 'k8s'
        option input 'ACCEPT'
        option output 'ACCEPT'
        option forward 'ACCEPT'
        option network 'k8s'
```

## Building
Run `make` to build the default version

## TODO
- Separate service files to k3s-master and k3s-agent
- Add uci globals with TOKEN of a master node for agent
- Work on service mounts
- Add gh-pages with ready-to-use repository
- Add builds for other supported architectures
