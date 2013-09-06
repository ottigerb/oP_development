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
	package { "libgsl0-dev": ensure => present}
	package { "libatlas-base-dev": ensure => present}
	package { "libdevil-dev": ensure => present}
	package { "rubygems": ensure => present}
	package { "libpq-dev": ensure => present}
	package { "libhdf5-serial-dev": ensure => present}

	# haskell-platform installs a variety of useful tools and libraries. I bet it does, but not here.
#	package { "haskell-platform": ensure => present}
	package { "libgmp3c2": ensure => present}
	package { "libgmp3-dev": ensure => present}

	# Required for generating thumbnails
	package { "imagemagick": ensure => present}

	# php for selenium tests etc
	package { "php5-cli": ensure => present}
	package { "php5-curl": ensure => present}
	package { "php5-fpm": ensure => absent}

	# sshfs to share /var/bayeshive across the network
	package { "sshfs": ensure => present}

	# improve resource monitoring
	package { "htop": ensure => present}
	package { "dstat": ensure => present}

	exec { "get_latest_libbibutils2":
		command => "/usr/bin/wget -qc http://mirror.archive.ubuntu.com/ubuntu/pool/universe/b/bibutils/libbibutils2_4.12-5_amd64.deb",
		cwd     => "/var/cache/apt/archives",
		creates => "/var/cache/apt/archives/libbibutils2_4.12-5_amd64.deb",
	}

	exec { "install_latest_libbibutils2":
		command => "/usr/bin/dpkg -i /var/cache/apt/archives/libbibutils2_4.12-5_amd64.deb",
		unless  => "/usr/bin/dpkg -l libbibutils2",
		require => Exec["get_latest_libbibutils2"],
	}

	exec { "get_latest_pandoc":
		command => "/usr/bin/wget -qc http://archive.ubuntu.com/ubuntu/pool/universe/p/pandoc/pandoc_1.10.1-1_amd64.deb",
		cwd     => "/var/cache/apt/archives",
		creates => "/var/cache/apt/archives/pandoc_1.10.1-1_amd64.deb"
	}

	exec { "install_latest_pandoc":
		command => "/usr/bin/dpkg -i /var/cache/apt/archives/pandoc_1.10.1-1_amd64.deb",
		unless  => "/usr/bin/dpkg -l pandoc",
		require => [
			Exec["get_latest_pandoc"],
			Exec["install_latest_libbibutils2"]
		],
	}
}
