#!/usr/bin/env bash
#######################################################################
#   Author: Renegade-Master
#   Contributors: JohnEarle
#   Description: Install, update, and start a Dedicated 7 Days to Die
#       instance.
#######################################################################

# Set to `-x` for Debug logging
set -euo pipefail

# Start the Server
start_server() {
    printf "\n### Starting 7 Days to Die Server...\n"

    # Set library location to local directory
    export LD_LIBRARY_PATH="$BASE_GAME_DIR"

    "$SERVER_START" \
        -configfile="$SERVER_CONFIG" \
        -logfile "$LOG_FILE" \
        -quit -batchmode -nographics -dedicated
}

apply_postinstall_config() {
    printf "\n### Applying Post Install Configuration...\n"

    # Set the Server Name
    ./edit_server_config.py "$SERVER_CONFIG" "ServerName" "$SERVER_NAME"

    # Set the Server Description
    ./edit_server_config.py "$SERVER_CONFIG" "ServerDescription" "$SERVER_DESC"

    # Set the Server Password
    ./edit_server_config.py "$SERVER_CONFIG" "ServerPassword" "$SERVER_PASSWORD"

    # Set the Server query Port
    ./edit_server_config.py "$SERVER_CONFIG" "ServerPort" "$QUERY_PORT"

    # Set the Server publicity status
    ./edit_server_config.py "$SERVER_CONFIG" "ServerVisibility" "$PUBLIC_SERVER"

    # Set the Max Players
    ./edit_server_config.py "$SERVER_CONFIG" "ServerMaxPlayerCount" "$MAX_PLAYERS"

    printf "\n### Post Install Configuration applied.\n"
}

# Test if this is the the first time the server has run
test_first_run() {
    printf "\n### Checking if this is the first run...\n"

    if [[ ! -f "$SERVER_CONFIG" ]]; then
        printf "\n### This is the first run.\n"

        # Copy default config into Config directory
        cp "$BASE_GAME_DIR/serverconfig.xml" "$SERVER_CONFIG"
    else
        printf "\n### This is not the first run.\n"
    fi

    printf "\n### First run check complete.\n"
}

# Update the server
update_server() {
    printf "\n### Updating 7 Days to Die Server...\n"

    "$STEAM_PATH" +runscript "$STEAM_INSTALL_FILE"

    printf "\n### 7 Days to Die Server updated.\n"
}

# Apply user configuration to the server
apply_preinstall_config() {
    printf "\n### Applying Pre Install Configuration...\n"

    # Set the selected game version
    sed -i "s/beta .* /beta $GAME_VERSION /g" "$STEAM_INSTALL_FILE"

    printf "\n### Pre Install Configuration applied.\n"
}

# Change the folder permissions for install and save directory
update_folder_permissions() {
    printf "\n### Updating Folder Permissions...\n"

    chown -R "$(id -u):$(id -g)" "$BASE_GAME_DIR"
    chown -R "$(id -u):$(id -g)" "$CONFIG_DIR"
    mkdir -p "$SAVES_DIR"

    printf "\n### Folder Permissions updated.\n"
}

# Set variables for use in the script
set_variables() {
    printf "\n### Setting variables...\n"

    STEAM_INSTALL_FILE="/home/steam/install_server.scmd"
    BASE_GAME_DIR="/home/steam/7DTDServer"
    CONFIG_DIR="/home/steam/7DTDConfig"
    SAVES_DIR="/home/steam/.local/share/7DaysToDie"
    LOG_FILE=${LOG_FILE:-"$CONFIG_DIR/logs/output_log-$(date +%Y-%m-%d__%H-%M-%S).log"}

    # Set the game version variable
    GAME_VERSION=${GAME_VERSION:-"public"}

    # Set the Server Publicity variable
    PUBLIC_SERVER=${PUBLIC_SERVER:-"2"}

    # Set the IP Query Port variable
    QUERY_PORT=${QUERY_PORT:-"26900"}

    # Set the Server name variable
    SERVER_NAME=${SERVER_NAME:-"7 Days To Die Dedicated Server"}

    # Set the Server description variable
    SERVER_DESC=${SERVER_DESC:-"Welcome to a 7 Days to Die Dedicated Server"}

    # Set the Server Password variable
    SERVER_PASSWORD=${SERVER_PASSWORD:-""}

    # Maximum number of players
    MAX_PLAYERS=${MAX_PLAYERS:-"8"}

    SERVER_START="$BASE_GAME_DIR/7DaysToDieServer.x86_64"
    SERVER_CONFIG="$CONFIG_DIR/serverconfig.xml"
}

## Main
set_variables
update_folder_permissions
apply_preinstall_config
update_server
test_first_run
apply_postinstall_config
start_server
