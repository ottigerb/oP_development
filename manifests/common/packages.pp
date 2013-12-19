class common_packages {
	## Always update package database first so installations do not fail later
	Exec["apt-get update"] -> Package <| |>

	## http://stackoverflow.com/questions/10845864/puppet-trick-run-apt-get-update-before-installing-other-packages
	exec { 'apt-get update':
		command => '/usr/bin/apt-get update',
		onlyif  => "/bin/bash -c 'exit $(( $(( $(date +%s) - $(stat -c %Y /var/lib/apt/lists/$( ls /var/lib/apt/lists/ -tr1|tail -1 )) )) <= 604800 ))'",
		timeout => 600
	}

	package { "git": ensure => present}
	package { "vim": ensure => present}

	# stuff required to building packages from source
	package { "build-essential": ensure => present}
	package { "make": ensure => present}
	package { "libdevil-dev": ensure => present}
	package { "rubygems": ensure => present}
	package { "libpq-dev": ensure => present}
	package { "libhdf5-serial-dev": ensure => present}

	# haskell-platform installs a variety of useful tools and libraries. I bet it does, but not here.
#	package { "haskell-platform": ensure => present}
	package { "libgmp3c2": ensure => present}
	package { "libgmp3-dev": ensure => present}


	# sshfs to share /var/bayeshive across the network
	package { "sshfs": ensure => present}

	# improve resource monitoring
	package { "htop": ensure => present}
	package { "dstat": ensure => present}


}
