class op_build {
	##################################
	## OPENPSYCHOTHERAPY ##
	##################################

	file { "/home/$user/setup-build-env-dev.sh":
		content => template("/tmp/vagrant-puppet/manifests/files/setup-build-env-dev.sh"),
		owner   => $user,
      		mode   => 0755,
		require => User["$user"]
	}

	file { "/home/$user/build.sh":
		content => template("/tmp/vagrant-puppet/manifests/files/build.sh"),
		owner   => $user,
      		mode   => 0755,
		require => User["$user"]
	}


	file { "/root/master-build.sh":
		content => template("/tmp/vagrant-puppet/manifests/files/master-build.sh"),
      		mode   => 0711,
	}

	file { "/opt/ghc":
		ensure  => "directory",
		owner   => "$user",
		require => User["$user"]
	}
	download { "/opt/ghc/ghc-$ghcv.tar.bz2":
	    uri     => "http://www.haskell.org/ghc/dist/$ghcv/ghc-$ghcv-x86_64-unknown-linux.tar.bz2",
	    require => File["/opt/ghc"]
	}

	download { "/opt/ghc/cabal-install-$cabalinstallv.tar.gz":
		uri => "http://hackage.haskell.org/packages/archive/cabal-install/$cabalinstallv/cabal-install-$cabalinstallv.tar.gz",
	    require => File["/opt/ghc"]
	}

	file { "/home/$user/build_backups":
		ensure  => "directory",
		require => User["$user"]
	}	
}
