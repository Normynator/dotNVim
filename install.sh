#!/bin/bash

# Config Start =======================================================
OVERWRITE=0
INSTALL_PATH="$HOME/.config/nvim"
AUTOCREATE=1
# Config End =========================================================

install () {
	# Clone vundle as plugin manager
	git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
	
	files=(bundle/Vundle.vim/*)
	if [ ! ${#files[@]} -gt 0 ]; then
		echo "No files after clone. Aborting."
		exit 0
	fi

	# Check if nvim folder already exists for user and if overwriting 
	# is allowed!
	if [ $OVERWRITE -eq 0 ] && [ -d $INSTALL_PATH ]; then
		echo "$INSTALL_PATH does already exist. Stopping installation!"
		exit 0
	fi
	
	# Check if nvim folder exists and if we should create it
	if [ $AUTOCREATE -eq 1 ] && [ ! -d $INSTALL_PATH ]; then
		mkdir $INSTALL_PATH
	fi
	
	# Check if folder exists before copying.
	if [ ! -d $INSTALL_PATH ]; then
		echo "$DIRECOTRY does not exist and was not auto created!"
		exit 0
	fi
	cp -r * $INSTALL_PATH
}

generate () {
	if [ -f "config/python.nvim" ]; then
		rm config/python.nvim
	fi
	py3_path="$(which python3.6)"
	py2_path="$(which python2)"
	echo '" This is used to set the python paths for nvim' >> config/python.nvim
    echo "let g:python3_host_prog = '$py3_path'" >> config/python.nvim
	echo "let g:python_host_prog = '$py2_path'" >> config/python.nvim
}

# Setting/checking constants before running main function.
if [ -z $HOME ]; then
	echo "Variable HOME was not set. Abort!"
	exit 0
fi

# Checking for required installations.
command -v python3.6 >/dev/null 2>&1 || { echo >&2 "Python 3.6 was not found. Aborting."; exit 0; }
command -v git >/dev/null 2>&1 || { echo >&2 "Git was not found. Aborting."; exit 0; }

echo "Install path set to: $INSTALL_PATH"

generate "$@"
install "$@"
