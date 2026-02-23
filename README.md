# Collection of scripts

## Postinstall

This script allow me to automate some manual commands when I freshly install debian :)

Download the postinstall script and make it executable

```bash
wget -O postinstall.sh https://raw.githubusercontent.com/ahokponou/variousscripts/refs/heads/main/postinstall.sh && chmod +x postinstall.sh
```

Run the postinstall script as root

```bash
su - root -c "$HOME/postinstall.sh"
```

Install ohmyzsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="minimal"/' $HOME/.zshrc
```

## CA Helper Scripts

- [Be your own CA](./privateCA)
