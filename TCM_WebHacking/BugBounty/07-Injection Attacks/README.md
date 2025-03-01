# Intro to Command Injection
  - It's a serious vulnerability
  - Application is taking input from a user and then it is passing that input into a function that executes it as code
  - "eval() is evil"
  - "eval" is one of the functions that executes data that is passed to it
  - testing/exectution can be done in the browser using Dev Tools (inspect element)
    
### Testing Example:

Dev Tools (In Browser)
## JavaScript
```js
eval(1+1);

let userInput = '7*7';
eval(userInput);
```
PHP interactive shell:
## PHP
```php
$userInput = 'whoami';
system($userInput);
```
NEVER TRUST INPUT FROM A USER & ANYBODY ELSE

AVOID USING "EVAL" OR "SYSTEM"

# Command Injection Attacks
 - Some admin functionality may include an attack vector for command injection
 - "Network Check" -> "http://localhost"
### cURL Command Example
```bash
curl -l -s -L http://localhost | grep "HTTP/"
```
Questions to ask
1. Can we chain commands?
2. Can we add something that gets executed?

Example chaining executed command
```html
http://localhost;whoami -> http://localhost;whoami;# -> ;whoami;#
```
### Methodology
  - Understand what is happening in the backend
      - what filtering is happening
      - what limitation on certain characters there are
### GOAL
 - Try to get shell
 - decide what technology to use for reverse shell
```bash
echo -e "\e[31mThis is red text\e[0m"
echo -e "\e[32mThis is green text\e[0m"
```


