#!/bin/bash

. ./utils.sh
read -p "Enter email: " user_email
echo "Generating ED25519 ssh key for ${user_email}"
ssh-keygen -t ed25519 -C "${user_email}"
yes_or_none "Add key to ssh-agent?" || exit 1
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

