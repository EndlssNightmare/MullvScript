#!/bin/bash

# Definir as cores para a saída
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem cor

SCRIPT_PATH="$(realpath "$0")"

TEMP_FILE="/tmp/.mullv_script_run_$(whoami)"

# Captura o sinal SIGINT (CTRL+C) e executa a lógica de saída
trap 'echo -e "${RED}\nExiting..."${NC}; rm -f "$TEMP_FILE"; exit 1' SIGINT

# Grab the current terminal shell (bash, zsh, etc.)
CURRENT_SHELL=$(basename "$SHELL")

# Define CONFIG_FILE globalmente
if [ "$CURRENT_SHELL" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ "$CURRENT_SHELL" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    CONFIG_FILE="$HOME/.bashrc"  # Padrão para .bashrc caso falhe a detecção
fi

# Carregar a variável de ambiente do arquivo de configuração
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi

# Limpa o terminal
clear

# Função para exibir o banner com animação
display_banner() {
    banner=(
        "\n\n\n\n                  ████     ████          ██  ██           ████████                ██           ██  "
        "                 ░██░██   ██░██         ░██ ░██          ██░░░░░░                ░░  ██████   ░██  "
        "                 ░██░░██ ██ ░██ ██   ██ ░██ ░██ ██    ██░██         █████  ██████ ██░██░░░██ ██████"
        "                 ░██ ░░███  ░██░██  ░██ ░██ ░██░██   ░██░█████████ ██░░░██░░██░░█░██░██  ░██░░░██  "
        "                 ░██  ░░█   ░██░██  ░██ ░██ ░██░░██ ░██ ░░░░░░░░██░██  ░░  ░██ ░ ░██░██████   ░██  "
        "                 ░██   ░    ░██░██  ░██ ░██ ░██ ░░███          ░██░██   ██ ░██   ░██░██░░░    ░██  "
        "                 ░██        ░██░░██████ ███ ███  ░░██    ████████ ░░█████ ░███   ░██░██       ░░██ "
        "                 ░░         ░░  ░░░░░░ ░░░ ░░░    ░░    ░░░░░░░░   ░░░░░  ░░░    ░░ ░░         ░░ "
        "                         V01 | https://github.com/EndlssNightmare                                  "
        "                    SmartFox | https://github.com/Smarttfoxx\n\n"
    )
    for line in "${banner[@]}"; do
        echo -e "${PURPLE}$line${NC}"
        sleep 0.1
    done
}

# Função para exibir o menu
show_menu() {
    # Limpa o terminal
    clear

    # Exibir o banner
    echo -e "\n\n\n\n"
    echo -e "${PURPLE}                         ████     ████          ██  ██           ████████                ██           ██  "
    echo -e "                        ░██░██   ██░██         ░██ ░██          ██░░░░░░                ░░  ██████   ░██  "
    echo -e "                        ░██░░██ ██ ░██ ██   ██ ░██ ░██ ██    ██░██         █████  ██████ ██░██░░░██ ██████"
    echo -e "                        ░██ ░░███  ░██░██  ░██ ░██ ░██░██   ░██░█████████ ██░░░██░░██░░█░██░██  ░██░░░██  "
    echo -e "                        ░██  ░░█   ░██░██  ░██ ░██ ░██░░██ ░██ ░░░░░░░░██░██  ░░  ░██ ░ ░██░██████   ░██  "
    echo -e "                        ░██   ░    ░██░██  ░██ ░██ ░██ ░░███          ░██░██   ██ ░██   ░██░██░░░    ░██  "
    echo -e "                        ░██        ░██░░██████ ███ ███  ░░██    ████████ ░░█████ ░███   ░██░██       ░░██ "
    echo -e "                        ░░         ░░  ░░░░░░ ░░░ ░░░    ░░    ░░░░░░░░   ░░░░░  ░░░    ░░ ░░         ░░ "
    echo -e "                                V01 | https://github.com/EndlssNightmare                                  "
    echo -e "                           SmartFox | https://github.com/Smarttfoxx\n\n                                   "
    echo -e "                [01] Login       [02] Logout         [03] Change Region     [04] Revoke Account     [05] My Account\n"
    echo -e "                [06] Switch Acc  [07] Lock Mode      [08] Stealth Mode      [09] Change Protocol    [10] Reload Banner\n"
    echo -e "                [11] Exit        [12] Help Menu ${NC}\n\n"
}

display_banner

spinner() {
  local duration=$1
  local interval="0.1"
  local chars="/-\|"
  local i=0
  while [ "$(echo "$duration > 0" | bc -l)" -eq 1 ]; do
    local index=$(( i % ${#chars} ))
    local char="${chars:$index:1}"
    printf "\r${YELLOW}[%s] ${RESET}" "$char"
    sleep "$interval"
    duration=$(echo "$duration - $interval" | bc)
    i=$((i + 1))
  done
  echo -e "\r${GREEN}[✔] Done!${RESET}"
}

# Função para solicitar um novo ID de conta
request_new_account_id() {
            while true; do
                echo -e -n "${YELLOW}Please enter a valid Mullvad account ID: "
                read NEW_MULLV_AUTH
                echo -e "${NC}"

                if [[ "$NEW_MULLV_AUTH" =~ ^[0-9]{16}$ ]]; then
                    # Atualiza a variável no ambiente atual
                    export MULLV_AUTH="$NEW_MULLV_AUTH"

                    # Atualiza no arquivo de configuração do shell
                    if ! grep -q "export MULLV_AUTH=" "$CONFIG_FILE"; then
                        echo "export MULLV_AUTH=\"$MULLV_AUTH\"" >> "$CONFIG_FILE"
                    else
                        sed -i.bak "/export MULLV_AUTH=/c\export MULLV_AUTH=\"$MULLV_AUTH\"" "$CONFIG_FILE"
                    fi

                    echo -e "${YELLOW}"

                    # Desloga a conta antiga e autentica com a nova
                    mullvad account logout
                    
                    spinner 1
                    echo -e "\n${GREEN}Authenticating into mullvad $NEW_MULLV_AUTH account...${NC}\n"
    	    	    LOGIN_OUTPUT=$(mullvad account login "$MULLV_AUTH" 2>&1)
    	            LOGIN_STATUS=$?

		    if [ $LOGIN_STATUS -ne 0 ]; then
        		if echo "$LOGIN_OUTPUT" | grep -q "does not exist"; then
            	    	    echo -e "${RED}Error: The account does not exist.${NC}\n"
            	    	    request_new_account_id  # Solicita novo ID se a conta não existir
        		elif echo "$LOGIN_OUTPUT" | grep -q "revoked"; then
            	    	    echo -e "${YELLOW}Account revoked. Please revoke a device to authenticate.${NC}"
            	    	    spinner 2
        		else
            	    	    echo -e "${RED}Failed to set Mullvad account: $LOGIN_OUTPUT.${NC}\n"
            	    	    spinner 2
        		fi
    	    	    fi

                    # Exibe a nova conta ativa
                    echo -e "${GREEN}"
                    mullvad account get
                    mullvad status -v

                    echo -e "${NC}"
                    spinner 1

                    echo -e "${GREEN}Account switched successfully!${NC}\n"

                    # Reinicia o shell e executa o script novamente
                    echo -e "${YELLOW}Restarting shell and restarting script...${NC}"
                    spinner 2
                    exec "$SHELL" "$SCRIPT_PATH"

                    break  # Sai do loop após a autenticação bem-sucedida
                else
                    echo -e "${RED}Invalid ID! The account ID must have exactly 16 digits.${NC}\n"
                fi
            done
}

echo -e "${YELLOW}Checking dependencies:${NC}\n\n"
sleep 0.5

binaries=(mullvad sed grep awk curl bc)
missing_binaries=()

for binary in "${binaries[@]}"; do
    if ! command -v "$binary" &> /dev/null; then
        echo -e "${RED}$binary... NOT FOUND${NC}"
        missing_binaries+=("$binary")
    else
        echo -e "${GREEN}$binary... OK${NC}"
        sleep 0.5
    fi
done

if [ ${#missing_binaries[@]} -ne 0 ]; then
    echo -e "${GREEN}Updating repositories...${NC}\n"
    sudo apt update
    echo "${GREEN}Installing missing binaries: ${NC}${YELLOW}${missing_binaries[*]}${NC}\n"
    sudo apt install -y "${missing_binaries[@]}"
fi

echo -e "\n\n${GREEN}All dependencies are installed. Continuing...${NC}"
spinner 2

# Verify if MULLV_AUTH is set and non-empty
if [ -z "$MULLV_AUTH" ]; then
  echo -e "${RED}\nError: MULLV_AUTH environment variable is not set.${NC}"
  spinner 1
  while true; do
      echo -n -e "${YELLOW}\nPlease enter your Mullvad account ID (16 digits): "
      read MULLV_AUTH
      echo -e "${NC}"
    
      # Verifica se o ID tem exatamente 16 dígitos numéricos
      if [[ "$MULLV_AUTH" =~ ^[0-9]{16}$ ]]; then
          break  # Sai do loop se o ID for válido
      else
          echo -e "${RED}Invalid ID! The account ID must have exactly 16 digits.${NC}\n"
      fi
  done

  if [ -n "$MULLV_AUTH" ]; then
    # Export the variable for the current session
    export MULLV_AUTH="$MULLV_AUTH"

    # Check if the variable is already in the file, to prevent duplicates
    if ! grep -q "export MULLV_AUTH=" "$CONFIG_FILE"; then
      # Append the variable to the shell config file for persistence
      echo "export MULLV_AUTH=\"$MULLV_AUTH\"" >> "$CONFIG_FILE"
      spinner 1
      echo -e "\n${YELLOW}MULLV_AUTH has been set permanently in $CONFIG_FILE.${NC}"
      spinner 1
    else
      echo -e "\n${YELLOW}MULLV_AUTH is already present in $CONFIG_FILE.${NC}"
      # Update the existing value using sed
      sed -i.bak "/export MULLV_AUTH=/c\export MULLV_AUTH=\"$MULLV_AUTH\"" "$CONFIG_FILE"
    fi

    # Reload terminal
    source '$CONFIG_FILE'
  else
    echo -e "\n${RED}No input provided. Exiting.${NC}"
    spinner 1
    exit 1
  fi
else
  echo -e "\n${YELLOW}MULLV_AUTH is already set: $MULLV_AUTH${NC}"
  spinner 1
  show_menu
fi

# Verificar se o script foi executado anteriormente
if [ ! -f "$TEMP_FILE" ]; then
    
    show_menu

    # Criar arquivo indicando que o script foi executado
    touch "$TEMP_FILE"
fi

# Loop de interação com o usuário
temp=true
while $temp; do
    echo -n -e "${PURPLE}MullvScript $: "
    read OPTION
    echo -e "${NC}"
    case $OPTION in
	1)
    	    echo -e "${GREEN}Connecting to VPN...${nc}\n"
    	    spinner 2
    	    LOGIN_OUTPUT=$(mullvad account login "$MULLV_AUTH" 2>&1)
    	    LOGIN_STATUS=$?

    	    if [ $LOGIN_STATUS -ne 0 ]; then
        	if echo "$LOGIN_OUTPUT" | grep -q "does not exist"; then
            	    echo -e "${RED}Error: The account does not exist.${NC}\n"
            	    spinner 1
            	    request_new_account_id
        	elif echo "$LOGIN_OUTPUT" | grep -q "revoked"; then
            	    echo -e "${YELLOW}Account revoked. Please revoke a device to authenticate.${NC}\n"
            	    continue
        	else
            	    echo -e "${RED}Failed to set Mullvad account: $LOGIN_OUTPUT.${NC}\n"
        	fi
        	continue  # Continua no loop
    	    fi

    	    mullvad connect
    	    if [ $? -ne 0 ]; then
        	echo -e "${RED}Failed to connect to Mullvad VPN.${NC}\n"
        	continue
    	    fi
    	    echo -e "${GREEN}Successfully connected to Mullvad VPN!${NC}\n"
    	    ;;

        2)
            mullvad disconnect
            spinner 2
            echo -e "${GREEN}VPN disconnected.${NC}\n"
            ;;

	3)
	    spinner 1
	    echo -e "${YELLOW}\nAvailable regions:${NC}"
            mullvad relay list
    	    while true; do
         	echo -n -e "${YELLOW}Enter the desired region (e.g., se/br): "
        	read REGION
        	echo -e "${NC}"
        	spinner 1
        
        	# Tenta definir a região
        	
        	OUTPUT=$(mullvad relay set location "$REGION" 2>&1)
        	STATUS=$?
        	
        	if [ $STATUS -eq 0 ]; then
            	    echo -e "${GREEN}$OUTPUT${NC}\n"  # Exibe a saída em verde
            	    break  # Sai do loop se a região for válida
        	else
            	    echo -e "${RED}$OUTPUT${NC}\n"  # Exibe a saída em vermelho
            	    echo -e "${RED}Invalid region! Please enter a valid region code.${NC}\n"
        	fi
    	    done
    	    ;;


	4)
	    spinner 1
    	    echo -e "${YELLOW}"
    	    mullvad account list-devices -a "$MULLV_AUTH"
    	    echo -e "\n"
    	    echo -n -e "Enter the user account to revoke: "
    	    read USER_TO_REVOKE
    	    USER_TO_REVOKE=$(echo "$USER_TO_REVOKE" | sed 's/"//g')
    	    REVOCATION_OUTPUT=$(mullvad account revoke-device -a "$MULLV_AUTH" "$USER_TO_REVOKE" 2>&1)

    	    if [ $? -ne 0 ]; then
        	echo -e "${RED}Failed to revoke user $USER_TO_REVOKE: $REVOCATION_OUTPUT.${NC}\n"
        	if echo "$REVOCATION_OUTPUT" | grep -q "does not exist"; then
            	    echo -e "${YELLOW}The account does not exist. Please enter a valid account ID.${NC}"
            	    request_new_account_id  # Solicita novo ID se a conta não existir
        	fi
    	    else
    	    	spinner 1
        	echo -e "${GREEN}User $USER_TO_REVOKE successfully revoked.${NC}\n"
    	    fi
    	    ;;
    	
        5)
            spinner 1
            echo -e "${GREEN}\nAccount Information:"
            mullvad account get
            mullvad status -v
            echo -e "${NC}\n"
            ;;

        6)
            request_new_account_id
            ;;

        7)
            echo -e -n "${YELLOW}Do you want to turn Lockdown mode on or off? (on/off): "
            read LOCKDOWN_RESPONSE
            if [[ "$LOCKDOWN_RESPONSE" == "on" || "$LOCKDOWN_RESPONSE" == "ON" ]]; then
                mullvad lockdown-mode set on
                echo -e "${NC}"
                spinner 1
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Lockdown mode activated.${NC}\n"
                else
                    echo -e "${RED}Failed to activate Lockdown mode.${NC}\n"
                fi
            elif [[ "$LOCKDOWN_RESPONSE" == "off" || "$LOCKDOWN_RESPONSE" == "OFF" ]]; then
                mullvad lockdown-mode set off
                spinner 1
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Lockdown mode deactivated.${NC}\n"
                else
                    echo -e "${RED}Failed to deactivate Lockdown mode.${NC}\n"
                fi
            else
                echo -e "${RED}Invalid option! Please enter 'on' or 'off'.${NC}\n"
            fi
            ;;
            
        8)
            echo -e -n "${YELLOW}Do you want to turn Stealth Mode on or off? (on/off): "
            read STEALTH_MODE
	    echo -e "${NC}"
            if [[ "$STEALTH_MODE" == "on" || "$STEALTH_MODE" == "ON" ]]; then
                echo -e "${GREEN}"
                mullvad bridge set state on
                echo -e "${NC}"
                spinner 2
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Stealth mode (Bridge) turned on.${NC}\n"
                else
                    echo -e "${RED}Failed to turn Stealth mode on.${NC}\n"
                fi
            elif [[ "$STEALTH_MODE" == "off" || "$STEALTH_MODE" == "OFF" ]]; then
                echo -e "${GREEN}"
                mullvad bridge set state off
                echo -e "${NC}"
                spinner 2
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Stealth mode (Bridge) turned off.${NC}\n"
                else
                    echo -e "${RED}Failed to turn Stealth mode off.${NC}\n"
                fi
            else
                echo -e "${RED}Invalid option! Please select 'on' to turn on or 'off' to turn off.${NC}\n"
            fi
            ;;

        9)
            echo -e -n "${YELLOW}Select protocol to use (openvpn/wireguard): "
            read PROTOCOL
	    echo -e "${NC}"
            if [[ "$PROTOCOL" == "openvpn" || "$PROTOCOL" == "OPENVPN" ]]; then
		echo -e "${GREEN}"
                mullvad relay set tunnel-protocol openvpn
                echo -e "${NC}"
                spinner 2
		if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Protocol set to OpenVPN.${NC}\n"
                else
                    echo -e "${RED}Failed to change protocol to OpenVPN.${NC}\n"
                fi
            elif [[ "$PROTOCOL" == "wireguard" || "$PROTOCOL" == "WIREGUARD" ]]; then
                echo -e "${GREEN}"
		mullvad relay set tunnel-protocol wireguard
                echo -e "${NC}"
                spinner 2
		if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Protocol set to WireGuard.${NC}\n"
                else
                    echo -e "${RED}Failed to change protocol to WireGuard.${NC}\n"
                fi
            else
                echo -e "${RED}Invalid option! Please enter 'openvpn' or 'wireguard'.${NC}\n"
            fi
            ;;

        10)
            spinner 1
            show_menu
            ;;
        11)
            spinner 1
            echo -e "${RED}\nExiting...${NC}"
            rm -f "$TEMP_FILE" 
            temp=false  # Sair
            ;;
            
        12)
    	    clear
    	    display_banner
    	    spinner 1
    	    echo -e "\n${YELLOW}---------------------------------------- MullvScript Help Menu ----------------------------------------${NC}\n"
    	    echo -e "${YELLOW}Authors:${NC} ${PURPLE}EndlssNightmare (https://github.com/EndlssNightmare) & SmartFox (https://github.com/Smarttfoxx)${NC}\n"
    	    echo -e "${YELLOW}Description:${NC} MullvScript is a command-line tool designed to manage your Mullvad VPN account interactively and efficiently.\n"
    	    echo -e "\n${YELLOW}Option [01] (Login):${NC}"
    	    echo -e "    Initiates the authentication process using your 16-digit account ID and connects you to the VPN."
    	    echo -e "    Command: mullvad account login [Account_ID]"
    	    echo -e "\n${YELLOW}Option [02] (Logout):${NC}"
    	    echo -e "    Disconnects the currently active VPN session."
    	    echo -e "    Command: mullvad disconnect"
    	    echo -e "\n${YELLOW}Option [03] (Change Region):${NC}"
    	    echo -e "    Lists available regions and allows you to set a new connection region."
    	    echo -e "    Command: mullvad relay set location [region_code]"
    	    echo -e "\n${YELLOW}Option [04] (Revoke Account):${NC}"
    	    echo -e "    Displays devices associated with your account and enables you to revoke access for a selected device."
    	    echo -e "    Command: mullvad account revoke-device [Device_ID]"
    	    echo -e "\n${YELLOW}Option [05] (My Account):${NC}"
    	    echo -e "    Shows detailed information about your account and the current VPN status."
    	    echo -e "    Commands: mullvad account get  |  mullvad status -v"
    	    echo -e "\n${YELLOW}Option [06] (Switch Acc):${NC}"
    	    echo -e "    Prompts you to enter a new account ID, allowing you to switch to another Mullvad account."
    	    echo -e "    Command: request_new_account_id"
    	    echo -e "\n${YELLOW}Option [07] (Lock Mode):${NC}"
    	    echo -e "    Enables or disables Lockdown mode, which blocks network traffic if the VPN connection drops."
    	    echo -e "    Command: mullvad lockdown-mode set [on/off]"
    	    echo -e "\n${YELLOW}Option [08] (Stealth Mode):${NC}"
    	    echo -e "    Activates or deactivates Stealth Mode (Bridge) to help mask VPN traffic for increased privacy."
    	    echo -e "    Command: mullvad bridge set state [on/off]"
    	    echo -e "\n${YELLOW}Option [09] (Change Protocol):${NC}"
    	    echo -e "    Allows you to switch between OpenVPN and WireGuard protocols based on your preference."
    	    echo -e "    Command: mullvad relay set tunnel-protocol [openvpn/wireguard]"
    	    echo -e "\n${YELLOW}Option [10] (Reload Banner):${NC}"
    	    echo -e "    Refreshes the banner and menu, clearing the screen for a renewed view."
    	    echo -e "    Command: show_menu"
    	    echo -e "\n${YELLOW}Option [11] (Exit):${NC}"
    	    echo -e "    Exits the script, removing temporary files and terminating the interactive session."
    	    echo -e "    Command: exit"
    	    echo -e "\n${YELLOW}Option [12] (Help Menu):${NC}"
    	    echo -e "    Displays this detailed help message, explaining all available commands and functionalities."
    	    echo -e "\n${YELLOW}-------------------------------------------------------------------------------------------------------------${NC}\n"
    	    ;;

        *)

            echo -e "${RED}Invalid option! Please choose a valid option.${NC}\n"
            ;;
    esac
  
done
