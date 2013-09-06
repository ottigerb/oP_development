class openpsychotherapy {
	include common
	include op_build
	include postgresql_bayhive


}

class op_devel {
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
                            "/home/$user/.cabal/bin/yesod"],
		user    => $user,
		timeout => 10000,
                logoutput => "on_failure",
		require => [Package["git"],
                            Package["libpq-dev"],
                            Download["/opt/ghc/cabal-install-$cabalinstallv.tar.gz"],
                            User["$user"],
                            Exec["setup_build_env_ghc"]]
	}
          
}
