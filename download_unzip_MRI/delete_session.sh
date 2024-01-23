#!/bin/tcsh

set XnatUrlJsession = "https://rrinid.rotman-baycrest.on.ca/spred/data/JSESSION"

curl ${MRI_CURL_COMMON_ARGS} -X DELETE --url ${XnatUrlJsession}
if ($status > 0) then
    echo "Failed to log off"
    exit 1
endif
