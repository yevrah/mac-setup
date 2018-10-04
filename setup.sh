#!/bin/bash
#set -x

echo "Mac Mojave Automated Setup"

# Homebrew section
echo "Installing HomeBrew"
if test ! $(which brew)
then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
fi

echo "Updating existing homebrew recpies"
brew update

echo "Upgrading existing installed formulas"
brew upgrade --all

echo "Installed from packages.txt list"
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.brew.txt | xargs brew install

echo "Install brew cask plugin"
brew tap caskroom/cask

echo "Installed from packages.cask.txt list"
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.cask.txt | xargs brew cask install

# Install mas-cli using below when 1.42 is released
#   echo "Installing mas-cli tool for app store packages"
#   brew install mas

# We need to install mas-cli v 1.42 which is not yet on brew
cd ~/Downloads
curl -LO https://github.com/mas-cli/mas/releases/download/v1.4.2/mas-cli.zip
unzip mas-cli.zip
mv mas /usr/local/bin/.
rm mas-cli.zip

echo "Please log into the Mac App Store"
open -a '/Applications/App Store.app'

until (mas account > /dev/null);
do
    sleep 3
done

echo "Installing from packages.mas.txt list"
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.mas.txt | sed 's/ .*//' | xargs mas install
