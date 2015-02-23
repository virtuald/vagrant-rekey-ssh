OBSOLETE: The functionality this plugin provides is available in Vagrant 1.7+

vagrant-rekey-ssh
=================

This is a [vagrant](http://vagrantup.com) plugin that will make your vagrant
boxes a bit more secure than they currently are.

Rationale
---------

All Vagrant boxes come with the same ssh key and passwords installed. This
means anyone who can ssh into your VM will be able to authenticate to it
if they try the vagrant default credentials. Additionally, vagrant boxes
come with passwordless sudo privileges, so anyone able to SSH into your 
box will be able to do whatever they want on it.

As of Vagrant 1.2.3, for the most part this doesn't matter, because you can 
only access the Vagrant VM from localhost (previous versions allowed access
from any machine on your local network). However, this becomes *extremely*
important if you are using a vagrant box that is on a bridged network. If
your VM is on a bridged network without other controls in place, that means
*anyone* who has access to your local network can SSH into your VM and get
root access on it. There are plenty of documented ways of breaking out of a
VM, so this is clearly a problem that needs to be addressed.

Ideally, Vagrant would have something built into it to solve the problem.
Since that isn't currently the case, I've created this plugin to help. 

This solution
-------------

The first time that this plugin is run, it generates a unique SSH key and
stores it as `~/vagrant.d/less_insecure_private_key`. Whenever you run the
`vagrant provision` command, this plugin will run a script to check the
authorized keys for the vagrant user to determine if the insecure key
public key is present. If it is present, it will replace the insecure key
with the public key for the generated key pair.

Additionally, if the insecure public key is present, it will delete the
passwords for root and vagrant, so that you cannot login using a password.

Whenever vagrant tries to SSH into a box using an SSH key, this plugin will
add the generated SSH key to the list of keys it tries. This ensures that
you will still be able to SSH into boxes that have the insecure key installed.

Installation
------------

    vagrant plugin install vagrant-rekey-ssh

Usage
-----

Just install the plugin. It will do its magic automatically when you provision
a box.

To secure already running VMs, you will need to run `vagrant provision` on
them.

Settings
--------

You can set these settings in an individual Vagrantfile, or you can specify
this in your global Vagrantfile (~/.vagrant.d/Vagrantfile)

* `config.rekey_ssh.enable` - Enables or disables the plugin. Default: enabled


Compatibility
-------------

I've only tested this on Vagrant 1.3.5 using the Virtualbox provider on Ubuntu
and OSX. In addition, it was tested on Windows 8.1 with Vagrant 1.6.3 and the
VirtualBox provider. Let me know if it works on earlier versions of Vagrant,
and I'll put that here.

Known Issues
------------

I haven't figured out a generic way to override a machine's configuration
without hooking specific actions, which results in the following bugs that
I am aware of:

* The ssh-config command does not include the correct keys
* May not work with commands that are not built in to vagrant

If you can figure out a good way to fix these, please submit a pull request.

Contributing new changes
========================

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Development
===========

To work on the `vagrant-rekey-ssh` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

    $ bundle

You can test the plugin without installing it into your Vagrant environment 
by just creating a `Vagrantfile` in the top level of this directory (it is
gitignored) that uses it, and uses bundler to execute Vagrant:

    $ bundle exec vagrant WHATEVER

Credits
=======

Since I'm not really a ruby programmer, a lot of the skeleton of this plugin
came from other Vagrant plugins, particularly `vagrant-ohai` and 
`vagrant-openstack-plugin`. 

Author
======

Author:: Dustin Spicuzza (dustin@virtualroadside.com)
