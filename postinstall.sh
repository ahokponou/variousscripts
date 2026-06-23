#!/bin/bash

read -p "Please enter the user you want to add as sudoers: " USERNAME

LOG_FILE="/tmp/$(date '+%Y-%m-%d_%H-%M-%S')_postinstall.log"
touch "$LOG_FILE"

function log_and_echo() {
	echo -e "$(date '+%Y-%m-%d %H:%M') - $1" | tee -a "$LOG_FILE"
}

function log() {
	echo -e "$(date '+%Y-%m-%d %H:%M') - $1" >> "$LOG_FILE"
}

LOG_FILE="/tmp/$(date '+%Y-%m-%d_%H-%M-%S')_postinstall.log"

log_and_echo "postinstall starting..."

sed -i '/^deb cdrom/s/^/#/' /etc/apt/sources.list >> "$LOG_FILE" 2>&1
apt-get update >> "$LOG_FILE" 2>&1
apt-get install -y sudo >> "$LOG_FILE" 2>&1
usermod -aG sudo "$USERNAME" >> "$LOG_FILE" 2>&1
apt-get install -y curl wget git vim zsh >> "$LOG_FILE" 2>&1
cp /etc/vim/vimrc /etc/vim/vimrc.bk
wget -O /etc/vim/vimrc https://raw.githubusercontent.com/ahokponou/dotfiles/main/vimrc >> "$LOG_FILE" 2>&1

log_and_echo "postinstall [done]"
echo "Reboot now"
reboot now
