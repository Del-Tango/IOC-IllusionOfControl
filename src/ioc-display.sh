#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_illusion_of_control_hot_banner () {
    echo "
    [ ${CYAN}Command${RESET}         ]: ${MAGENTA}${MD_DEFAULT['command']}${RESET}
    [ ${CYAN}Cloak Order${RESET}     ]: ${MAGENTA}${MD_DEFAULT['cloak-order']}${RESET}
    [ ${CYAN}Dagger File${RESET}     ]: ${YELLOW}${MD_DEFAULT['dgr-file']}${RESET}
    [ ${CYAN}PATH Directory${RESET}  ]: ${BLUE}${MD_DEFAULT['path-dir']}${RESET}
    [ ${CYAN}Target Machine${RESET}  ]: ${MAGENTA}${MD_DEFAULT['target']}${RESET}
    [ ${CYAN}Conn Type${RESET}       ]: ${MAGENTA}${MD_DEFAULT['conn-type']}${RESET}
    [ ${CYAN}Conn Timeout${RESET}    ]: ${WHITE}${MD_DEFAULT['conn-timeout']}${RESET}
    [ ${CYAN}Conn Details${RESET}    ]: ${GREEN}${MD_DEFAULT['conn-details']}${RESET}
    [ ${CYAN}Setup PATH${RESET}      ]: `format_flag_colors ${MD_DEFAULT['setup-path']}`
    [ ${CYAN}Force Command${RESET}   ]: `format_flag_colors ${MD_DEFAULT['force-cmd']}`
    [ ${CYAN}SUDO${RESET}            ]: `format_flag_colors ${MD_DEFAULT['sudo-flag']}`
    [ ${CYAN}Temporary File${RESET}  ]: ${YELLOW}${MD_DEFAULT['tmp-file']}${RESET}"
    if [[ "${MD_DEFAULT['sudo-flag']}" == 'on' ]]; then
        echo "
    [ ${RED}WARNING${RESET} ]: SUDO flag is ${GREEN}ON${RESET}! Watch your step -"
    fi
    return $?
}

function display_raw_socket_backdoor_hot_banner () {
    echo "
    [ ${CYAN}Verbosity Level${RESET} ]: ${WHITE}${MD_DEFAULT['rbd-verbosity']}${RESET}
    [ ${CYAN}Foreground Mode${RESET} ]: ${MAGENTA}${MD_DEFAULT['rbd-foreground']}${RESET}
    [ ${CYAN}Running Mode${RESET}    ]: ${MAGENTA}${MD_DEFAULT['rbd-mode']}${RESET}
    [ ${CYAN}Log File${RESET}        ]: ${YELLOW}${MD_DEFAULT['log-file']}${RESET}
    [ ${CYAN}Port Number${RESET}     ]: ${WHITE}${MD_DEFAULT['rbd-port']}${RESET}
    [ ${CYAN}Shell${RESET}           ]: ${MAGENTA}${MD_DEFAULT['rbd-shell']}${RESET}"
    return $?
}

function display_illusion_of_control_banner () {
    figlet -f lean -w 1000 "$SCRIPT_NAME" > "${MD_DEFAULT['tmp-file']}"
    clear; echo -n "${RED}`cat ${MD_DEFAULT['tmp-file']}`${RESET}"
    echo -n > ${MD_DEFAULT['tmp-file']}
    return 0
}

function display_ioc_settings () {
    echo "[ ${CYAN}Conf File${RESET}              ]: ${YELLOW}`basename ${MD_DEFAULT['conf-file']} 2> /dev/null`${RESET}
[ ${CYAN}Log File${RESET}               ]: ${YELLOW}`basename ${MD_DEFAULT['log-file']} 2> /dev/null`${RESET}
[ ${CYAN}Dagger File${RESET}            ]: ${YELLOW}`basename ${MD_DEFAULT['dgr-file']} 2> /dev/null`${RESET}
[ ${CYAN}Temporary File${RESET}         ]: ${YELLOW}`basename ${MD_DEFAULT['tmp-file']} 2> /dev/null`${RESET}
[ ${CYAN}Default Command File${RESET}   ]: ${YELLOW}`basename ${MD_DEFAULT['cmd-file']} 2> /dev/null`${RESET}
[ ${CYAN}Imported Command File${RESET}  ]: ${YELLOW}`basename ${IOC_IMPORTS['command-file']} 2> /dev/null`${RESET}
[ ${CYAN}File Editor${RESET}            ]: ${MAGENTA}${MD_DEFAULT['file-editor']}${RESET}
[ ${CYAN}Log Lines${RESET}              ]: ${WHITE}${MD_DEFAULT['log-lines']}${RESET}
[ ${CYAN}PATH Directory${RESET}         ]: ${BLUE}${MD_DEFAULT['path-dir']}${RESET}
[ ${CYAN}Cloak Order${RESET}            ]: ${MAGENTA}${MD_DEFAULT['cloak-order']}${RESET}
[ ${CYAN}Target${RESET}                 ]: ${MAGENTA}${MD_DEFAULT['target']}${RESET}
[ ${CYAN}Connection Type${RESET}        ]: ${MAGENTA}${MD_DEFAULT['conn-type']}${RESET}
[ ${CYAN}Connection Details${RESET}     ]: ${MAGENTA}${MD_DEFAULT['conn-details']}${RESET}
[ ${CYAN}Connection Timeout${RESET}     ]: ${WHITE}${MD_DEFAULT['conn-timeout']}${RESET}
[ ${CYAN}Command${RESET}                ]: ${MAGENTA}${MD_DEFAULT['command']}${RESET}
[ ${CYAN}Setup PATH${RESET}             ]: `format_flag_colors ${MD_DEFAULT['setup-path']}`
[ ${CYAN}Safety${RESET}                 ]: `format_flag_colors $MD_SAFETY`
[ ${CYAN}SUDO${RESET}                   ]: `format_flag_colors ${MD_DEFAULT['sudo-flag']}`
" | column
    echo; return 0
}

