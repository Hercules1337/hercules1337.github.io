# PortSwigger Academy Notes

## CSRF
## The delivery mechanisms for cross-site request forgery attacks are essentially the same as for reflected XSS. 
- If the request to change email address can be performed with the GET method, then a self-contained attack would look like this:
- ` <img src="https://vulnerable-website.com/email/change?email=pwned@evil-user.net"> `
