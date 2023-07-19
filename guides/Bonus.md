<h1 align="center"> Bonus
</h1>
<p align="center"><i>"In the bonus part, we will set up a functional WordPress website and a service of our choice."</i></p>  

---

<h2 align=center> Index </h2>
<h3 align="center"><b>
	<a href="#Wordpress">Wordpress</a>
	<span> • </span>
	<a href="#Lighttpd">Lighttpd</a>
	<span> • </span>
	<a href="#MariaDB">MariaDB</a>
	<span> • </span>
	<a href="#PHP">PHP</a>
	<span> • </span>
	<a href="#Samba">Samba</a>
</b></h3>

---

For the WordPress website, we will be setting a LAMP stack. It is a bundle of four different software technologies that developers use to build websites and web applications. LAMP is an acronym for the operating system, Linux; the web server, Apache; the database server, MySQL; and the programming language, PHP. However, LAMP now refers to a generic software suite model and its components are largely interchangeable. We will be using Linux, Lighttpd, MariaDB and PHP. 

## Lighttpd
<br />
Lighttpd is an open-source, secure, fast, compliant, and very flexible web server. <br>
A web server is a piece of software in a machine that holds a website raw material. It is the front-end server for handling HTTP requests. Lighttpd listens for incoming requests on a specified port and forwards them to the appropriate backend processes. It serves ip web pages <br> 
```
apt install lighttpd
systemctl status lighttpd
```

A web browser uses port 80 (http URL) or port 443 (https URL) by default. Allow HTTP traffic in you Firewall. <br>
```
ufw allow 80
ufw status
```

To test Lighttpd, go to host machine browser and type in your IP address. You should see a Lighttpd "placeholder page".

## MariaDB
<br />

MariaDB is an an open-source relational database management system that serves as backend database for WordPress, with higher performance than MySQL. SQL is the programmig language used to create and manipulate a relational database. <br>
MariaDB is used by Wordpress to store and organize website's data. The classic task of a database management system is to map, manage, store and change data in tables. <br>
```
apt install mariadb-server
systemctl status mariadb
```

To enhance the security of your MariaDB installation, run the following script:
```
mysql_secure_installation
```
- Set a root password: provides an additional layer of protection.
- Remove anonymous users: only authenticated users can access the databases.
- Disallow remote root login: prevents potential unauthorized access from external sources.
- Remove test database: eliminates any potential security vulnerabilities associated with the test database (which is accessible to anonymous users).
- Reload privilege tables: applies the privilege changes effectively.
<br>

Access MariaDB:
```
mariadb
```

Create database for wordpress and user to access it:
```
CREATE DATABASE wordpress;
SHOW DATABASES;
CREATE USER '_username_'@'localhost' IDENTIFIED BY '_password_';
GRANT ALL ON wordpress.* TO 'admin'@'localhost'; (gives access to MariaDB user to all wordpress tables)
FLUSH PRIVILEGES;
exit;
```

Access MariaDB with new user:
```
mysql -u username -p
Password:
```

Check user logged and it's databases:
```
SELECT CURRENT_USER;
SHOW DATABASES;
```


## PHP
<br />

PHP is a widely used open source, server-side preprocessor (all processing happens on the web server before anything is presented do the visitor's web browser). It is a scripting language used mainly in web development to create dynamic websites and applications. PHP talks to the database and loads the content on a website. < br>

PHP 8.2 (current stable) is packaged in Debian 12, to go for the system’s default PHP versions, then you just need to run:
```
apt install php php-common
php -v
```
php-common is considered a fundamental package for PHP installations and is typically installed by default alongside PHP. It provides common files, settings, and resources that are essential for PHP to function properly <br>

To get all [`extensions needed`](https://make.wordpress.org/hosting/handbook/server-environment/) for wordpress (a few should be already bundled in the PHP 8.2, but still needed to be installed):
```
apt install php-cgi php-mysqli php-cli (bundled) php-curl php-dom php-exif php-imagick php-mbstring php-xml php-zip
```
A few additional PHP extensions, you enhance your PHP environment and provide additional capabilities:
```
apt install php-gd php-recode php-tidyphp-xmlrpc php-fpm
```
Remember to restart your web server after installing the PHP extensions for the changes to take effect.
```
lighty-enable-mod fastcgi
lighty-enable-mod fastcgi-php
lighty-enable-mod php-mysqli
systemctl restart lighttpd
```
Apache may be installed due to PHP dependencies. Uninstall to avoid conflicts with lighttpd:
```
dpkg -l | grep apache2
apt purge apache2 (removes package and associated configuration files)
apt autoremove (removes dependencies not being used)
```

## Wordpress
<br />

WordPress is a tool used for the management and creation of websites that is completely open-source. Some of the features of WordPress include publishing tools, user management, media management, flexibility in the creation of your own website, optimized for SEO, simplicity, and easy installation and upgrades.

Now you'll download a copy of the WordPress source files, connect them to your database, and get started with a brand new WordPress site.
```
apt install wget (to download from the internet)
wget http://wordpress.org/latest.tar.gz (downloads last wordpress version)
tar -xzvf latest.tar.gz (unzip)
mv wordpress/* /var/www/html/ (move wp source files)
rm -rf latest.tar.gz wordpress (delete zip file)
```

Write the MariaDB database information in the regular wp config file:
```
sudo mv wp-config-sample.php wp-config.php
sudo nano wp-config.php

<?php
/* ... */
/** The name of the database for WordPress */
define( 'DB_NAME', '_wordpress_' );

/** Database username */
define( 'DB_USER', '_admin_' );

/** Database password */
define( 'DB_PASSWORD', '_password_' );

/** Database host */
define( 'DB_HOST', '_localhost_' );
```

Change permissions of WordPress directory to grant rights to web server and restart lighttpd:
```
sudo chmod -R 755 /var/www/html/
sudo chown -R (recursivo) www-data:www-data www/ /var/www/html/
sudo systemctl restart lighttpd
```

To confirm the execution of PHP, type http://IP adress/ to your browser and the configuration menu for Wordpress should appear.

If needed, check for lighttpd errors:
```
sudo tail -F /var/log/lighttpd/error.log
```
If the host IP changes, [`change the IP in the database`](https://www.gloomycorner.com/what-to-do-if-your-wordpress-host-ip-changed/)

## LAMP overall interaction
  
1. Visitor accesses your WordPress site by entering the URL in their browser.
2. Lighttpd acts as the front-end web server, receiving the request and handling static file requests like HTML, CSS, JavaScript, and image files. It directly serves these static files without involving PHP or the database.
3. When a PHP file, such as a WordPress page or post, is requested, Lighttpd forwards the PHP request to the PHP FastCGI process. FastCGI is a protocol that allows the web server to communicate with the PHP interpreter efficiently.
4. PHP executes the WordPress PHP code, interacts with the MariaDB database to retrieve or modify data, and generates dynamic content based on the requested page or post. The generated content is then returned back to Lighttpd.
5. Lighttpd receives the dynamic content from PHP and presents the resulting HTML markup to the visitor's browser. This HTML includes the processed data and any additional static files needed to render the page properly.
6. The visitor's browser renders the HTML received from the server, displaying the final web page. The visitor only sees the processed code delivered to the browser, they are not exposed to the underlying PHP code that powers WordPress.


## Samba
<br />

> Set up a service of your choice that you think is useful

Samba is a file sharing service that can be used to share files and folders over a network
```
sudo apt install samba
sudo systemctl status smbd
```

We will create a public (no password) directory that will be shared over the network: 
```
sudo mkdir /Public_Files (root dir)
sudo chown -R (recursive) nobody:nogroup /Public_Files
sudo chmode -R 777 /Public_Files
```

Change Samba settings to make the directory shareable by adding lines at the end of the config file:
```
sudo nano /etc/samba/smb.config

[directory_name]
path = /Public_Files
guest ok = yes (won't ask for password)
read only = no (who access the folder will be able to execute and edit)
force user = nobody (user with least amount of privileges)

sudo systemctl restart smbd
```

Configure your firewall
```
udo ufw allow samba
```

To check shared files:
```
smbstatus --shares
```

To test samba:
1. Access the host default file manager and choose the + Other Locations option.
2. Type the following into the "Enter server address" box and select Connect:
```
smb://ip-address/Public_Files
```
3. This adds the sharing directory to the host shares location.
