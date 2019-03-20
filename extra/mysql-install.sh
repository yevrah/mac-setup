#!/bin/bash

printf "\n"
printf "********************************************************************************\n\n"
printf "                            __  __       ____   ___  _                          \n"
printf "                           |  \/  |_   _/ ___| / _ \| |                         \n"
printf "                           | |\/| | | | \___ \| | | | |                         \n"
printf "                           | |  | | |_| |___) | |_| | |___                      \n"
printf "                           |_|  |_|\__, |____/ \__\_\_____|                     \n"
printf "                                   |___/  install and setup                     \n\n"
printf "********************************************************************************\n\n"

printf "Installing mysql using brew..\n\n"
brew install mysql

printf "\n\nIsntalling brew services management..\n\n"
brew tap homebrew/services

printf "\n\nStarting mysql.."
brew services start mysql

printf "\n\nChecking version.."
mysql -V

printf "\n\nSeriously... dont forget to run mysql_secure_installation\n\n"
