. "utils.sh"

cwd="$(cd "$(dirname "$0")" && pwd)"
workstation_dir="$HOME/.workstation"

ask_move_dotfiles() {
    if [ ! -d $workstation_dir ]; then
        mkdir $workstation_dir
        move_dotfiles;

        print_success "$workstation_dir created and dotfiles moved"
    else
        if ask "Replace existing dotfiles in your home directory?" Y; then
            move_dotfiles;
            print_success "Dotfiles moved"
        else
            print_success_muted "Not moving dotfiles";
        fi
    fi
}

move_dotfiles() {
    mkdir -p $workstation_dir/.custom-packages
    cp $cwd/.packages $workstation_dir/.packages
    cp $cwd/.directories $workstation_dir/.setup_directories
    cp -r $cwd/.custom-packages/* $workstation_dir/.custom-packages
}

# add_brew_taps() {
#     if [ -e $workstation_dir/.taps ]; then
#         taps=$(brew tap-info --installed)
#         for tap in $(<$workstation_dir/.taps); do
#             if [[ ! $(echo $taps | grep $tap) ]]; then
#                 echo_install "Tapping $tap"
#                 brew tap $tap >/dev/null
#                 print_success "$tap tapped!"
#             else
#                 print_success_muted "$tap already tapped. Skipped."
#             fi
#         done
#     fi
# }
install_packages() {
    echo_install "Updating apt-get"
    sudo apt-get update >/dev/null
    print_success "apt-get updated!"

    if [ -e $workstation_dir/.packages ]; then
        for package in $(<$workstation_dir/.packages); do
                echo_install "Installing $package"
                sudo apt-get install -y $package >/dev/null
                print_success "$package installed!"
        done
    fi
}

install_custom_packages() {
    if [ -e $workstation_dir/.custom-packages ]; then
        for custom_package in $workstation_dir/.custom-packages/*.sh; do
            echo_install "Installing $custom_package"
            bash $custom_package
            print_success "$custom_package installed!"
        done
    fi
}


upgrade_packages() {
    sudo apt-get -y upgrade
}

setup_directories() {
    if [ -e $workstation_dir/.directories ]; then
        for directory_s in $(<$workstation_dir/.directories); do
            directory=$(eval echo $directory_s)
            if [ ! -d $directory ]; then
                mkdir -p $directory
                print_success "$directory created!"
            else
                print_success_muted "Directory $directory already exists. Skipping"
            fi
        done
    fi
}

check_internet_connection() {
    if [ ping -q -w1 -c1 google.com &>/dev/null ]; then
        print_error "Please check your internet connection";
        exit 0
    else
        print_success "Internet connection";
    fi
}