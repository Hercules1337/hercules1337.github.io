Intro to Command Injection
  - It's a serious vulnerability
  - Application is taking input from a user and then it is passing that input into a function that executes it as code
  - "eval() is evil"
  - "eval" is one of the functions that executes data that is passed to it
  - testing/exectution can be done in the browser using Dev Tools (inspect element)
    
Testing Example:
Dev Tools (In Browser)
    ~ eval(1+1)
    
    ~ let userInput = '7*7'
    ~ eval(userInput)

PHP interactive shell
  ~ php > $userInput = 'whoami';
  ~ php > system($userInput);

NEVER TRUST INPUT FROM A USER & ANYBODY ELSE
AVOID USEING "EVAL" OR "SYSTEM"
