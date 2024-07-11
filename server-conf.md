# Server configuration

```bash
su -
sed -i '/^deb cdrom/s/^/#/' /etc/apt/sources.list
apt update && apt install -y curl wget git vim zsh sudo
cp /etc/vim/vimrc /etc/vim/vimrc.bk && curl https://raw.githubusercontent.com/ahokponou/dotfiles/main/vimrc > /etc/vim/vimrc
```

Execute the command below by replace {username} with the actual username of the user who will use sudo to temporarily have super user privileges

```bash
usermod -aG sudo {username}
```

> Note: Logout and log in back to the change takes effect.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="minimal"/' $HOME/.zshrc
```