class rednucleus_keter {
	#########################
	## Keter               ##
	#########################

	include rednucleus_ssl

	file { "/opt":
		ensure => "directory"
	}

	file { ["/opt/keter",
			"/opt/keter/bin",
			"/opt/keter/etc",
			"/opt/keter/incoming",
			"/opt/keter/temp"]:
		ensure  => "directory",
		owner   => $user,
		group   => $user,
		require => User[$user]
	}

	file { "/opt/keter/bin/keter":
		source => "/tmp/vagrant-puppet/manifests/files/keter",
		require => File["/opt/keter/bin"]
	}

	file { "/opt/keter/etc/keter-config.yaml":
		content => template("/tmp/vagrant-puppet/manifests/files/keter-config.yaml"),
		require => File["/opt/keter/etc"]
	}

	file { "/opt/keter/incoming/BayesHive.keter":
	    source  => "/tmp/vagrant-puppet/manifests/files/BayesHive.keter",
	    require => [Postgresql::Db['bayhiveprod'],
	                Exec["install matio"],
		            File["/opt/keter/etc"]],
        owner => $user,
	}

	supervisor_program { "rednucleus_keter_super":
	    command     => "/opt/keter/bin/keter /opt/keter/etc/keter-config.yaml",
	    user        => "root",
	    numprocs    => 1,
	    ensure      => "stopped",
	    subscribe   => [File["/opt/keter/bin/keter"],
	       				File["/opt/keter/etc/keter-config.yaml"]],
	    require     => [Postgresql::Db['bayhiveprod'], User["$user"]]
	}
}
