class bayeshive {
	include common
	include common_baysig
	include rednucleus_build
	include postgresql_bayhive
#	include rednucleus_keter
	include rednucleus_nginx
	include rednucleus_runbays
	include rednucleus_stan
	include monitor_bayeshive
        include mainapp

	# check for /home/$user/.cabal and it doesn't exist yet
#	exec { "cabal_update":
#		command => "/usr/bin/cabal update",
#		timeout => 600,
#		user    => "$user",
#		unless  => "/usr/bin/test -d /home/$user/.cabal",
#		require => Package["haskell-platform"],
#	}
}

class bh_devel {
	include common
	include rednucleus_build
	include postgresql_bayhive
	include rednucleus_stan

  	file { "/root/setup-build-env-ghc.sh":
		content => template("/tmp/vagrant-puppet/manifests/files/setup-build-env-ghc.sh"),
	}

	exec { "setup_build_env_ghc":
		command => "/bin/bash /root/setup-build-env-ghc.sh",
		cwd     => "/root",
		creates => "/usr/local/bin/ghc",
		timeout => 600,
                logoutput => "on_failure",
		require => [Package["build-essential"],
                            Package["make"],
                            Package["libgmp3c2"],
                            Package["libgmp3-dev"],
                            File["/root/setup-build-env-ghc.sh"],
                            Download["/opt/ghc/ghc-$ghcv.tar.bz2"]]
	}

        exec { "setup_build_env_dev":
		command => "/bin/bash setup-build-env-dev.sh",
		cwd     => "/home/$user",
                environment => "HOME=/home/$user",
		creates => ["/home/$user/sources.txt",
                            "/home/$user/.cabal/bin/yesod",
                            "/home/$user/.cabal/bin/BayesHive",
                            "/home/$user/.cabal/bin/runbays"],
		user    => $user,
		timeout => 10000,
                logoutput => "on_failure",
		require => [Package["git"],
                            Package["libgsl0-dev"],
                            Package["libatlas-base-dev"],
                            Package["libpq-dev"],
                            Package["libhdf5-serial-dev"],
                            Exec["install matio"],
                            Download["/opt/ghc/cabal-install-$cabalinstallv.tar.gz"],
                            User["$user"],
                            Exec["setup_build_env_ghc"]]
	}
        
        file { ["/var/bayeshive",
	        "/var/bayeshive/1",
	        "/var/bayeshive/1/Help"]:
			ensure => "directory",
			owner => $user
	}

  
}


class bayeshive_worker {
	include common
	include common_baysig
	include rednucleus_build
	include rednucleus_runbays
	include rednucleus_stan

	# check for /home/$user/.cabal and it doesn't exist yet
#	exec { "cabal_update":
#		command => "/usr/bin/cabal update",
#		timeout => 600,
#		user    => "$user",
#		unless  => "/usr/bin/test -d /home/$user/.cabal",
#		require => Package["haskell-platform"],
#	}

	supervisor_program { "var_bayeshive_remote":
	    command     => "sshfs -o nonempty root@main.bayeshive.com:/var/bayeshive /var/bayeshive/",
	    user        => "root",
	    numprocs    => 1,
	    ensure      => "running",
	    require     => [File["/var/bayeshive"],
	    Package["sshfs"]],
	}
}

class minimal {
	include common
	include common_baysig
}
