class users() {

  define users::userssh () {
    user{ $name :
      ensure => present,
      managehome => true,
      shell => "/bin/bash",
      groups=> ["sudo", "adm", "cdrom", "dip", "plugdev", "lpadmin", "sambashare"],
    }

    file{"/home/$name/.ssh":
      ensure => directory,
      owner => $name,
      group => $name,
      mode => 700,
      require => User[$name],
    }

    file {"/home/$name/.ssh/authorized_keys2":
      ensure => present,
      source => "/tmp/vagrant-puppet/modules/users/$name/authorized_keys2",
      owner => $name,
      group => $name,
      mode => 600,
      require => File["/home/$name/.ssh"]
    } 
  }

  users::userssh{ ["wawrzek", "test1", "test"] : }
}
