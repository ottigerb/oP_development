class mainapp {
  file { [
    "/opt/BayesHive", 
    "/opt/BayesHive/bin",
    "/opt/BayesHive/builds",
    "/opt/BayesHive/incoming",
     ]:
      ensure => "directory",
      owner => $user,
      group => $user,
      require => User[$user],
  }

  file { "/opt/BayesHive/incoming/BayesHive.keter":
      source  => "/tmp/vagrant-puppet/manifests/files/BayesHive.keter",
      require => [
        Postgresql::Db['op_prod'],
        User[$user],
      ],
      ensure => "file",
      owner => $user,
      group => $user,
  }

  file { "/opt/BayesHive/bin/deploy.sh":
      content => template("/tmp/vagrant-puppet/manifests/files/deploy.sh"),
      ensure => present,
      mode  => 755,
      require => User[$user],
  }

  exec { "/opt/BayesHive/bin/deploy.sh":
      subscribe => File["/opt/BayesHive/incoming/BayesHive.keter"],
      refreshonly => true,
      require => File["/opt/BayesHive/bin/deploy.sh", "/opt/BayesHive/incoming/BayesHive.keter"]
  }

supervisor_program { "rednucleus_app_super":
      command     => "/opt/BayesHive/builds/current/dist/build/BayesHive/BayesHive Production -p 3003",
     user        => $user,
     chdir       => "/opt/BayesHive/builds/current/",
     environment => "HOME=/home/$user,LANG=en_US.UTF-8",        
     numprocs    => 1,
     ensure      => "running",
     require     => [
        Postgresql::Db['op_prod'],
        User["$user"],
      ]
  }
}
