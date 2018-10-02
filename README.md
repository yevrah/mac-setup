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

    ```bash
    #!/bin/bash
    set -x

    echo "Mac Mojave Automated Setup"
    ```

The `set -x` prints out all commands as they run for the purposes of debugging our script. It is also worthwhile to make it executable with `chmod a+x setup.sh`. This allows us to run the setup using `./setup.sh` for the sake of convenience.

