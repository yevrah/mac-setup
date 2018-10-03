#!/bin/bash
set -x

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
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.txt | xargs brew install

echo "Install brew cask plugin"
brew tap caskroom/cask

echo "Installed from packages.cask.txt list"
curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.cask.txt | xargs brew cask install

echo "Installing mas-cli tool for app store packages"
brew install mas

echo "Installing from packages.mas.txt list"
cat packages.mas.txt | sed 's/ .*//' | xargs mas install
