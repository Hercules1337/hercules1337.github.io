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
| **Command**              | **Description**                      |
| ------------------------ | ------------------------------------ |
| `SET <key> <value>`      | Set a key-value pair                 |
| `GET <key>`              | Retrieve the value of a key          |
| `DEL <key>`              | Delete a key                         |
| `KEYS <pattern>`         | List all keys matching a pattern     |
| `EXPIRE <key> <seconds>` | Set a timeout for a key (in seconds) |
| `MGET <key1> <key2>`     | Get multiple keys                    |
| `FLUSHALL`               | Delete all keys in the database      |




### 5. Explosion
### 6. Preignition
### 7. Mongod
### 8. Synced
### 9. Appointment

* * *

### 10. Squel
### 11. Crocodile
### 12. Responder
### 13. Three
### 14. Ignition
### 15. Bike
### 16. Funnel
### 17. Pennyworth
### 18. Tactics
### 19. Archetype
### 20. Oopsie
### 21. Vaccine
### 22. Unified
### 23. Included
### 24. Markup
### 25. Base





