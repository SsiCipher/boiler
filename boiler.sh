#!/bin/bash

source "${0%/*}/colors.sh"
if [[ -z $BOILER_PROJS_DIR ]]; then
    DEFAULT_DIR="$HOME/Projects";
else 
    DEFAULT_DIR=$BOILER_PROJS_DIR;
fi
GITIGNORE_TEMPLATE="${0%/*}/templates/gitignore.template"
MAKEFILE_TEMPLATE="${0%/*}/templates/makefile.template"
GH_PROFILE="https://github.com/SsiCipher"

create_dir() {
	if [[ -e "$DEFAULT_DIR/$1" ]]; then
		echo -e "📂 ${LIGHT_GRAY}Project exists already 😒${NC}"
		return 1
	else
		mkdir "$DEFAULT_DIR/$1"
		echo -e "📂 ${LIGHT_GRAY}Created project directory $DEFAULT_DIR/$1${NC}\n"
		return 0
	fi
}

init_repo() {
	if [[ -e "$DEFAULT_DIR/$1/.git" ]]; then
		echo -e "🐙 ${BLUE}Folder is already a Git repo${NC}\n"
	else
		git init "$DEFAULT_DIR/$1" 1>/dev/null
		echo -e "🐙 ${BLUE}Initialized a Git repository in $DEFAULT_DIR/$1${NC}\n"
	fi
}

add_repo_files() {
	if [[ -e "$DEFAULT_DIR/$1/README.md" ]]; then
		echo -e "📄 ${LIGHT_PURPLE}README.md file exists already${NC}"
	else
		echo -n "Project Description: "
		read DESC
		echo ""
		echo "# $1" > "$DEFAULT_DIR/$1/README.md"
		echo -e "\n$DESC" >> "$DEFAULT_DIR/$1/README.md"
		echo -e "📄 ${LIGHT_PURPLE}Created README.md file${NC}"
	fi

	if [[ -e "$DEFAULT_DIR/$1/.gitignore" ]]; then
		echo -e "📄 ${LIGHT_PURPLE}.gitignore file exists already${NC}"
	else
		cp $GITIGNORE_TEMPLATE "$DEFAULT_DIR/$1/.gitignore"
		echo -e "📄 ${LIGHT_PURPLE}Created .gitignore file${NC}"
	fi
	echo ""
}

create_folders() {
	if [[ ! -e "$DEFAULT_DIR/$1/src" ]]; then
		mkdir "$DEFAULT_DIR/$1/src"
		echo -e "📂 ${LIGHT_GREEN}Created 'src' folder${NC}"
	fi

	if [[ ! -e "$DEFAULT_DIR/$1/includes" ]]; then
		mkdir "$DEFAULT_DIR/$1/includes"
		echo -e "📂 ${LIGHT_GREEN}Created 'includes' folder${NC}"
	fi

	if [[ ! -e "$DEFAULT_DIR/$1/libs" ]]; then
		mkdir "$DEFAULT_DIR/$1/libs"
		echo -e "📂 ${LIGHT_GREEN}Created 'libs' folder${NC}"
	fi

	echo ""
}

clone_libs() {
	if [[ ! -e "$DEFAULT_DIR/$1/libs/libft" ]]; then
		echo -n -e "👉 Clone ${ORANGE}libft${NC} 🤔? [y/n]: "
		read -n 1 libft
		echo ""
		if [[ $libft == 'y' ]]; then
			git clone "$GH_PROFILE/libft" "$DEFAULT_DIR/$1/libs/libft" 2>/dev/null
			echo -e "✅ ${GREEN}Added libft to libs folder${NC}"
		fi
	fi

	if [[ ! -e "$DEFAULT_DIR/$1/libs/libftprintf" ]]; then
		echo -n -e "👉 Clone ${ORANGE}ft_printf${NC} 🤔? [y/n]: "
		read -n 1 ft_printf
		echo ""
		if [[ $ft_printf == 'y' && ! -e "$DEFAULT_DIR/$1/libs/libftprintf" ]]; then
			git clone "$GH_PROFILE/ft_printf" "$DEFAULT_DIR/$1/libs/libftprintf" 2>/dev/null
			echo -e "✅ ${GREEN}Added ft_printf to libs folder${NC}"
		fi
	fi

	if [[ ! -e "$DEFAULT_DIR/$1/libs/libgnl" ]]; then
		echo -n -e "👉 Clone ${ORANGE}libgnl${NC} 🤔? [y/n]: "
		read -n 1 libgnl
		echo ""
		if [[ $libgnl == 'y' ]]; then
			git clone "$GH_PROFILE/get_next_line" "$DEFAULT_DIR/$1/libs/libgnl" 2>/dev/null
			echo -e "✅ ${GREEN}Added get_next_line to libs folder${NC}"
		fi
	fi

	echo ""

	find "$DEFAULT_DIR/$1/libs" -name ".git" -exec rm -rf {} \; 2>/dev/null
	find "$DEFAULT_DIR/$1/libs" -name ".gitignore" -exec rm -rf {} \; 2>/dev/null
	find "$DEFAULT_DIR/$1/libs" -name "README.md" -exec rm -rf {} \; 2>/dev/null

	find "$DEFAULT_DIR/$1/libs" -name "*.h" -exec cp {} "$DEFAULT_DIR/$1/includes" \; 2>/dev/null
}

create_main_files() {
	if [[ ! -e "$DEFAULT_DIR/$1/includes/$1.h" ]]; then
		echo -e "#ifndef ${1^^}_H\n# define ${1^^}\n\n$(ls $DEFAULT_DIR/$1/includes | awk '{printf("# include \"%s\"\n", $1)}')\n\n#endif" > "$DEFAULT_DIR/$1/includes/$1.h"
	fi

	if [[ ! -e "$DEFAULT_DIR/$1/$1.c" ]]; then
		echo -n -e "${YELLOW}Main source file name (${DARK_GRAY}$1.c${YELLOW}): ${NC}"
		read name
		if [[ -z $name ]]; then
			echo "#include \"includes/$1.h\"" > "$DEFAULT_DIR/$1/$1.c"
		else
			echo "#include \"includes/$1.h\"" > "$DEFAULT_DIR/$1/$name.c"
		fi
	fi

	echo ""
}

create_makefile() {
	if [[ ! -e "$DEFAULT_DIR/$1/Makefile" ]]; then
		cp $MAKEFILE_TEMPLATE "$DEFAULT_DIR/$1/Makefile"
	fi
}

if [[ -z $1 ]]; then
	echo -e "✨ ${RED}😡 Enter a project name!!!${NC}"
else
	echo -e "✨ ${GRAY}Creating project '$1' in $DEFAULT_DIR 🥳${NC}"
	echo ""
	if create_dir $1; then
		init_repo $1
		add_repo_files $1
		create_folders $1
		clone_libs $1
		create_main_files $1
		create_makefile $1
		echo -e "👍 ${GRAY}Project Created successfully, Happy coding${NC}"
	fi
fi
