class rednucleus_ssl {
	file { "/opt/ssl":
		ensure => "directory",
	}

#	config_file { "/opt/ssl/certificate.pem":
#		content => template("/tmp/vagrant-puppet/manifests/files/certificate.pem"),
#		require => File["/opt/ssl"]
#	}

#	config_file { "/opt/ssl/privateKey.pem":
#		content => template("/tmp/vagrant-puppet/manifests/files/privateKey.pem"),
#		require => File["/opt/ssl"]
#	}
##
#	config_file { "/opt/ssl/intermediate_ca.pem":
#		content => template("/tmp/vagrant-puppet/manifests/files/intermediate_ca.pem"),
#		require => File["/opt/ssl"]
#	}
#
# Wawrzek's test for SSL in nginx
# http://wiki.nginx.org/HttpSslModule
#	# one certificate file
#	config_file { "/opt/ssl/bayeshive.pem":
#		content => template("/tmp/vagrant-puppet/manifests/files/bayeshive.pem"),
#		require => File["/opt/ssl"]
#	}
#	# key file
#	config_file { "/opt/ssl/bayeshive.key":
#		content => template("/tmp/vagrant-puppet/manifests/files/bayeshive.key"),
##		require => File["/opt/ssl"]
#	}
}
