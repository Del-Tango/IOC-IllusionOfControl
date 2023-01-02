#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# LOADERS

function load_ioc_config () {
    load_ioc_script_name
    load_ioc_prompt_string
    load_ioc_safety
    load_settings_ioc_default
    load_ioc_logging_levels
}

function load_ioc_safety () {
    if [ -z "$IOC_SAFETY" ]; then
        warning_msg "No default safety flag value found. Defaulting to $MD_SAFETY."
        return 1
    fi
    MD_SAFETY=$IOC_SAFETY
    check_item_in_set "$MD_SAFETY" 'on' 'off'
    if [ $? -ne 0 ]; then
        nok_msg "Invalid safety flag value (${RED}$MD_SAFETY${RESET})."
    else
        ok_mg "Successfully loaded safety flag value"\
            "(${GREEN}$MD_SAFETY${RESET})."
    fi
    return 0
}

function load_ioc_prompt_string () {
    if [ -z "$IOC_PS3" ]; then
        warning_msg "No default prompt string found. Defaulting to $MD_PS3."
        return 1
    fi
    set_project_prompt "$IOC_PS3"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load prompt string ${RED}$IOC_PS3${RESET}."
    else
        ok_msg "Successfully loaded"\
            "prompt string ${GREEN}$IOC_PS3${RESET}"
    fi
    return $EXIT_CODE
}

function load_ioc_logging_levels () {
    if [ ${#IOC_LOGGING_LEVELS[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} logging levels found."
        return 1
    fi
    MD_LOGGING_LEVELS=( ${IOC_LOGGING_LEVELS[@]} )
    ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} logging levels."
    return 0
}

function load_settings_ioc_default () {
    if [ ${#IOC_DEFAULT[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} defaults found."
        return 1
    fi
    for ioc_setting in ${!IOC_DEFAULT[@]}; do
        MD_DEFAULT[$ioc_setting]=${IOC_DEFAULT[$ioc_setting]}
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default setting"\
            "(${GREEN}$ioc_setting - ${IOC_DEFAULT[$ioc_setting]}${RESET})."
    done
    done_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} default settings."
    return 0
}

function load_ioc_script_name () {
    if [ -z "$IOC_SCRIPT_NAME" ]; then
        warning_msg "No default script name found. Defaulting to $SCRIPT_NAME."
        return 1
    fi
    set_project_name "$IOC_SCRIPT_NAME"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load script name ${RED}$IOC_SCRIPT_NAME${RESET}."
    else
        ok_msg "Successfully loaded"\
            "script name ${GREEN}$IOC_SCRIPT_NAME${RESET}"
    fi
    return $EXIT_CODE
}

# SETUP

function illusion_of_control_project_setup () {
    lock_and_load
    load_ioc_config
    create_ioc_menu_controllers
    setup_ioc_menu_controllers
}

function setup_ioc_menu_controllers () {
    setup_ioc_dependencies
    setup_main_menu_controller
    setup_log_viewer_menu_controller
    setup_settings_menu_controller
    setup_cloak_and_dagger_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller setup complete."
    return 0
}

# SETUP DEPENDENCIES

function setup_ioc_dependencies () {
    setup_ioc_apt_dependencies
    return 0
}

function setup_ioc_apt_dependencies () {
    if [ ${#IOC_APT_DEPENDENCIES[@]} -eq 0 ]; then
        warning_msg "No ${RED}$SCRIPT_NAME${RESET} dependencies found."
        return 1
    fi
    FAILURE_COUNT=0
    SUCCESS_COUNT=0
    for util in ${IOC_APT_DEPENDENCIES[@]}; do
        add_apt_dependency "$util"
        if [ $? -ne 0 ]; then
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
        else
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    done_msg "(${GREEN}$SUCCESS_COUNT${RESET}) ${BLUE}$SCRIPT_NAME${RESET}"\
        "dependencies staged for installation using the APT package manager."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

# CLOAK AND DAGGER MENU SETUP

function setup_cloak_and_dagger_menu_controller () {
    setup_cloak_and_dagger_menu_option_start_ioc_assault
    setup_cloak_and_dagger_menu_option_interactive_session
    setup_cloak_and_dagger_menu_option_open_backdoor
    setup_cloak_and_dagger_menu_option_ioc_help
    setup_cloak_and_dagger_menu_option_back
    done_msg "(${CYAN}$CLOAK_AND_DAGGER_CONTROLLER_LABEL${RESET}) controller"\
        "option binding complete."
    return 0
}

function setup_cloak_and_dagger_menu_option_start_ioc_assault () {
    info_msg "Binding ${CYAN}$CLOAK_AND_DAGGER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Start-IOC-Assault${RESET}"\
        "to function ${MAGENTA}action_start_ioc_assault${RESET}..."
    bind_controller_option \
        'to_action' "$CLOAK_AND_DAGGER_CONTROLLER_LABEL" \
        'Start-IOC-Assault' "action_start_ioc_assault"
    return $?
}

function setup_cloak_and_dagger_menu_option_interactive_session () {
    info_msg "Binding ${CYAN}$CLOAK_AND_DAGGER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Interactive-Session${RESET}"\
        "to function ${MAGENTA}action_interactive_raw_socket_session${RESET}..."
    bind_controller_option \
        'to_action' "$CLOAK_AND_DAGGER_CONTROLLER_LABEL" \
        'Interactive-Session' "action_interactive_raw_socket_session"
    return $?
}

function setup_cloak_and_dagger_menu_option_open_backdoor () {
    info_msg "Binding ${CYAN}$CLOAK_AND_DAGGER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Open-Backdoor${RESET}"\
        "to function ${MAGENTA}action_open_raw_socket_backdoor${RESET}..."
    bind_controller_option \
        'to_action' "$CLOAK_AND_DAGGER_CONTROLLER_LABEL" \
        'Open-Backdoor' "action_open_raw_socket_backdoor"
    return $?
}

function setup_cloak_and_dagger_menu_option_ioc_help () {
    info_msg "Binding ${CYAN}$CLOAK_AND_DAGGER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}IOC-Help${RESET}"\
        "to function ${MAGENTA}action_ioc_help${RESET}..."
    bind_controller_option \
        'to_action' "$CLOAK_AND_DAGGER_CONTROLLER_LABEL" \
        'IOC-Help' "action_ioc_help"
    return $?
}

function setup_cloak_and_dagger_menu_option_back () {
    info_msg "Binding ${CYAN}$CLOAK_AND_DAGGER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$CLOAK_AND_DAGGER_CONTROLLER_LABEL" 'Back' "action_back"
    return $?
}

# MAIN MENU SETUP

function setup_main_menu_controller () {
    setup_main_menu_option_ioc_assault
    setup_main_menu_option_log_viewer
    setup_main_menu_option_control_panel
    setup_main_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_main_menu_option_ioc_assault () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Start-(I.O).Control${RESET}"\
        "to controller ${MAGENTA}$CLOAK_AND_DAGGER_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        '(I.O).Control' "$CLOAK_AND_DAGGER_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_log_viewer () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Log-Viewer${RESET}"\
        "to controller ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'Log-Viewer' "$LOGVIEWER_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_control_panel () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Control-Panel${RESET}"\
        "to controller ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'Control-Panel' "$SETTINGS_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_back () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$MAIN_CONTROLLER_LABEL" 'Back' "action_back"
    return $?
}

# LOG VIEWER MENU SETUP

function setup_log_viewer_menu_controller () {
    setup_log_viewer_menu_option_display_tail
    setup_log_viewer_menu_option_display_head
    setup_log_viewer_menu_option_display_more
    setup_log_viewer_menu_option_clear_log_file
    setup_log_viewer_menu_option_back
    done_msg "${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_log_viewer_menu_option_clear_log_file () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Clear-Log${RESET}"\
        "to function ${MAGENTA}action_clear_log_file${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Clear-Log' "action_clear_log_file"
    return $?
}

function setup_log_viewer_menu_option_display_tail () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Tail${RESET}"\
        "to function ${MAGENTA}action_display_log_tail${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Tail' "action_log_view_tail"
    return $?
}

function setup_log_viewer_menu_option_display_head () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Head${RESET}"\
        "to function ${MAGENTA}action_display_log_head${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Head' "action_log_view_head"
    return $?
}

function setup_log_viewer_menu_option_display_more () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-More${RESET}"\
        "to function ${MAGENTA}action_display_log_more${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-More' "action_log_view_more"
    return $?
}

function setup_log_viewer_menu_option_back () {
    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" 'Back' "action_back"
    return $?
}

# SETTINGS MENU SETUP

function setup_settings_menu_controller () {
    setup_settings_menu_option_set_safety_off
    setup_settings_menu_option_set_safety_on
    setup_settings_menu_option_set_sudo_flag
    setup_settings_menu_option_set_command
    setup_settings_menu_option_set_ioc_target
    setup_settings_menu_option_set_connection_type
    setup_settings_menu_option_set_connection_details
    setup_settings_menu_option_set_setup_path_flag
    setup_settings_menu_option_set_connection_timeout
    setup_settings_menu_option_set_temporary_file
    setup_settings_menu_option_set_log_file
    setup_settings_menu_option_set_dagger_file
    setup_settings_menu_option_set_log_lines
    setup_settings_menu_option_set_file_editor
    setup_settings_menu_option_set_ioc_cloak_order
    setup_settings_menu_option_set_ioc_path_directory
    setup_settings_menu_option_import_command_file
    setup_settings_menu_option_edit_command_file
    setup_settings_menu_option_install_dependencies
    setup_settings_menu_option_back
    done_msg "${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_settings_menu_option_set_sudo_flag () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-SUDO-Flag${RESET}"\
        "to function ${MAGENTA}action_set_sudo_flag${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-SUDO-Flag" 'action_set_sudo_flag'
    return $?
}

function setup_settings_menu_option_set_dagger_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Dagger-File${RESET}"\
        "to function ${MAGENTA}action_set_dagger_file_path${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Dagger-File" 'action_set_dagger_file_path'
    return $?
}

function setup_settings_menu_option_set_safety_on () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Safety-ON${RESET}"\
        "to function ${MAGENTA}action_set_safety_on${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Safety-ON" 'action_set_safety_on'
    return $?
}

function setup_settings_menu_option_set_safety_off () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Safety-OFF${RESET}"\
        "to function ${MAGENTA}action_set_safety_off${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Safety-OFF" 'action_set_safety_off'
    return $?
}

function setup_settings_menu_option_set_command () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Command${RESET}"\
        "to function ${MAGENTA}action_set_command${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Command" 'action_set_command'
    return $?
}

function setup_settings_menu_option_set_ioc_target () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Target${RESET}"\
        "to function ${MAGENTA}action_set_target${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Target" 'action_set_target'
    return $?
}

function setup_settings_menu_option_set_connection_type () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Connection-Type${RESET}"\
        "to function ${MAGENTA}action_set_connection_type${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Connection-Type" 'action_set_connection_type'
    return $?
}

function setup_settings_menu_option_set_connection_details () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Connection-Details${RESET}"\
        "to function ${MAGENTA}action_set_connection_details${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Connection-Details" 'action_set_connection_details'
    return $?
}

function setup_settings_menu_option_set_setup_path_flag () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-PATH-Setup${RESET}"\
        "to function ${MAGENTA}action_set_setup_path_flag${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-PATH-Setup" 'action_set_setup_path_flag'
    return $?
}

function setup_settings_menu_option_set_connection_timeout () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Connection-Timeout${RESET}"\
        "to function ${MAGENTA}action_set_connection_timeout${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Connection-Timeout" 'action_set_connection_timeout'
    return $?
}

function setup_settings_menu_option_import_command_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Import-CMD-Cloaks${RESET}"\
        "to function ${MAGENTA}action_import_command_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Import-CMD-Cloaks" 'action_import_command_file'
    return $?
}

function setup_settings_menu_option_edit_command_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Edit-CMD-Cloaks${RESET}"\
        "to function ${MAGENTA}action_edit_command_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Edit-CMD-Cloaks" 'action_edit_command_file'
    return $?
}

function setup_settings_menu_option_set_ioc_cloak_order () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Order${RESET}"\
        "to function ${MAGENTA}action_set_ioc_order${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Order" 'action_set_ioc_order'
    return $?
}

function setup_settings_menu_option_set_ioc_path_directory () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-PATH${RESET}"\
        "to function ${MAGENTA}action_set_ioc_path_directory${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-PATH" 'action_set_ioc_path_directory'
    return $?
}

function setup_settings_menu_option_set_file_editor () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-File-Editor${RESET}"\
        "to function ${MAGENTA}action_set_file_editor${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-File-Editor" 'action_set_file_editor'
    return $?
}

function setup_settings_menu_option_set_temporary_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Temporary-File${RESET}"\
        "to function ${MAGENTA}action_set_temporary_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Temporary-File" 'action_set_temporary_file'
    return $?
}

function setup_settings_menu_option_set_log_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-File${RESET}"\
        "to function ${MAGENTA}action_set_log_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Log-File" 'action_set_log_file'
    return $?
}

function setup_settings_menu_option_set_log_lines () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-Lines${RESET}"\
        "to function ${MAGENTA}action_set_log_lines${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Log-Lines" 'action_set_log_lines'
    return $?
}

function setup_settings_menu_option_install_dependencies () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Install-Dependencies${RESET}"\
        "to function ${MAGENTA}action_install_dependencies${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Install-Dependencies" 'action_install_dependencies'
    return $?
}

function setup_settings_menu_option_back () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" 'Back' "action_back"
    return $?
}

# CODE DUMP

