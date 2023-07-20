<h2>
 Usefull Commands
</h2>

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
$ groups [username]
```
