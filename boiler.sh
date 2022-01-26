#!/bin/bash

NC='\033[0m'
Black='\033[0;30m'
Dark_Gray='\033[1;30m'
Red='\033[0;31m'
Light_Red='\033[1;31m'
Green='\033[0;32m'
Light_Green='\033[1;32m'
Orange='\033[0;33m'
Yellow='\033[1;33m'
Blue='\033[0;34m'
Light_Blue='\033[1;34m'
Purple='\033[0;35m'
Light_Purple='\033[1;35m'
Cyan='\033[0;36m'
Light_Cyan='\033[1;36m'
Light_Gray='\033[0;37m'
White='\033[1;37m'

if [[ -z $BOILER_PROJS_DIR ]]; then
  DIR="$HOME/Cursus";
else 
  DIR=$BOILER_PROJS_DIR;
fi

create_dir() {
	if [[ -e "$DIR/$1" ]]; then
		echo -e "📂 ${Light_Gray}Project exists already 😒${NC}"
	else
		echo -e "📂 ${Light_Gray}Creating project directory in: $DIR 😎${NC}"
		mkdir "$DIR/$1"
	fi
	echo ""
}

init_repo() {
	if [[ -e "$DIR/$1/.git" ]]; then
		echo -e "🐙 ${Light_Cyan}Folder is already a Git repo${NC}"
	else
		echo -e "🐙 ${Light_Cyan}Init a Git repository${NC}"
		git init "$DIR/$1"
	fi
	echo ""
}

add_repo_files() {
	if [[ -e "$DIR/$1/README.md" ]]; then
		echo -e "📄 ${Light_Purple}README.md file exists already${NC}"
	else
		echo -e "📄 ${Light_Purple}Creating a README.md file${NC}"
		echo "# $1" > "$DIR/$1/README.md"
		echo -n "Project Description: "
		read DESC
		echo -e "\n$DESC" >> "$DIR/$1/README.md"
	fi

	if [[ -e "$DIR/$1/.gitignore" ]]; then
		echo -e "📄 ${Light_Purple}.gitignore file exists already${NC}"
	else
		echo -e "📄 ${Light_Purple}Creating a .gitignore file${NC}"
		cp .gitignore_template "$DIR/$1/.gitignore"
	fi
	echo ""
}

create_folders() {
	if [[ ! -e "$DIR/$1/src" ]]; then
		mkdir "$DIR/$1/src"
	fi
	if [[ ! -e "$DIR/$1/includes" ]]; then
		mkdir "$DIR/$1/includes"
	fi
	if [[ ! -e "$DIR/$1/libs" ]]; then
		mkdir "$DIR/$1/libs"
	fi
}

create_main_files() {
	if [[ ! -e "$DIR/$1/includes/$1.h" ]]; then
		echo "#ifndef ${1^^}_H" > "$DIR/$1/includes/$1.h"
		echo "# define ${1^^}_H" >> "$DIR/$1/includes/$1.h"
		echo "" >> "$DIR/$1/includes/$1.h"
		echo "#endif" >> "$DIR/$1/includes/$1.h"
	fi
	if [[ ! -e "$DIR/$1/$1.c" ]]; then
		echo "#include \"includes/$1.h\"" > "$DIR/$1/$1.c"
	fi
}

create_makefile() {
	if [[ ! -e "$DIR/$1/Makefile" ]]; then
		echo "" > "$DIR/$1/Makefile"
	fi
}

clone_libs() {
	local gh_profile="https://github.com/SsiCipher"

	if [[ ! -e "$DIR/$1/libs/libft" ]]; then
		echo -n -e "👉 Clone ${Blue}libft${NC} 🤔? [y/n]: "
		read -n 1 libft
		echo ""
		if [[ $libft == 'y' ]]; then
			echo -e "✅ ${Green}Cloning libft...${NC}"
			git clone "$gh_profile/libft" "$DIR/$1/libs/libft"
		fi
	fi

	if [[ ! -e "$DIR/$1/libs/libftprintf" ]]; then
		echo -n -e "👉 Clone ${Blue}ft_printf${NC} 🤔? [y/n]: "
		read -n 1 ft_printf
		echo ""
		if [[ $ft_printf == 'y' && ! -e "$DIR/$1/libs/libftprintf" ]]; then
			echo -e "✅ ${Green}Cloning printf...${NC}"
			git clone "$gh_profile/ft_printf" "$DIR/$1/libs/libftprintf"
		fi
	fi

	if [[ ! -e "$DIR/$1/libs/libgnl" ]]; then
		echo -n -e "👉 Clone ${Blue}libgnl${NC} 🤔? [y/n]: "
		read -n 1 libgnl
		echo ""
		if [[ $libgnl == 'y' ]]; then
			echo -e "✅ ${Green}Cloning libgnl...${NC}"
			git clone "$gh_profile/get_next_line" "$DIR/$1/libs/libgnl"
		fi
	fi

	find "$DIR/$1/libs" -name ".git" -exec rm -rf {} \; 2>/dev/null
	find "$DIR/$1/libs" -name ".gitignore" -exec rm -rf {} \; 2>/dev/null
	find "$DIR/$1/libs" -name "README.md" -exec rm -rf {} \; 2>/dev/null

	find "$DIR/$1/libs" -name "*.h" -exec cp {} "$DIR/$1/includes" \; 2>/dev/null
	echo ""
}

if [[ -z $1 ]]; then
	echo -e "✨ ${Red}😡 Enter a project name!!!${NC}"
else
	echo "✨ Creating project [>$1<] in $DIR 🥳"
	echo ""
	create_dir $1
	init_repo $1
	add_repo_files $1
	create_folders $1
	create_main_files $1
	create_makefile $1
	clone_libs $1
	echo "👍 Project Created successfully, Happy coding"
fi
