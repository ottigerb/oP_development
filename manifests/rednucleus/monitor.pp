class monitor_bayeshive {
  #####################
  ## runbays         ##
  #####################

  file { "/usr/bin/monitor-bayeshive":
    source => "/tmp/vagrant-puppet/manifests/files/monitor-bayeshive",
  }
   
  supervisor_program { "monitor_bayeshive_super":
    command     => "/usr/bin/monitor-bayeshive",
    user        => "root",
    ensure      => "running",
    subscribe   => [File["/usr/bin/monitor-bayeshive"]],
    require => [File["/usr/bin/monitor-bayeshive"],
#                File["/opt/keter/incoming/BayesHive.keter"],                 
                Postgresql::Db['bayhiveprod'],
                Exec["install matio"],
                Exec["install_stan"],
                User["$user"],
#                Supervisor_program["rednucleus_keter_super"]
		]
  } 

}
