#!/bin/bash

# PHP Project setup script.
#
# This script is intended as a convenient way to configure a simple
# php project with Dockerfile and docker-compose.yml.
#
# Author: Helmut

function createDockerfile(){
    cat << EOF > "$1/Dockerfile" 
FROM php:8.2-apache-bookworm

COPY ./ /var/www/html/
COPY ./env/000-default.conf /etc/apache2/sites-available/000-default.conf

# Install package
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates wget vim openssl

# Enable necessary Apache modules
RUN a2enmod ssl
RUN a2enmod rewrite

# Install composer
RUN curl -s -S https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Generate a self-signed SSL certificate (for development purposes)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache2.key -out /etc/ssl/certs/apache2.crt -subj \"/C=BJ/ST=Littoral/L=Cotonou/O=Localhost/CN=localhost\"

# Default sites conf files
RUN rm /etc/apache2/sites-available/default-ssl.conf

# Expose ports
EXPOSE 80
EXPOSE 443

CMD [\"apache2-foreground\"]
EOF;
}

function createDockerCompose(){
    cat << EOF > "$1/docker-compose.yml" 
version: '3'\n\nservices:\n  app:\n    build:\n      context: .\n      dockerfile: Dockerfile\n    container_name: app\n    hostname: app\n    volumes:\n      - ./:/var/www/html\n    networks:\n      - net-app\n    ports:\n    - 8880:80\n    - 8443:443\n\nnetworks:\n  net-app:\n    name: net-app
EOF;
}

function createApacheConfFile(){
    cat << EOF > "$1/000-default.conf"
<VirtualHost *:80>
    ServerName localhost
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/public
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    
    <Directory /var/www/html/public>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

<VirtualHost *:443>
    ServerName localhost
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/public
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    
    <Directory /var/www/html/public>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    SSLEngine on
    SSLCertificateFile      /etc/ssl/certs/apache2.crt
    SSLCertificateKeyFile   /etc/ssl/private/apache2.key
    
    <FilesMatch \"\.(?:cgi|shtml|phtml|php)$\">
        SSLOptions +StdEnvVars
    </FilesMatch>
    <Directory /usr/lib/cgi-bin>
        SSLOptions +StdEnvVars
    </Directory>
</VirtualHost>
EOF;
}

function initDocker(){
    if [[ $# -ne 1 ]]; then
        echo -e $0 . " need one argument to work.";
        exit 1;
    fi
    if [[ ! -d $1 ]]; then
        echo -e "Folder ${1} does not exist.";
        exit 1;
    fi
    createDockerfile $1;
    createDockerCompose $1;

    mkdir -p $1/env;
    createApacheConfFile $1/env;
}

function initProject(){
    if [[ $# -ne 1 ]]; then
        echo -e $0 . " need one argument to work.";
        exit 1;
    fi
    if [[ ! -d $1 ]]; then
        echo -e "Folder ${1} does not exist.";
        exit 1;
    fi
    mkdir -p $1/app $1/public;
    echo -e "<?php\necho \"Your project start here. :)\";" > $1/app/app.php;
    echo -e "<?php\nrequire(dirname(__DIR__) . \"/app/app.php\");" > $1/public/index.php;
    echo -e "User-Agent: *\nDisallow: /cgi-bin/\nDisallow: /assets/" > $1/public/robots.txt;
    echo -e "Options +FollowSymlinks\n\nRewriteEngine On\n\n# # Redirect www to non-www\n# RewriteCond %{HTTP_HOST} ^www\.example\.com [NC]\n# RewriteRule ^(.*)$ http://example.com/$1 [L,R=301]\n\n# Redirect http to https\nRewriteCond %{HTTPS} off\nRewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]\n\n# Rewrite URLs to index.php\nRewriteCond %{REQUEST_FILENAME} !-f\nRewriteCond %{REQUEST_FILENAME} !-d\nRewriteRule ^(.*) index.php [L]" > $1/public/.htaccess;
}

function main(){
    read -p "Project name (Example: myapp): " projectName;
    if [[ ! -d $HOME/dev/ ]] || [[ ! -d $HOME/Dev/ ]] ; then
        mkdir ${HOME}/Dev;
    fi
    projectDir="${HOME}/Dev/${projectName}";
    echo -e "\n$(date '+ %Y/%m/%d %H:%M:%S') | Setup project [Started]";
    echo -e "\t--- Create project folder [Done]";
    mkdir -p $projectDir;
    echo -e "\t--- Setup docker for the project [Done]";
    initDocker $projectDir;
    echo -e "\t--- Setup project directories and files [Done]";
    initProject $projectDir;
    echo -e "$(date '+ %Y/%m/%d %H:%M:%S') | Setup project [Ended]\n";
}

main;
