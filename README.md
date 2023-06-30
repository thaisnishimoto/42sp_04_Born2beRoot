# Born2beRoot
This project aims to introduce you to the wonderful world of virtualization.

## Create virtual machine
Download Oracle VM VirtualBox <br>
Download Debian current stable distribution (currently Debian version 12 - _bookworm_)

## AppArmor
AppArmor is a Linux application that confines programs according to a set of rules (_profiles_) that specify what files a given program can access. I already comes with Debian 12 by default.
Check if it is already enabled
```bash
$ aa-status
```

## Usefull commands

Listing block devices: displays information about all block storage devices that are currently available on the system
```bash
$ lsblk
```

## Sudo (_Superuser do_) installation
You need to be logged as root user (_superuser_). Switch to root and provide the root user's password
```bash
$ su
Password:
```
Install sudo 
```bash
$ apt-get install sudo
```
Add user to sudo group
```bash
$ adduser <USER> sudo
```
*Why use sudo: it is good secutiry practice to disable root login over SSH to prevent unauthorized access. Another user with almost all superuser privileges should be created.

## Password policies

> 1. Your password has to expire every 30 days.
> 2. The minimum number of days allowed before the modification of a password will be set to 2.
> 3. The user has to receive a warning message 7 days before their password expires.

Go to file login.defs
```bash
nano /etc/login.defs
```
Change: PASS_MAX_DAYS 30 <br>
PASS_MIN_DAYS 2 <br>
PASS_WARN_AGE 7

> 4. Your password must be at least 10 characters long. 
> 5. It must contain an uppercase letter and a number. Also, it must not contain more than 3 consecutive identical characters.

Go to file common-password
```bash
nano /etc/pam.d/common-password
```
Add to line - password requisite: 


> 6. The password must not include the name of the user.

Install libpam-cracklib - PAM module that tests passwords to make sure they are not too weak during password change
```bash
apt-get install libpam-cracklib
```

> 7. The following rule does not apply to the root password **by default**: The password must have at least 7 characters that are not part of the former password.



## Sudo configuration


## Disable root login via SSH
