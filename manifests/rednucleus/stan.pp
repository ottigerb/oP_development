class rednucleus_stan {
	###########################
	## STAN                  ##
	###########################

	file { "/home/$user/getstan.sh":
		ensure  => present,
		content => template("/tmp/vagrant-puppet/manifests/files/getstan.sh"),
		owner   => $user,
		mode    => 744,
		require => User["$user"],
	}

	exec { "install_stan":
		command => "/bin/bash getstan.sh",
		cwd     => "/home/$user",
		creates => "/home/$user/stan-src-$stanv/bin/stanc",
		user    => $user,
		timeout => 600,
		require => [File["/home/$user/getstan.sh"], User["$user"]]
	}
}
