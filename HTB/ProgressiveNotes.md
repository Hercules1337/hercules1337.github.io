# Notes as I go through "Starting Point"

## Machines
## 1. Meow
- Telnet is a network protocol and command-line tool that allows you to connect to remote machines over TCP port 23. It gives you a text-based shell or interface, assuming the service is running and doesn’t require strict authentication. SSH has replaced Telnet
- Nmap is used to discover open ports, services and more.
- nmap command used for easy machine --> _$~nmap -sV -O -Pn -n -p- -T5 TargetIP_
  - -sV: Service version detection
  - -O: Operating System detection
  - -Pn: Skip host discovery (assume host is up — useful for HTB)
  - -n: Don’t resolve DNS (faster)
  - -p-: Scans all TCP ports
  - -T5: Fastest timing (safe for most HTB machines)
  
- Telnet can be logged in with "root" without a password just with this command below
  - _$~telnet IP_
  - Then login with "root", no password needed
  - List directory with _$~ls_ and then grab flag with _$~cat_ --> _$~cat flag.txt_

* * *

## 2. Fawn
- FTP (File Transfer Protocol) is a standard network protocol used to transfer files between a client and a server.
- Common FTP Commands (interactive shell):
  - -?: help menu
  - After connecting (ftp _TargetIP_), you can use:
  - ls: List files
  - get filename: Download file
  - put filename: Upload file
  - cd dir: Change directory
  - exit / bye: Disconnect
 
- Authentication with FTP
  - Standard user+pass
  - name: anonymous
  - pass: blank or email

- Use "~sudo ftp TargetIP" if downloads are not working

* * *

## 3. Dancing
- SMB (Server Message Block) is a network file sharing protocol that allows systems (especially Windows) to:
  - Share files
  - Access printers
  - Communicate between nodes (file transfers, authentication, etc.)

- Common Ports
  - 445 (Common, modern SMB)
  - 139 (older NetBIOS session)
 
- Command to login to smb to list shares (using _smbclient_)
  - $~smbclient -L //_TargetIP_ -N
    - -L: List shares
    - -N: No password (anon login)
  - Connecting to a share
    - $~smbclient //_TargetIP_/_share_name_ -N
    - **Make sure _-L_ isn't in your command to connect to a share**
   
- Common smbclient commands
  - ls: List files
  - cd dir: Change directory
  - get file: Download a file (e.g. get flag.txt)
  - pwd: Show current directory
  - exit: Quit the session

* * *

## 4. Redeemer
- Redis is a super-fast, in-memory key-value database — it's like a giant dictionary stored in RAM that apps use to quickly save and look up small bits of data.
  - Think: key → value storage, but lightning fast and temporary (unless configured for persistence).
  - Commonly used for: caching, session storage, real-time data.
 
- Common commands for redis

| Command                 | Action                          |
|:------------------------|:--------------------------------|
| `SET key value`         | Set a key with a value          |
| `GET key`               | Get the value of a key          |
| `DEL key`               | Delete a key                    |
| `EXPIRE key seconds`    | Set a timeout for a key         |
| `HSET hash field value` | Set a field in a hash           |
| `HGET hash field`       | Get a field from a hash         |
| `KEYS pattern`          | List all keys matching pattern  |
| `FLUSHALL`              | Remove all keys in the database |

- Loggin into Redis
  - $~redis-cli -h _TargetIP_ -p _port_
  - If a password is required
  - $~redis-cli -h _TargetIP_ -p _port_ -a _password_
 
- Navigating Redis
  - KEYS *: shows all keys
  - EXISTS key_name: check if key exists
  - TYPE key_name: checks type of a key
  - GET key_name: get value of a key
 
- Extracting data: To extract data from Redis, it depends on the type of data stored. Here are some common scenarios:
  - GET flag: for a string
  - LRANGE list_name 0 -1: for a list
  - HGETALL hash_name: for a hash
  - SMEMBERS set_name: for a set
 
_$~redis-cli -h TargetIP --> KEYS * --> GET flag_

* * *

## 5. Explosion
- Remote Desktop Protocol (RDP) allows remote graphical access to Windows systems. It's mostly used by administrators and help desks to control systems across a network.

#### Tools to Access RDP

| Tool       | Platform    | Description                         |
|:-----------|:------------|:------------------------------------|
| `mstsc`    | Windows     | Built-in GUI RDP client             |
| `xfreerdp` | Linux/macOS | Modern, feature-rich RDP client     |
| `rdesktop` | Linux       | Older RDP client                    |
| `Remmina`  | Linux (GUI) | RDP + VNC GUI client for Linux      |

#### Common Commands & Switches
- xfreerdp (most modern and flexible)

| Switch              | Description              |
| :------------------ | :----------------------- |
| `/v:IP`             | Target RDP IP address    |
| `/u:username`       | Username                 |
| `/p:password`       | Password                 |
| `/cert:ignore`      | Ignore SSL cert warnings |
| `/f`                | Fullscreen mode          |
| `/clipboard`        | Enable clipboard sharing |
| `/drive:share,path` | Share local drive to RDP |

- Logging in to RDP (Linux): REQUIRES CREDENTIALS (/u:username) BUT DOES NOT REQUIRE PASSWORD
  - $~xfreerdp /u:_username_ /p:password /v:_TargetIP_ /cert:ignore
 
_$~xfreerdp /v:10.129.1.13 /u:administrator /cert:ignore --> enter blank password --> successfully entered RDP session_

* * *

## 6. Preignition
- NGINX is a high-performance, open-source web server and reverse proxy server. It's widely used to serve websites, APIs, and static files.
  - NGINX delivers web pages to your browser and can also forward requests to backend services (like APIs or databases).
- Directory busting is a method used during web reconnaissance to discover hidden directories and files on a web server (NGINX) by brute-forcing common paths using a wordlist.
**Tools for Directory Busting**

| Tool        | Description                           |
| :---------- | :------------------------------------ |
| `gobuster`  | Fast and modern directory bruteforcer |
| `ffuf`      | Flexible Fuzzing Tool                 |
| `dirbuster` | GUI-based tool from OWASP             |
| `dirb`      | Lightweight command-line brute tool   |

**Common Gobuster Switches**  

| Switch | Description                                             | Example Value                          |
| :----- | :------------------------------------------------------ | :------------------------------------- |
| `dir`  | **Answer:** Tells Gobuster to perform directory busting | *(no value needed)*                    |
| `-w`   | Wordlist path                                           | `/usr/share/wordlists/dirb/common.txt` |
| `-u`   | Target URL                                              | `http://10.10.10.10/`                  |
| `-x`   | **Answer:** Add file extensions to check                | `php`                                  |
| `-t`   | Number of concurrent threads                            | `50`                                   |
| `-o`   | Output file for results                                 | `found_dirs.txt`                       |
| `-k`   | Ignore SSL certificate warnings                         | *(no value needed)*                    |
| `-s`   | Expected HTTP status codes                              | `200,204,301,302,403`                  |
| `-e`   | Expanded output (shows full URL)                        | *(no value needed)*                    |

**Common Wordlists (Full Paths on Kali/Parrot)**

| Wordlist                        | Path                                                                    | Purpose                    |
| :------------------------------ | :---------------------------------------------------------------------- | :------------------------- |
| `common.txt`                    | `/usr/share/wordlists/dirb/common.txt`                                  | Basic wordlist             |
| `big.txt`                       | `/usr/share/wordlists/dirb/big.txt`                                     | Larger brute-force list    |
| `directory-list-2.3-medium.txt` | `/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt`          | Popular medium list        |
| `raft-medium-directories.txt`   | `/usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt` | Structured wordlist        |
| `common.txt (SecLists)`         | `/usr/share/seclists/Discovery/Web-Content/common.txt`                  | Great general-purpose list |

- If you're missing any of these, run: _$~sudo apt install seclists_

- Full gobuster command
  - _$~gobuster dir -u http://IP_ADDRESS/ -w /usr/share/wordlists/dirb/common.txt -x php -t 50_
- Example results
  - /admin.php 
  - /index.php

- Check admin page for default credentials -->  user:admin pass:admin

* * *

## 7. Mongod
- MongoDB is a NoSQL document-based database. Instead of storing data in rows and columns (like SQL), it uses JSON-like documents. It's used for flexible, scalable data storage.
  - MongoDB is a database that stores data in key-value pairs inside collections, not tables.
**Common MongoDB Shell Commands**

| Command                   | Description                      | Example Value       |
| :------------------------ | :------------------------------- | :------------------ |
| `show dbs`                | List all databases               | –                   |
| `use`                     | Switch to a database             | `use mydatabase`    |
| `show collections`        | List collections in current DB   | –                   |
| `db`                      | Show current database            | –                   |
| `db.collection.find()`    | View all documents in collection | `db.users.find()`   |
| `db.collection.count()`   | Count documents in a collection  | `db.flags.count()`  |
| `db.collection.findOne()` | Show one document                | `db.flag.findOne()` |
| `db.collection.drop()`    | Delete collection (be careful)   | –                   |
| `exit`                    | Leave the shell                  | –                   |

**How to Login, Navigate, and Extract Data**
1. _$~ mongosh IP:port_ --> If you get version mismatch errors, try using _mongo_ if available or downgrade _mongosh_.
2.  _> show dbs_
3.  _> use database_name_
4.  _>show collections_
5.  _>db.collection_name.find().pretty()_

### Note
> When attempting this machine, the current installed version of mongosh was not compatible with the MondoDB server. There was no workaround with the HTB Pwnbox. I could not downgrade mongosh, nor could I install mongo. Regardless, I understood the machine and completed it by following the write-up. Thank you.

* * *

## 8. Synced
- rsync is a fast and versatile file copying tool used to synchronize files and directories between two locations over a network or locally. It uses a delta-transfer algorithm to send only the changed parts of files.
  - rsync helps you copy files and folders between computers, or just make sure two places have the same files — kind of like a smarter, faster version of copy-paste that can work over the internet.
  - rsync typically uses SSH for authentication.
    - But in some CTF scenarios, rsync may allow anonymous access (no password) — especially if it’s running as a public rsync daemon.
###  General Syntax for Remote Access
_$~ rsync [options] rsync://IP_or_Hostname/module/_
- The module is like a shared folder offered by the rsync server.
  - You don’t really "log in" and "navigate" like SSH or FTP. Instead, you list what's shared, then pull files from it.

### Common rsync Commands and Switches

| Switch | Name               | Description                                                                 |
|:-------|:-------------------|:----------------------------------------------------------------------------|
| -a     | Archive            | Recursively copy and preserve symbolic links, permissions, modification times, etc. |
| -v     | Verbose            | Show detailed output of what `rsync` is doing                              |
| -z     | Compression        | Compress file data during the transfer                                      |
| -r     | Recursive          | Copy directories recursively (included in `-a`)                             |
| -e     | Remote shell       | Specify the remote shell to use (e.g., `-e ssh`)                            |
| -P     | Progress           | Show progress and allow resume of interrupted transfers (`--partial --progress`) |
| --list-only | List only     | Show what would be transferred, without actually copying                    |
| --delete | Delete           | Delete extraneous files from destination dirs                               |
| -n     | Dry run            | Simulate the transfer, showing what would happen without making changes     |

### Example Steps for CTF
1. rsync rsync://10.10.10.10/ (List Modules (Shared Folders like "public" or "Anonymous Shares"))
2. rsync --list-only rsync://10.10.10.10/public/ (List Files Inside a Module ("public")
3. rsync -P rsync://10.10.10.10/public/flag.txt . (This will download "flag.txt" to your current directory.)
4. Done

* * *

## 9. Appointment
- SQL (Structured Query Language) is a standard language used to manage and manipulate relational databases by performing tasks like querying data, updating records, or deleting tables.
- SQL Injection (SQLi) is a vulnerability that allows an attacker to interfere with the queries an application makes to its database. It can be used to bypass login, extract data, or even modify the database.

### Common SQL Commands

| Command     | Description                                      | Example                            |
|:------------|:--------------------------------------------------|:-----------------------------------|
| SELECT      | Retrieve data from one or more tables             | SELECT * FROM users;               |
| INSERT      | Add new data into a table                         | INSERT INTO users VALUES (...);    |
| UPDATE      | Modify existing data in a table                   | UPDATE users SET name='Joe';       |
| DELETE      | Remove data from a table                          | DELETE FROM users WHERE id=1;      |
| CREATE      | Create a new table or database                    | CREATE TABLE users (...);          |
| DROP        | Delete a table or database                        | DROP TABLE users;                  |

### Common SQL Injection Payloads 
- Can replace "--" with "#")
   - "--" must have a space after in order for syntax to be correct

| Payload                         | Purpose                                      | Description                        |
|:--------------------------------|:---------------------------------------------|:-----------------------------------|
| ' OR 1=1 --                    | Bypass login                                | Always true, skips password check |
| ' OR 1=1 #                         | Bypass login                                | Always true, comments out rest       |
| admin' --                      | Login as admin without password              | Comments out the rest             |
| admin' #                           | Login as admin without password              | Comments out password clause         |
| ' UNION SELECT null,null --   | Test for UNION-based injection               | Combines multiple SELECTs         |
| ' UNION SELECT null,null #        | Test for UNION-based injection               | Checks for compatible column count   |
| ' AND 1=2 --                   | False condition for testing filtering        | Useful for confirming injection   |
| ' AND 1=2 #                        | False condition for testing filtering        | Used to trigger no results           |
| ' ORDER BY 1 --                | Check number of columns                      | Used to trigger errors            |
| ' ORDER BY 1 #                     | Check number of columns                      | Triggers error if column doesn't exist |
| ' OR 'a'='a' --                | Classic tautology                            | Always true                       |
| ' OR 'a'='a' #                     | Classic tautology                            | Always true                          |
| ' OR 1=1 LIMIT 1 #                | Selects only one result                      | Avoids long output                   |
| ' AND ASCII(SUBSTRING(user(),1,1))=114 # | Blind SQLi payload                      | Extracts info character by character |
| 1' AND SLEEP(5) #                 | Time-based Blind SQLi                        | Detects injection via response delay |



### How to solve CTF
1. Scan for open ports --> _~$ nmap -sV -O -Pn -n -p- -T5 TargetIP_
2. Notice port 80 http is open.
3. Check for web application
4. Perfom directory busting --> _$~gobuster dir -u http://IP_ADDRESS/ -w /usr/share/wordlists/dirb/common.txt
5. Conduct SQL injection on login form --> _admin' #_
6. Done

* * *

## 10. Squel
MariaDB is an open-source relational database management system (RDBMS), a fork of MySQL. It uses SQL (Structured Query Language) to manage data and is often used in web applications. It's compatible with MySQL, but has performance and licensing improvements.
### Accessing MariaDB commands
- Local
  - Authenticated _~$ mysql -u root -p_
  - unauthenticated _~$ mysql -u root_
- Remote
  - Authenticated _~$ mysql -h target_ip -u username -p_
  - unauthenticated _~$ mysql -h target_ip_ `or if misconfigured` _~$ mysql -h target_ip -u root_
### Common mysql Command-line Switches

| Switch | Description                    | Example               |
| :----- | :----------------------------- | :-------------------- |
| `-u`   | Username                       | `-u root`             |
| `-p`   | Prompt for password            | `-p`                  |
| `-h`   | Host IP or hostname            | `-h 10.10.10.10`      |
| `-P`   | Port number                    | `-P 3306`             |
| `-e`   | Execute SQL statement and exit | `-e "SHOW DATABASES"` |

### MariaDB/MySQL Basic SQL Syntax

| Command                     | Description                        | Example                       |
| :-------------------------- | :--------------------------------- | :---------------------------- |
| `SHOW DATABASES;`           | List all databases                 | `SHOW DATABASES;`             |
| `USE database_name;`        | Select a database to work with     | `USE testdb;`                 |
| `SHOW TABLES;`              | List all tables in the selected DB | `SHOW TABLES;`                |
| `DESCRIBE table;`           | Show structure of a table          | `DESCRIBE users;`             |
| `SELECT * FROM table;`      | Show all data in a table           | `SELECT * FROM flag;`         |
| `SELECT column FROM table;` | Get specific column data           | `SELECT username FROM users;` |

Steps to completion.
1. _~$ nmap -sV -sC -O -Pn -n -T5 -p 3306 TargetIP_
2. _~$ mysql -h targetIP -u root_
3. Logged into database
4. _> show databases;_
5. _> use htb;_
6. _> show tables;_
7. _> select * from config;_
8. Flag captured

* * *

## 11. Crocodile

What Nmap scanning switch employs the use of default scripts during a scan? _-sC_

### Methodology
- Nmap scan is performed. _~$ nmap -sV -sC -O -Pn -n -p- -T5 10.129.138.235_
  - Port 21 (ftp) and port 80 (http) is open.
- Try to find useful data with ftp.
  - _~$ ftp TargetIP_
    - Found _allowed.userlist_ and _allowed.userlist.passwd_
    - username "admin" discovered
    - Extract files with _get_ --> _~$ get allowed.userlist_
- Perform directory busting on http web application.
  - use gobuster with `-x` switch to look for .php filetypes
  - _~$ gobuster dir -u TargetIP -w /usr/share/wordlists/dirb/common.txt -x php
    - _`/login.php` and `/config.php`_ discovered --> attempting login with credentials on `/login.php`
    - admin credentials are successful
- _**Flag Captured**_

* * *

## 12. Responder








* * *

## 13. Three
## 14. Ignition
## 15. Bike
## 16. Funnel
## 17. Pennyworth
### 18. Tactics
## 19. Archetype
## 20. Oopsie
## 21. Vaccine
## 22. Unified
## 23. Included
## 24. Markup
## 25. Base





