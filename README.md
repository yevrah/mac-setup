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

