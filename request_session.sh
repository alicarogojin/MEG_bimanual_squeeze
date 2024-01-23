#!/bin/tcsh

echo "Please enter XNAT username:"
set XnatUsername = $<

# suppress keystroke echo and let user enter password
stty -echo
echo "Please enter XNAT password:"
set XnatPassword = $<
# re-enable keystroke echo 
stty echo

set XnatUrlJsession = "https://rrinid.rotman-baycrest.on.ca/spred/data/JSESSION"

# acquire a JSESSION (token)
# (credentials provided by user; do NOT print output)
curl ${MRI_CURL_COMMON_ARGS} -u ${XnatUsername}:${XnatPassword} -o /dev/null -X POST --url ${XnatUrlJsession}
if ($status > 0) then
    echo "Bad username or password. You can call this script again. Bye!"
    exit 1
endif
