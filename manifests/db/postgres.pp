class postgresql_bayhive {
  postgresql::db { 'op_prod':
    user      => 'bhiveprod',
    password  => 'lt4tad',
  }

  postgresql::db { 'therapy-server':
    user      => 'elise1',
    password  => 'mypass',
  }

  postgresql::pg_hba_rule { 'puppet_connect_ident':
    description => "allow local md5 connection",
    type => 'local',
    database => 'op_prod',
    user => 'all',
    auth_method => 'ident',
    order=>'001'
  }
}

class { 'postgresql::server':
    config_hash => {
        'postgres_password' => 'lt4tad',
        'ip_mask_deny_postgres_user' => '0.0.0.0/32',
        'ip_mask_allow_all_users' => '0.0.0.0/0',
        'listen_addresses' => '127.0.0.1'
    },
}
