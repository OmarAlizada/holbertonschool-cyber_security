# 0x05 Upload Vulnerabilities

Holberton School - Web Application Security 0x05 project.

## Task 0 - Find the upload endpoint subdomain

- Target Machine: Cyber - WebSec 0x05
- Main Domain: http://web0x05.hbtn
- The subdomain hosting the insecure file upload app: `test-s3.web0x05.hbtn`

The answer is stored in `0-target.txt`.

## Task 1 - Client-side filter bypass

The upload filter was enforced only in the browser (JavaScript). POSTing the PHP payload
directly to `POST /api/task1/` bypassed it; the file was stored at `/static/upload/<name>.php`
and a payload containing `<?php readfile("FLAG_1.txt") ?>` revealed the flag.

Flag: \`23604d20203999eaf526b4865d234f6f\`

## Task 2 - Server-side validation bypass (special characters)

The server-side extension whitelist rejects `.php` and allows `.png`. The server also
URL-decodes the filename and truncates it at the first null byte before storing it.
Uploading with the filename \`v2sh.php
## Task 1 - Client-side filter bypass

The upload filter was enforced only in the browser (JavaScript). POSTing the PHP payload
directly to POST /api/task1/ bypassed it; the file was stored at /static/upload/<name>.php
and a payload containing %php readfile("FLAG_1.txt") % revealed the flag.

Flag: 23604d20203999eaf526b4865d234f6f

## Task 2 - Server-side validation bypass (special characters)

The server-side extension whitelist rejects .php and allows .png. The server also
URL-decodes the filename and truncates it at the first null byte before storing it.
Uploading with the filename v2sh.php%00.png passes the .png extension check but
the file is stored as /static/upload/v2sh.php, which executes and reads FLAG_2.txt.

Flag: 19a93d778d2caecc04f0afa9f279ca5a
