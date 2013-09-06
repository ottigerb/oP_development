class common {
    Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }

    include common_packages

	file { "/home/$user/.profile":
		source => "/tmp/vagrant-puppet/manifests/files/user_profile.sh",
		owner  => "$user",
		mode   => 0755
	}
}
