# Postinstall

This script allow me to automate some manual commands when I freshly install debian :)

Run the postinstall script with sudo

```bash
sudo sh -c "curl <URL> | bash"
```

Run the postinstall script as root

```bash
su - root -c "curl <URL> | bash"
```

Install ohmyzsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="minimal"/' $HOME/.zshrc
```

