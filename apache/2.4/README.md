Enable Basic Authentication

# /usr/bin/htpasswd -c /var/httpd/etc/passwd admin

The username and password are combined with a single colon (:). This means that the username itself cannot contain a colon.
# echo -n admin:think4me |base64
YWRtaW46dGhpbms0bWU=
# curl --location --request POST 'https://www.goweekend.ca/fei/about' \
--header 'X-Authorization-Role: AUTHENTICATED' \
--header 'Authorization: Basic YWRtaW46dGhpbms0bWU=' \
-H 'Content-Type: application/json' -d '{ "firstname":"Bill", "lastName":"Gates"}'
