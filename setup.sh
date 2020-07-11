#!/bin/bash

source ./utils.sh
source ./logic.sh

# 
# Prepare
# 
title "Preparing"

chapter "Checking internet connection..."
check_internet_connection

chapter "Move dotfiles"
ask_move_dotfiles

# 
# Packages
# 
title "Packages"

chapter "Install packages"
install_packages

chapter "Install custom packages"
install_custom_packages

chapter "Upgrade packages"
upgrade_packages

# 
# Directories
# 
title "Directories"
setup_directories