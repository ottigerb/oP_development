class rednucleus_nginx {
	include rednucleus_ssl

	class { 'new-nginx': }
  #class { 'nginx': }
  #
  #nginx::resource::upstream { 'bayeshive_app':
  #		ensure  => present,
  #		members => ['127.0.0.1:3003'],
  #}
  #
  #nginx::resource::vhost { 'bayeshive.com':
  #		ensure 		=> present,
  #		ssl 		=> 'true',
  #	ssl_cert 	=> '/opt/ssl/bayeshive.pem',
  #	ssl_key 	=> '/opt/ssl/bayeshive.key',
  #	proxy 		=> 'http://bayeshive_app',
  #}
  #nginx::resource::vhost { 'static.bayeshive.com':
  #		ensure 		=> present,
  #		www_root	=> '/opt/BayesHive/builds/current',
  #}

  #nginx::resource::vhost { 'openbrain.co.uk':
  #		ensure 		=> present,
  #		listen_port => 80,
  #	rewrite_www_to_non_www => 'true',
  #	server_name => ['openbrain.co.uk', 'openbrain.cc', 'openbrain.org'],
  #		www_root 	=> "/home/$user/bayeshive-build/openbrain-org/www"
  #      }
}
