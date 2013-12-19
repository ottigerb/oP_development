class common_supervisor
{
  package { "python-setuptools": ensure => "installed" }

  # install supervisord with setuptools easy_install
  exec { "easy_install_supervisor":
    command => "/usr/bin/easy_install supervisor",
    creates => "/usr/local/bin/supervisord",
    require => Package["python-setuptools"],
  }

  # install an init script and a default config file
  file { "/etc/init.d/supervisor":
    ensure => 'file',
    owner => 'root',
    group => 'root',
    mode  => 0754,
    source => "/tmp/vagrant-puppet/manifests/files/supervisor",
    require => Exec["easy_install_supervisor"],
  }

  config_file { "/etc/supervisord.conf":
    source => "/tmp/vagrant-puppet/manifests/files/supervisord.conf",
    require => Exec["easy_install_supervisor"],
  }

  # create the /etc/supervisord directory in which
  # individual programs and groups will be defined
  file { "/etc/supervisord":
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode  => 0755,
    require => File["/etc/supervisord.conf"],
  }

  # ensure that the supervisor log directory exists
  file { "/var/log/supervisord":
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode  => 0755,
    require => File["/etc/supervisord.conf"],
  }

  # start supervisord, by default it will have no programs to run
  service { "supervisor":
    ensure      => "running",
    hasrestart  => true,
    hasstatus   => false,
    subscribe   => [File["/etc/supervisord.conf"], File["/etc/supervisord"]],
    require     => [Exec["easy_install_supervisor"], File["/etc/init.d/supervisor"], File["/var/log/supervisord"]],
  }

  exec { "supervisor_starton_bootup":
    command  => "/usr/sbin/update-rc.d supervisor defaults",
    creates  => "/etc/rc3.d/S20supervisor",
    require  => File["/etc/init.d/supervisor"],
  }
}
