A Complete Mac Setup (mostly)
=============================

The repositry contains an automated Mac buit out process targeting OSX High Sierra.
The goal is to have as much as possible automated in an attempt to do a fresh
install and have a clean build with little downtime.

This project only looks to get software installed, for settings and dotfiles
look to the dotfiles project.

The following sections detail how to setup *command line* tools using `brew`,
*GUI tools* such as Sequel Pro, Skype, etc using `brew cask` and App Store
software using `mas-cli`.


Creating an Automated Build-Out
===============================


## Step 1: Running the build out


Run this code using the following command from the terminal inside your Mojave
virtual machine:

    $ curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/setup.sh | /bin/bash

We added some additional flags to make curl a little more silent. Specifically
`-sS` which forces silent mode (`-s`), the `S` option when combined with silent
mode will show any errors if the request fails.

Future: In some cases you may want to pass in additional parameters to your
script, for example you may want to pass in your Apple Id, in this scenario you
would use the following syntax:

    curl -sS htt.... | bash -s arg1 arg2


## Step 2: The Homebrew Workhorse


We'll be using `brew` (short for homebrew) to do all the heavy lifting, it's
the defacto package manager for Mac. if your not familiar with it head over to
their [website](https://docs.brew.sh/). Homebrew is installed by adding the
following to the `install.sh`:

    echo "Installing HomeBrew"
    if test ! $(which brew)
    then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
    fi

Because we don't want to coniniously reset our vm we added a quick check to see
if it exists and skip or else install. This will be a common theme throughout
our build out process, it also allows us to use the same script to continue to
upgrade and update out machine. By doing this we in theory could do a full
system reset in minimal time.

In addiotn the following lines are added as well, it will help keeping our
machine up to date.


    echo "Updating existing homebrew recpies and formulas"
    brew update
    brew upgrade --all

## Step 3: Installing packages

We are now ready to install
packages. If you have an existing homebrew system you can export your packages
using `brew list > packages.txt`. You'll probably have some items that are no
longer relevant, now is the time to cleanup this list.

Note that there are a bunch of default packages listed in this repo - you may
want ot change to suit your needs.

You can now simply list a bunch of home brew isntalls using the following syntax

    echo "Manually installed packages"
    brew install wget
    brew install git
    ... and so on

I preferr to instead just install from the list in packages.txt, this allows me
to modify my installation library without having to touch source code. We'll be
using xargs to build the install commands which is already in the script:

    echo "Installed from packages.txt list"
    curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.txt | xargs brew install


## Step 4: Gui Packages with Homebrew Cask

The *Cask* extension for Homebrew offers a way to install graphical
applications such as browsers, video players, and much more. It can be
isntalled simply by adding the following command to our script:

    brew tap caskroom/cask

You can find packages using `brew search` as in the example below:

    $ brew search vlc
    ==> Casks
    vlc
    vlc-webplugin
    vlcstreamer
    homebrew/cask-versions/vlc-nightly

Installation of packages can be done by adding `brew cask install vlc` as an
example. But again, it's easier and nicer to just put all the applicates into
an `packages.cask.txt` file and installing with:

    
    echo "Installing from packages.cask.txt list"
    curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.cask.txt | xargs brew install

## Step 5: Apple Store Packages with mas-cli

Note: As off High Sierra mas-cli has been brokern due to change in the App
Store api. This issue can be tracked here: https://github.com/mas-cli/mas/issues/164

Unfortunately cask doesnt handle all gui apps, particularly ones from the app
store. You can install this utility with `brew install mas`. This will give you
a simple command line tool for the App Store. If you have an existing mac you
can use it to get a list of existing apps

    $ mas list
    497799835 Xcode (10.0)
    409203825 Numbers (5.2)
    409183694 Keynote (8.2)

Go ahead and copy this to a file called `packages.mas.txt`. We're going to run it with:

    echo "Installing from packages.mas.txt list"
    cat packages.mas.txt | sed 's/ .*//' | xargs mas install

Notice the addition of the `sed` command. The mas-cli tools doesnt know what to
do with the text part of the package, it only takes the identifier as input.
But for the sake of maintenance we have kept the description in. The
additional commands just removes the space and everything else after it
before sending it through.

    
# Step X: Cleanup

    # Remove brew leftovers
    brew cleanup
    brew cask cleanup
    
# TODO

* Package sshfs failed due to dependancy on osx fuse (which can be installed by brew cask)
* ffmpeg with all options: https://gist.github.com/Piasy/b5dfd5c048eb69d1b91719988c0325d8
* Migrate script to use `brew bundle` to simplify.
* Some basic defaults. eg screenshot folder `defaults write com.apple.screencapture location $HOME/Screenshots/`


# Similar Projects

* Connell's OSX Install: https://github.com/andrewconnell/osx-install
* SBastiens MacOs Setup: https://github.com/Sbastien/macos-setup
