# Notes as I go...

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
> When attempting this machine, the current installed version of mongosh was not compatible with the MondoDB server. There was no workaround with the HTB Pwnbox. I couldnt downgrade mongosh nor could I install mongo. Regardless I understood the machine and completed it by following the write-up. Thank you.

## 8. Synced
## 9. Appointment

* * *

## 10. Squel
## 11. Crocodile
## 12. Responder
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





