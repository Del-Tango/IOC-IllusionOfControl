#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETTERS

function set_ioc_cloak_order () {
    local ORDER="$1"
    check_item_in_set "$ORDER" 'pre-exec' 'post-exec'
    if [ $? -ne 0 ]; then
        error_msg "Invalid (${BLUE}$SCRIPT_NAME${RESET}) cloak execution order"\
            "(${RED}$ORDER${RESET})."
        return 1
    fi
    MD_DEFAULT['cloak-order']="$ORDER"
    return 0
}

function set_command_to_cloak () {
    local COMMAND="$1"
    MD_DEFAULT['command']="$COMMAND"
    return 0
}

function set_ioc_target_type () {
    local TARGET_TYPE="$1"
    check_item_in_set "$TARGET_TYPE" "local" "remote"
    if [ $? -ne 0 ]; then
        error_msg "Invalid (${BLUE}$SCRIPT_NAME${RESET}) target type"\
            "(${RED}$TARGET_TYPE${RESET})."
        return 1
    fi
    MD_DEFAULT['target']="$TARGET_TYPE"
    return 0
}

function set_ioc_connection_type () {
    local CNX_TYPE="$1"
    check_item_in_set "$CNX_TYPE" "raw" "ssh"
    if [ $? -ne 0 ]; then
        error_msg "Invalid remote connection type"\
            "(${RED}$CNX_TYPE${RESET})."
        return 1
    fi
    MD_DEFAULT['conn-type']="$CNX_TYPE"
    return 0
}

function set_ioc_connection_details () {
    local CNX_DETAILS="$1"
    check_valid_remote_connection_details "$CNX_DETAILS"
    if [ $? -ne 0 ]; then
        error_msg "Invalid remote connection details"\
            "(${RED}$CNX_DETAILS${RESET})."
        return 1
    fi
    MD_DEFAULT['conn-details']="$CNX_DETAILS"
    return 0
}

function set_ioc_path_setup_flag () {
    local FLAG="$1"
    check_item_in_set "$FLAG" "on" "off"
    if [ $? -ne 0 ]; then
        error_msg "Invalid flag value (${RED}$FLAG${RESET})."
        return 1
    fi
    MD_DEFAULT['setup-path']="$FLAG"
    return 0
}

function set_ioc_path_directory  () {
    local DIR_PATH="$1"
    if [[ "${MD_DEFAULT['target']}" == 'local' ]]; then
        check_directory_exists "$DIR_PATH"
        if [ $? -ne 0 ]; then
            error_msg "Directory (${RED}$DIR_PATH${RESET}) does not exist."
            return 1
        fi
    fi
    MD_DEFAULT['path-dir']="$DIR_PATH"
    return 0
}

function set_ioc_connection_timeout () {
    local TIMEOUT_SECONDS="$1"
    check_value_is_number "$TIMEOUT_SECONDS"
    if [ $? -ne 0 ]; then
        error_msg "Number of seconds until connection timeout"\
            "must be a number, not (${RED}$TIMEOUT_SECONDS${RESET})."
        return 1
    fi
    MD_DEFAULT['conn-timeout']=$TIMEOUT_SECONDS
    return 0
}

function set_imported_command_file () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
        return 1
    fi
    IOC_IMPORTS['command-file']="$FILE_PATH"
    return 0
}

function set_dagger_file () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
        return 1
    fi
    MD_DEFAULT['dgr-file']="$FILE_PATH"
    return 0
}

function set_log_file () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
        return 1
    fi
    MD_DEFAULT['log-file']="$FILE_PATH"
    return 0
}

function set_log_lines () {
    local LOG_LINES=$1
    if [ -z "$LOG_LINES" ]; then
        error_msg "Log line value (${RED}$LOG_LINES${RESET}) is not a number."
        return 1
    fi
    MD_DEFAULT['log-lines']=$LOG_LINES
    return 0
}


