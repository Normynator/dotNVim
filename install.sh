#!/bin/bash

# Config Start =======================================================
OVERWRITE=1
INSTALL_PATH="$HOME/.config/nvim"
AUTOCREATE=1
# Config End =========================================================

# Check successful clone.
check_clone () {
	files=($1)
	if [ ! ${#files[@]} -gt 0 ]; then
		echo "No files after clone. Aborting."
		exit 0
	fi
}

# Installs neovim related things and copies config into the right spot.
install () {
	# Clone vundle as plugin manager
	files=(bundle/Vundle.vim/*)
	if [ ! ${#files[@]} -gt 0 ]; then
		git clone https://github.com/VundleVim/Vundle.vim.git bundle/Vundle.vim
		check_clone "bundle/Vundle.vim/*"	
	else
		echo "Vundle files do already exist, skip cloning"
	fi
	
	# Install language client
	files=(bundle/LanguageClient-neovim/*)
	if [ ! ${#files[@]} -gt 0 ]; then
		git clone --depth 1 https://github.com/autozimu/LanguageClient-neovim.git bundle/LanguageClient-neovim
		check_clone "bundle/LanguageClient-neovim/*"
		cd bundle/LanguageClient-neovim
		bash install.sh
		cd ../..
	else
		echo "LanguageClient files do already exist, skip cloning and install."
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
		echo "$INSTALL_PATH does not exist and was not auto created!"
		exit 0
	fi
	cp -r * $INSTALL_PATH
}

# Generates subconfigs for nvim
generate () {
	# python.nvim
	MP="config/python.nvim"
	py3_path="$(which python3.5)"
	py2_path="$(which python2)"
	echo '" This is used to set the python paths for nvim' > $MP
    echo "let g:python3_host_prog = '$py3_path'" >> $MP
	echo "let g:python_host_prog = '$py2_path'" >> $MP
	echo "Found python3 at $py3_path"
	echo "Found python2 at $py2_path" 
	
	# chromatica.nvim
	MP="config/chromatica.nvim"
	if [ -d "/usr/lib/llvm-3.8/lib" ]; then
		echo "let g:chromatica#libclang_path = '/usr/lib/llvm-3.8/lib'" > $MP
	else
		echo "libclang not found. Aborting."
		exit 0
	fi
	echo "let g:chromatica#enable_at_startup = 1" >> $MP

	# lang server
	MP="config/langserver.nvim"
	echo "let g:LangaugeClient_autoStart = 1" > $MP
	echo "let g:LanguageClient_settingsPath = $HOME.'/.config/nvim/settings.json'" >> $MP
	echo "let g:LanguageClient_loadSettings = 1" >> $MP
	echo "let g:LanguageClient_logginLevel = 'DEBUG'" >> $MP
	echo "let g:LanguageClient_serverCommands = {" >> $MP
	echo "\ 'cpp': ['/Users/normanziebal/cquery/build/release/bin/cquery', '--log-file=/tmp/cq.log']," >> $MP
	echo "\ 'python': ['pyls', '-v']," >> $MP
	echo "\ }" >> $MP


}

# Checks for all required dependencies and tries to install them.
setup () {
    # Setting/checking constants before running main function.
    if [ -z $HOME ]; then
    	echo "Variable HOME was not set. Abort!"
    	exit 0
    fi
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
        echo "Detected $OS $VER"
    else
        echo "Failed to detect system. Aborting."
        exit 0;
    fi
    
    # Check for supported OS
    if [ "$OS" == "Debian GNU/Linux" ]; then
        if [ ! $VER -eq 9 ]; then
    	echo "OS version is not supported! Aborting."
    	exit 0
        fi
    else
        echo "OS is not supported. Aborting."
        exit 0
    fi 
    
    sudo apt-get install build-essential git python3 python3-pip cmake pkg-config libtool-bin unzip m4 autotools-dev automake gettext libclang-dev
    
    # Checking for required installations.
    command -v python3.5 >/dev/null 2>&1 || { echo >&2 "Python 3.5 was not found. Aborting."; exit 0; }
    command -v git >/dev/null 2>&1 || { echo >&2 "Git was not found. Aborting."; exit 0; }
    command -v pip3 >/dev/null 2>&1 || { echo >&2 "pip3 was not found. Aborting."; exit 0; }
    command -v cmake >/dev/null 2>&1 || { echo >&2 "cmake was not found. Aborting."; exit 0; }
   	
	if [ -f /usr/bin/nvim ]; then
		echo "neovim was already installed. Skip compiling."
	else
        git clone https://github.com/neovim/neovim.git
        cd neovim
        make CMKAE_BUILD_TYPE=Release
        sudo make install
        cd ..
        cp /usr/local/bin/nvim /usr/bin/nvim
	fi
    
    echo "Install path set to: $INSTALL_PATH"
}

setup "$@"
generate "$@"
install "$@"


