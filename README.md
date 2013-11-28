oP_development
==============

Development of openPsychotherapy

First install [Vagrant 1.2.x](http://www.vagrantup.com/). This may or may not work on Vagrant 1.3.0. Please try it.

clone the repository `therapy-server` from Beat's GitHub account onto somewhere on your computer. 

Also clone this repository (oP_development). 

Copy `Vagrantfile.example` to `Vagrantfile`

Edit the Vagrantfile such that the synced folders for the repository
(`therapy-server`) come from the approriate directory on
your host computer. For instance, instead of

```
  config.vm.synced_folder "/home/tomn/survery-server/", "/home/vagrant/therapy-server"
```

you will need something like this on Linux

```
  config.vm.synced_folder "/home/you/work/TigerCyberPsychoSolutions/repos/therapy-server/", "/home/vagrant/therapy-server"
```

or on Windows MAYBE something like

```
  config.vm.synced_folder "C:\My Documents\Work\TigerCyberPsychoSolutions\therapy-server", "/home/vagrant/therapy-server"
```

or wherever you checked out these repos.

Do not edit the target path on the vagrant box (here `/home/vagrant/therapy-server`). 

then

`vagrant up`

this will take a long time (30 mins?) the first time because it is
downloading and building the whole GHC/Yesod ecosystem.

then `vagrant ssh` in to your new box. To launch the development web server
 
```
cd ~/therapy-server/ && yesod devel
```

now you can connect to localhost:3000 on you host machine.


