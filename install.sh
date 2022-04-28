#!/bin/bash

source "${0%/*}/colors.sh"
BOILER_DIR="$HOME/.boiler"
SHELL_CONFIG=$(echo -n "$SHELL" | cut -d / -f 3)
SHELL_CONFIG="${HOME}/.${SHELL_CONFIG}rc"

export_var() {
	if [[ $(grep -c "export $1=$2" < "$SHELL_CONFIG") -eq 0 ]]; then
		echo -e "export $1=$2" >> "$SHELL_CONFIG"
		echo -e "${LIGHT_GREEN}✅ Added $1 to $SHELL_CONFIG${NC}"
	else
		echo -e "${LIGHT_GRAY}✅ Remove $1 from $SHELL_CONFIG first${NC}"
	fi
}

config_boiler() {
	echo -n -e "💬 ${LIGHT_GRAY}Projects directory path: ${NC}";
	read -p "$HOME/" DIR;

	if [[ ! -z $DIR ]]; then
		if [[ ! -d "$HOME/$DIR" ]]; then
			echo -n -e "⛔ ${LIGHT_RED}Directory not found${NC}, Do you want us to create it [y/n]: ";
			read -n 1 create_dir
			echo ""

			if [[ $create_dir == 'y' ]] && mkdir "$HOME/$DIR"; then
				export_var 'BOILER_PROJS_DIR' "$HOME/$DIR"
				echo -e "${GREEN}Using directory: "$HOME/$DIR"${NC}"
			else
				echo -e "${LIGHT_BLUE}Will use default $HOME/Desktop${NC}"
			fi
		else
			export_var 'BOILER_PROJS_DIR' "$HOME/$DIR"
			echo -e "${GREEN}Using directory: "$HOME/$DIR"${NC}"
		fi
	else
		echo -e "${LIGHT_BLUE}Will use default $HOME/Desktop${NC}"
	fi
}

install_boiler() {
	if [[ -d $BOILER_DIR ]]; then
		rm -rf $BOILER_DIR;
		echo -e "${LIGHT_BLUE}🚮 Delete old boiler!${NC}"
	fi

	if [[ ! -d $BOILER_DIR ]]; then
		mkdir $BOILER_DIR
		export_var 'PATH' '$HOME/.boiler:$PATH'
		cp ./templates/* $BOILER_DIR
		echo -e "${LIGHT_GREEN}📋 Copied templates to $BOILER_DIR${NC}"
		cp ./boiler.sh $BOILER_DIR/boiler
		chmod +x $BOILER_DIR/boiler
	fi

	echo -e "${LIGHT_GREEN}✅ Boiler installed successfuly!${NC}"
}

config_boiler
install_boiler
zsh
