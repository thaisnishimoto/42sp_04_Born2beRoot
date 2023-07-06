# Born2beRoot
This project aims to introduce you to the wonderful world of virtualization.

## Create virtual machine
 - Download Oracle VM VirtualBox <br>
 - Download Debian current stable distribution (currently Debian version 12 - _bookworm_) <br>
 - Settings: change Network to Bridged Adapter so the VM is accessible from the network. It will assign an IP address to the VM.
<br>

## Partition
1. Create standard partition of 500M to /boot
2. Create logical partition of max without mountpoint
3. Encrypt logical partition created above
4. Create the following encrypted logical partitions
   - root: home directory for root user
   - swap: scratch space for OS
   - home: user home directories
   - var: contains files to which the system writes data
   - srv: data for services provided by the system
   - tmp: temporary files
   - var/log: contains log files
<br>

## LVM - Logical Volume Manager
More flexible way to manage storage, because allows to change storage on the fly, without having to unmount. It helps combine multiple physical storage devices, such as hard drives or SSDs, into a single logical volume that can be divided and resized as needed.
There is a device mapper that combines different physical volumes into one group. It allows to use one logical volume that accesses storage from multiple different disks.
3 layers:
1. Physical Volume represents a physical storage device
```
pvscan - searches for PVs
pvcreate - creates a PV
```
2. Group Volume - it's a pool that holds the storage capacity from the physical volumes, it`s created by combining one or more PVs together
```
vgscan - searches for VGs
vgcreate - creates a group from PVs
```
4. Logical Volume -
```
lvscan - searches for LVs
lvcreate - creates a logical volume in an speficied size from a VG
```

## AppArmor
AppArmor is a Linux application that confines programs according to a set of rules (_profiles_) that specify what files a given program can access, limiting its resources. The profle depends on the installation pathway of the program being executed. The Kernel checks with AppArmor to know if the program is authorized to do the what it attempting to do.
Unlike SELinux, the rules don´t depend on the user. Everyone finds the same set of rule when trying to execute a program. <br>
It already comes with Debian 12 by default. To check if it is already enabled:
```bash
$ aa-status
```

## Usefull commands

Listing block devices: displays information about all block storage devices that are currently available on the system
```
$ lsblk
```
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
$ group [username]
```

## Sudo (_Superuser do_) installation

It is good secutiry practice to disable root login over SSH to prevent unauthorized access. Another user with almost all superuser privileges should be created. <br>
You need to be logged as root user (_superuser_). Switch to root and provide the root user's password
```bash
$ su -
Password:
```
Install sudo 
```bash
$ apt install sudo
```
Add existing user to sudo group
```bash
$ usermod -aG sudo [usename]
```

## Sudo configuration

> 1. Authentication using sudo has to be limited to 3 attempts in the event of an incorrect password.<br>
> 2. A custom message of your choice has to be displayed if an error due to a wrong password occurs when using sudo.<br>
> 3. Each action using sudo has to be archived, both inputs and outputs. The log file has to be saved in the /var/log/sudo/ folder.<br>
> 4. The TTY mode has to be enabled for security reasons.<br>
> 5. For security reasons too, the paths that can be used by sudo must be restricted.<br>
> Example: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

The default security policy is sudoers, which is configured via the file /etc/sudoers <br>
Sudo will also read and parse any files in the /etc/sudoers.d directory. The contents of /etc/sudoers.d survive system upgrades, so it's preferrable to create a file there than to modify /etc/sudoers <br>
A rule at the bottom will override a conflicting rule above it. <br>
The visudo command opens a text editor like normal, but it validates the syntax of the file upon saving. This prevents configuration errors from blocking sudo operations.
```bash
$ visudo /etc/sudoers.d/<filename>
```
Enabling TTY mode ensures that the command executed with sudo requires an interactive terminal session. This means that the command will prompt for input, display output, and potentially request user authentication. <br>
```
$ mkdir /var/log/sudo
```
In the file created, write:
```
Defaults        passwd_tries=3
Defaults        badpass_message="custom-message"
Defaults        logfile=/var/log/sudo/sudo.log
Defaults        requiretty
Defaults        secure_path=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
```
You can replay the sudo session in real-time, based on the :
When a command is run via sudo with log_output enabled a TSID=ID string is logged to the sudo log file.
```
sudoreplay [Terminal Session ID]
```
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

Apply rules to existing users and root:
```bash
$ chage -M 30 <username/root>
$ chage -m 2 <username/root>
$ chage -W 7 <username/root>
```

> 4. Your password must be at least 10 characters long. It must contain an uppercase letter and a number. Also, it must not contain more than 3 consecutive identical characters.
> 5. The password must not include the name of the user.
> 6. The following rule does not apply to the root password **by default**: The password must have at least 7 characters that are not part of the former password.
> 7. Of course, your root password has to comply with this policy

The default pam_deny.so module is designed to deny any password change or creation request, effectively preventing any modifications to the password. To implement a password policy, install libpam-cracklib - PAM (Pluggable Authentication Module) that tests passwords to make sure they are not too weak during password change
```bash
$ apt-get install libpam-pwquality
```
Go to file common-password
```bash
$ nano /etc/pam.d/common-password
```
Add to line - "password requisite pam_pwquality.so": <br> 
minlen=10 <br>
ucredit=-1 <br>
dcredit=-1 <br>
maxrepeat=3 <br>
reject_username <br>
difok=7 <br>
enforce_for_root <br>

> Afterwards, you will have to change all the passwords of the accounts present on the VM, including root, according to the new policy
```bash
$ passwd <username>
```


## UFW - Uncomplicated Firewall
UFW controlls network connections to protect the system. UFW default policy is to deny incoming traffic and allow outgoing traffic.
```
ufw status
apt install ufw
ufw enable
```

## SSH - Secure Shell
SSH is a protocol that creates a secure conection between:
 - Client: local computer
 - Server: computer we want to control

We need to install an ssh server on the remote server. OpenSSH is a connectivity tool for remote sign-in that uses the SSH protocol. It encrypts all traffic between client and server to eliminate attacks.
```
apt install openssh-server
```
> A SSH service will be running on port 4242 only. Port 22 is the SSH default.  <br>
> Disable root login via SSH  <br>

Edit the sshd_config file on remote server (server-side configuration file)
```
nano  /etc/ssh/sshd_config
```
Change following lines:
   - Port 4242
   - PermitRootLogin no <br>

To delete a port access
```
ufw status numbered
ufw delete [rule number]
```
You typically need to restart the SSH server (sshd) for the changes to take effect
```
systemctl restart ssh
```
To test the SSH
```
ip a (to see server IP address)
```
On local machine
```
ssh username@ip_address -p 4242
password:
```
Copy files from and to server (_secure copy_)
You might need to change the file permissions (chmod command), copy it to /tmp file and change the permissions on the temporary file only
```
systemctl restart networking (changes the IP if necessary)
to download - from local: scp -P 4242 username@ip_address:[file path on server] [destination path (current dir:.)]
to upload - from local: scp -P 4242 [file path] username@ip_address:[destination path (user home:~)]
```

##Monitoring Script
> The architecture of your operating system and its kernel version.
```
uname -a (Displays all information specified with the -m, -n, -r, -s, and -v flags.)
```
Display all information about the operating system, Kernel version, and hardware: <br>
Linux | tmina-ni | 6.1.0-9-amd64 #1 | SMP PREEMPT_DYNAMIC Debian 6.1.27-1 (2023-05-08) | x86_64 | GNU/Linux <br>
[Kernel name] [hostname] [Kernel version] [Kernel compile time] [Kernel architecture] [OS name]

> The number of physical processors.
> The number of virtual processors.
> The current available RAM on your server and its utilization rate as a percentage.
> The current available memory on your server and its utilization rate as a percentage.
> The current utilization rate of your processors as a percentage.
> The date and time of the last reboot.
> Whether LVM is active or not.
> The number of active connections.
> The number of users using the server.
> The IPv4 address of your server and its MAC (Media Access Control) address.
> The number of commands executed with the sudo program.The command:



can interrupt a running task and allocate the CPU to a higher-priority task that needs to be executed

O comando wall (_write all_) é utilizado para transmitir uma mensagem para todas as pessoas conectadas aos terminais do Linux.


##Cron
> At server startup, the script will display some information (listed below) on all terminals every 10 minutes
A cron job is a Linux command used for scheduling tasks to be executed sometime in the future. A cron file is a simple text file that contains commands to run periodically at a specific time. The default system cron table or crontab configuration file is /etc/crontab.

The crontab syntax consists of five fields with the following possible values:
* * * * * bash_file
Minute. The minute of the hour the command will run on, ranging from 0-59.
Hour. The hour the command will run at, ranging from 0-23 in the 24-hour notation.
Day of the month. The day of the month the user wants the command to run on, ranging from 1-31.
Month. The month that the user wants the command to run in, ranging from 1-12, thus representing January-December.
Day of the week. The day of the week for a command to run on, ranging from 0-6, representing Sunday-Saturday. In some systems, the value 7 represents Sunday.
Don’t leave any of the fields blank.
From here, monitoring.sh will be executed every 10th minute. To make it execute every ten minutes from system startup, we can create a sleep.sh script that calculates the delay between server startup time and the tenth minute of the hour, then add it to the cron job to apply the delay.

uptime -s
