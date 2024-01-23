#!/bin/tcsh

set ThisDir = `dirname $0`
set MriScriptDir = ${ThisDir}/download_unzip_MRI

# file to store cookies from XNAT, for curl's use
setenv MRI_CURL_COOKIE_FILE ~/xnat_cookies
# clear stale cookies
echo "" >! ${MRI_CURL_COOKIE_FILE}

# shared by all XNAT REST API calls (via curl)
# quiet mode; fail if HTTP response code not OK; store to and read from cookie file
setenv MRI_CURL_COMMON_ARGS "--silent --show-error --fail -b ${MRI_CURL_COOKIE_FILE} -c ${MRI_CURL_COOKIE_FILE}"

# request XNAT session
# session info is stored in cookie file (see MRI_CURL_COMMON_ARGS) 
${MriScriptDir}/request_session.sh
if ($status > 0) then
    exit 1
endif

set SubjectIDs = (14567)
set ScanDates = (20230727)
set ProjectIDs = (185)

foreach Index (`seq $#SubjectIDs`)
    ${MriScriptDir}/download_unzip_MRI_one_subj.sh -s ${SubjectIDs[$Index]} -d ${ScanDates[$Index]} -p ${ProjectIDs[$Index]}
end

# Logging off
${MriScriptDir}/delete_session.sh
echo "logged off"

unsetenv MRI_CURL_COMMON_ARGS
unsetenv MRI_CURL_COOKIE_FILE
