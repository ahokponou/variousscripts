# Various Scripts

Automation scripts for systems or networks.

## Scripts

1. Docker installation

This script perform docker installation on debian-based distros.

[linux-install-docker](./linux-install-docker)

Usage : 

```sh
curl https://raw.githubusercontent.com/ahokponou/variousscripts/main/linux-install-docker | bash
```
2. Setup vanilla PHP Project

For most of my project, I start from scratch and use docker for development environment. This script setup an empty PHP project to have a base to start.

[setup-php-project](./setup-php-project)

Usage: 

```sh
curl https://raw.githubusercontent.com/ahokponou/variousscripts/main/setup-php-project > /tmp/setup-php-project && chmod +x /tmp/setup-php-project && /tmp/setup-php-project
```