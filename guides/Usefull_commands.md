<h2>
 Usefull Commands
</h2>

<h3>
 * Check Set Up
</h3>

Listing block devices: displays information about all block storage devices that are currently available on the system
```
$ lsblk
```
Show OS installed
```
$ uname -a
```
Check active programs
```
$ systemctl status [apparmor/ufw/ssh]
$ dpkg -l | grep [apache2/nginx]
```

<h3>
 * Manage users and groups
</h3>

Listing groups and users:
```
$ getent group
$ getent passwd
```
Create new group and new user:
```
$ groupadd [groupname]
$ adduser [username]
```
Check a group's users and a user's groups:
```
$ getent group [groupname]
$ groups [username]
```
Add user to a group:
```
$ usermod -a -G [groupname] [username]
```
Check and change hostname:
```
$ hostname
$ hostnamectl set-hostname [hostname]
OR
$ cat /etc/hostname
$ cat /etc/hosts
```

<h3>
 * Check Password and Sudo
</h3>

Check user's password change policy:
```
$ chage -l [username]
$ cat /etc/login.defs
```
Check password content policy:
```
$ cat /etc/pam.d/commom-password
```
Check sudo policies and logs:
```
$ nano /etc/sudoerds.d/<filename>
$ nano /var/log/sudo/sudo.log
```

<h3>
 * UFW
</h3>

Manage firewall:
```
$ ufw allow [port number]
$ ufw deny [port number]
$ ufw status numbered
$ ufw delete [rule number]
```

<h3>
 * SSH
</h3>

Test SSH:
```
$ nano /etc/ssh/sshd_config
$ ssh [username]@[ip address] -p 4242
```

<h3>
 * Cron
</h3>

Check scripts:
```
$ cat /root/scripts/monitoring.sh
$ cat /root/scripts/sleep.sh
```
Manage cron:
```
$ crontab -l
$ crontab -u root -e
$ systemctl disable cron
$ systemctl enable cron
$ systemctl restart cron
```
