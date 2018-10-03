A Complete Mac Setup (mostly)
=============================

The repositry contains an automated Mac setup process targeting Mojave. The goal is to have as much as possible automated in an attempt to do a fresh install.



Creating an Automated Build-Out
===============================

## Step 0: The zeroth step, setup github and vm

The first step is to setup a github repo for this build out. In addition I will be testing on a vmware fusion setup.

Basics steps include:

  * Setup github, with a setup.sh file target
  * Download Mojave from App Store
  * Create a new VM, the Mojave installer can simply be dragged into VMWare fusion for isntallation
  * Take a snapshot after VM is installed

## Step 1: Create an install script which can be run github

In the `setup.sh` simply add `echo "hello world"` as a quick test, commit, push and test with:

    $ curl https://raw.githubusercontent.com/yevrah/mac-setup/master/setup.sh | /bin/bash
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
        100    20  100    20    0     0     59      0 --:--:-- --:--:-- --:--:--    59
        hello world

> This step has been tagged in https://github.com/yevrah/mac-setup/tree/v0.1

Thats a little versbose, so let's cleanup the curl script. Well add some additional flags to make curl a little more silent. Specifically `-sS` which forces silent mode (`-s`), the `S` option when combined with silent mode shows errors.

    $ curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/setup.sh | /bin/bash
    hello world

Let's also clean up the bash file and make it a little more debug friendly.

    #!/bin/bash
    set -x

    echo "Mac Mojave Automated Setup"

The `set -x` prints out all commands as they run for the purposes of debugging our script. It is also worthwhile to make it executable with `chmod a+x setup.sh`. This allows us to run the setup using `./setup.sh` for the sake of convenience.

In some cases you may want to pass in additional parameters to your script, for example you may want to disable debugging unless an argument is set. You can do this using the following syntax:

    curl -sS htt.... | bash -s arg1 arg2

## Step 2: The Homebrew Workhorse

We'll be using `brew` (short for homebrew) to do all the heavy lifting, it's the defactor package manager for Mac. if your not familiar with it head over to their [website](https://docs.brew.sh/). Homebrew can be installed by adding the following to `install.sh`:

    echo "Installing HomeBrew"
    if test ! $(which brew)
    then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
    fi

Because we don't want to coniniously reset our vm we added a quick check to see if it exists and skip or else install.



Go ahead and add the following lines as well, it will help to future proof the script, and make it so re-running will update the isntalled packages.


    echo "Updating existing homebrew recpies"
    brew update

    echo "Upgrading existing installed formulas"
    brew upgrade --all

## Step 3: Installing packages

Some packages need to be compiled by Homebrew, to do this we need to install the xcode command line tools. The following code allows for a silent install for this dependancy:


    echo "Checking Xcode CLI tools"
    # Only run if the tools are not installed yet
    # To check that try to print the SDK path
    xcode-select -p &> /dev/null
    if [ $? -ne 0 ]; then
      echo "Xcode CLI tools not found. Installing them..."
      touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
      PROD=$(softwareupdate -l |
        grep "\*.*Command Line" |
        head -n 1 | awk -F"*" '{print $2}' |
        sed -e 's/^ *//' |
        tr -d '\n')
      softwareupdate -i "$PROD" -v;
    else
      echo "Xcode CLI tools OK"
    fi

After you have copied that to your install script, we are now ready to install packages. If you have an existing homebrew system you can export your packages using `brew list > packages.txt`. You'll probably have some items that are no longer relevant, now is the time to cleanup this list.

You can now simply list a bunch of home brew isntalls using the following syntax

    echo "Manually installed packages"
    brew install wget
    brew install git
    ... and so on

I preferr to instead just install from the list in packages.txt, this allows me to modify my installation library without having to touch source code. We'll be using xargs to build the install commands as follows:

    echo "Installed from packages.txt list"
    curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.txt | xargs brew install


## Step 4: Gui Packages with Homebrew Cask

The *Cask* extension for Homebrew offers a way to install graphical applications such as browsers, video players, and much more. It can be isntalled simply by adding the following command to our script:

    brew tap caskroom/cask

You can find packages using `brew search` as in the example below:

    $ brew search vlc
    ==> Casks
    vlc
    vlc-webplugin
    vlcstreamer
    homebrew/cask-versions/vlc-nightly

Installation of packages can be done by adding `brew cask install vlc` as an example. But again, it's easier and nicer to just put all the applicates into an `packages.cask.txt` file and installing with:

    
    echo "Installing from packages.cask.txt list"
    curl -sS https://raw.githubusercontent.com/yevrah/mac-setup/master/packages.cask.txt | xargs brew install

## Step 5: Apple Store Packages with mas-cli

Note: As off High Sierra mas-cli has been brokern due to change in the App Store api. This issue can be tracked here: https://github.com/mas-cli/mas/issues/164

Unfortunately cask doesnt handle all gui apps, particularly ones from the app store. You can install this utility with `brew install mas`. This will give you a simple command line tool for the App Store. If you have an existing mac you can use it to get a list of existing apps

    $ mas list
    497799835 Xcode (10.0)
    409203825 Numbers (5.2)
    409183694 Keynote (8.2)

Go ahead and copy this to a file called `packages.mas.txt`. We're going to run it with:

    echo "Installing from packages.mas.txt list"
    cat packages.mas.txt | sed 's/ .*//' | xargs mas install

Notice the addition of the `sed` command. The mas-cli tools doesnt know what to do with the text part of the package, it only takes the identifier as input. But for the sake of maintenance we have kept the description in. The additional commands just removes the space and everything else after it before sending it through.

    
# Step X: Cleanup

    # Remove brew leftovers
    brew cleanup
    brew cask cleanup
    
# TODO

* Package sshfs failed due to dependancy on osx fuse (which can be installed by brew cask)
* ffmpeg with all options: https://gist.github.com/Piasy/b5dfd5c048eb69d1b91719988c0325d8
* Set defaults using similar to https://github.com/why-jay/osx-init/blob/master/install.sh
* Set dotfiles
* Configure dotfiles
* Configure git
* Configure mysql
* Configure Apache
* Other files to backup: https://medium.com/@abookyun/clean-install-your-mac-without-hesitation-7d379df8fc87
