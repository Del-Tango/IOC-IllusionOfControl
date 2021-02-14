#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FETCHERS

function fetch_remote_address_from_connection_details () {
    local CONNECTION_DETAILS="$1"
    echo "$CONNECTION_DETAILS" | cut -d':' -f 1 | cut -d'@' -f 2
    return $?
}

function fetch_remote_port_from_connection_details () {
    local CONNECTION_DETAILS="$1"
    echo "$CONNECTION_DETAILS" | cut -d':' -f 2
    return $?
}

function fetch_remote_user_from_connection_details () {
    local CONNECTION_DETAILS="$1"
    echo "$CONNECTION_DETAILS" | cut -d':' -f 1 | cut -d'@' -f 1
    return $?
}

function fetch_remote_password_from_connection_details () {
    local CONNECTION_DETAILS="$1"
    echo "$CONNECTION_DETAILS" | cut -d':' -f 3
    return $?
}

