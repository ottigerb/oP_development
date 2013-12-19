class new-nginx {
  package { 'nginx':
    ensure => present,
  }

  define nginx::conf () { 
    file { "/etc/nginx/conf.d/${name}":
      ensure  => file,
      owner => www-data,
      group => www-data,
      mode  => 644,
      replace => true,
      source  => "/tmp/vagrant-puppet/modules/new-nginx/files/${name}",
      require => Package[nginx],
    }
  }

  nginx::conf { [
    'bayeshive_app-upstream.conf',
    'gzip.conf'
  ]: }

  define nginx::vhost () { 
    file { "/etc/nginx/sites-enabled/${name}":
      ensure  => file,
      owner => www-data,
      group => www-data,
      mode  => 644,
      replace => true,
      source  => "/tmp/vagrant-puppet/modules/new-nginx/files/${name}",
      require => Package[nginx],
    }
  }

  nginx::vhost { [
    'bayeshive.com.vhost',
    'static.bayeshive.com.vhost',
    'openbrain.co.uk.vhost',
  ]: }

}
