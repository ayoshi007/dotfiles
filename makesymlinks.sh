#!/bin/bash

##### VARIABLES
DIR=~/dotfiles
BACKUP_DIR=~/dotfiles_bak
FILES="bashrc vimrc vim tmux.conf"


### Create backup dotfiles folder
echo -n "Creating $BACKUP_DIR to hold backup copies of existing dotfiles... "
mkdir -p $BACKUP_DIR
echo "done"

### Move to dotfiles folder
echo -n "Change to $DIR directory... "
cd $DIR
echo "done"

### Create symlinks to files
for file in $FILES; do
    echo "Moving any existing $file dotfile from ~ to $BACKUP_DIR..."
    mv ~/.$file ~/$BACKUP_DIR/
    echo "\tCreating symlink to $file in home directory..."
    ln -s $dir/$file ~/.$file
    echo "\t\tDone"
done

