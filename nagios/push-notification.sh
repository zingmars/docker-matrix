#!/usr/bin/env bash
#based on https://www.freelock.com/blog/john-locke/2017-09/post-nagiosicinga-alerts-matrix-room

# Configuration
# To obtain a token from Riot: Log in (recommended - through private browsing mode), go to Settings -> Help & About. You can reveal the token at the bottom. Do not log out or it will revoke the token.
MX_TOKEN=""
MX_SERVER="https://matrix"
MX_ROOM="!:matrix"
NAGIOS_HOSTNAME="hostname"

HOST="$1"
HOSTNAME="$2"
DESCRIPTION="$3"
STATE="$4"
OUTPUT="$5"
COMMENT="$6"

ICON=""
warn_ico="ÔÜá"
error_ico="ÔØî"
ok_ico="Ô£ô"
question_ico="ÔØô"

if [ "$STATE" = "UP" ]
then
    ICON=$ok_ico
elif [ "$STATE" = "DOWN" ]
then
    ICON=$error_ico
elif [ "$STATE" = "UNKNOWN" ]
then
    ICON=$question_ico
elif [ "$STATE" = "OK" ]
then
    ICON=$ok_ico
elif [ "$STATE" = "WARNING" ]
then
    ICON=$warn_ico
elif [ "$STATE" = "CRITICAL" ]
then
    ICON=$error_ico
fi

BODY="${ICON} Host: ${HOST} (${HOSTNAME}) - ${DESCRIPTION} is ${STATE}.\n\
${ICON} Output: ${OUTPUT}\n\
Comment (if any): ${COMMENT}\n\
More info: https://${NAGIOS_HOSTNAME}/nagios/cgi-bin/status.cgi?host=${HOST}&style=detail"

MX_MSGID="`date "+%s"`$(( RANDOM % 9999 ))"
curl -X PUT --header 'Content-Type: application/json' --header 'Accept: application/json' -d "{ \"msgtype\": \"m.text\", \"body\": \"${BODY}\" }" "${MX_SERVER}/_matrix/client/unstable/rooms/$MX_ROOM/send/m.room.message/$MX_MSGID?access_token=$MX_TOKEN"
