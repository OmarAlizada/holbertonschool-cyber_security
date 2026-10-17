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

## Task 3 - Magic number bypass

The server validates PNG content (magic number + structure) and only allows the .png
extension. A valid minimal PNG with an appended PHP payload was uploaded using the
null-byte filename trick (m3b.php%00.png): the extension check saw .png while the
server truncated the name at the null byte and stored /static/upload/m3b.php, which
executed a readfile of FLAG_3.txt.

Flag: 2291b6c61858a1915cdf6133b46bc1ac

## Task 4 - File length limit bypass

Response headers expose X-Debug-Mode: False. Sending X-Debug-Mode: True as a request
header disables the server-side criteria checks, allowing a separate PHP payload to
be uploaded and executed, reading FLAG_4.txt. Files above the 1 MB body limit are
still rejected at the proxy layer (413/500), but the debug backdoor is what unlocks
the task (hidden header shown in responses of /api/task4/).

Flag: 55e11dcfa2916545a41fe86a773af1bb
