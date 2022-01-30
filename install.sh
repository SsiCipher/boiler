#!/bin/bash

source "${0%/*}/colors.sh"
BIN="$HOME/bin"

export_default() {
	if [[ $(grep -c "export $1" $HOME/.zshrc) -eq 0 ]]; then
		echo -e "\nexport $1=\"$2\"" >> $HOME/.zshrc
	else
		sed -i "s&$1=\".*\"&$1=\"$2\"&" $HOME/.zshrc
		# 👇 Alternative :
		# cat $HOME/.zshrc | sed "s&$1=\".*\"&$1=\"$DIR\"&" > $HOME/.zshrc
	fi
}

config_boiler() {
	echo -n -e "💬 ${LIGHT_GRAY}Absolute path to your projects directory: ${NC}";
	read DIR;

	if [[ ! -z $DIR ]]; then
		if [[ ! -e $DIR ]]; then
			echo -n -e "⛔ ${LIGHT_RED}Directory not found${NC}, Do you want us to create it [y/n]: ";
			read -n 1 create_dir
			echo ""

			if [[ $create_dir == 'y' ]] && mkdir $DIR; then
				echo -e "${GREEN}Using directory: $DIR${NC}"
				export_default 'BOILER_PROJS_DIR' $DIR
			else
				echo -e "${LIGHT_BLUE}Will use default $HOME/Projects${NC}"
			fi
		else
			echo -e "${GREEN}Using directory: $DIR${NC}"
			export_default 'BOILER_PROJS_DIR' $DIR
		fi
	else
		echo -e "${LIGHT_BLUE}Will use default $HOME/Projects${NC}"
	fi
}

install_boiler() {
	if [[ ! -e "$BIN" ]]; then
		mkdir $BIN
		export_default 'PATH' "$BIN:\$PATH"
	fi

	if [[ -e "$BIN/boiler" ]]; then
		rm -rf $BIN/boiler;
		echo -e "${LIGHT_BLUE}🚮 Delete old boiler!${NC}"
	fi

	if [[ ! -e "$HOME/.boiler" ]]; then
		mkdir $HOME/.boiler
		cp ./templates/* $HOME/.boiler
		echo -e "${LIGHT_GREEN}Copied templates${NC}"
	fi

	chmod 755 boiler.sh
	cp ./boiler.sh $BIN/boiler

	echo -e "${LIGHT_GREEN}✅ Boiler installed successfuly!${NC}"
}

config_boiler
install_boiler
zsh
