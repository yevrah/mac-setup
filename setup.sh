#!/bin/bash

################ mac software build out ################
##       _           _ _     _             _          ##
##      | |__  _   _(_) | __| | ___  _   _| |_        ##
##      | '_ \| | | | | |/ _' |/ _ \| | | | __|       ##
##      | |_) | |_| | | | (_| | (_) | |_| | |_        ##
##      |_.__/ \__,_|_|_|\__,_|\___/ \__,_|\__|       ##
##                                               v0.1 ##
########################################################

#
# PRINT WELCOME MESSAGE (SCRIPT HEADER ABOVE)
#
grep "\##" $0 | grep -v "grep"


#
# STEP 1: INSTALL AND UPDATE COMMAND LINE TOOLS
#
echo "Installing HomeBrew"
if test ! $(which brew)
then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


echo "Updating existing homebrew receipes and formulas"
brew update
brew upgrade --all


echo "Installed from packages.txt list"
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.brew.txt | xargs brew install


#
# STEP 2: INSTALL GUI APPS
#
echo "Install brew cask plugin"
brew tap caskroom/cask


echo "Installed from packages.cask.txt list"
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.cask.txt | xargs brew cask install


#
# STEP 3: INSTALL APP STORE APPS
#

# Install mas-cli using below when 1.42 is released
echo "Installing mas-cli tool for app store packages"
brew install mas


# We need to install mas-cli v 1.42 which is not yet on brew, this is necessary
# as Apple removed command line signing in in High Sierra.
echo "Installing the mas-cli tool 1.42"
cd ~/Downloads
curl -LO https://github.com/mas-cli/mas/releases/download/v1.4.2/mas-cli.zip
unzip mas-cli.zip
mv -f mas /usr/local/bin/.
rm mas-cli.zip

echo ""
echo "Please log into the Mac App Store"
open -a '/Applications/App Store.app'

until (mas account > /dev/null); do
    sleep 3
done


echo "Installing from packages.mas.txt list"
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.mas.txt | sed 's/ .*//' | xargs mas install


#
# FINALISE
#

# Remove brew leftovers
echo "Cleanup brew left overs"
brew cleanup
brew cask cleanup
