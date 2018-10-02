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

