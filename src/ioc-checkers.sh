#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# CHECKERS

function check_valid_remote_connection_details () {
    local REMOTE_DETAILS="$1"
    echo "$REMOTE_DETAILS" | \
        egrep -e "*@[a-zA-Z0-9_. ]{1,}:[0-9]{1,}*" &> /dev/null
    return $?
}

