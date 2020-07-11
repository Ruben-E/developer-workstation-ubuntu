#!/bin/bash

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

sudo chsh -s $(which zsh)
sudo usermod -s $(which zsh) $(whoami)