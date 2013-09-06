oP_development
==============

Development of openPsychotherapy

clone the repository

`survey-server`

from Ian's GitHub account onto somewhere on your computer. 

Also clone this repository (oP_development). 

Copy `Vagrantfile.example` to `Vagrantfile`

Edit the Vagrantfile such that the synced folders for the repository
(`survey-server`) come from the approriate directory on
your host computer. For instance, instead of

```
  config.vm.synced_folder "/home/tomn/survery-server/", "/home/vagrant/survey-server"
```

you will need something like this on Linux

```
  config.vm.synced_folder "/home/you/work/TigerCyberPsychoSolutions/repos/survey-server/", "/home/vagrant/survey-server"
```

or on Windows MAYBE something like

```
  config.vm.synced_folder "C:\My Documents\Work\TigerCyberPsychoSolutions\survey-server", "/home/vagrant/survey-server"
```

or wherever you checked out these repos.

Do not edit the target path on the vagrant box (here `/home/vagrant/survery-server`). 

then

`vagrant up`

this will take a long time (30 mins?) the first time because it is
downloading and building the whole GHC/Yesod ecosystem.

then `vagrant ssh` in to your new box. To launch the development web server
 
```
cd ~/survery-server/ && yesod devel
```

now you can connect to localhost:3000 on you host machine.


