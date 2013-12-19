class rednucleus_runbays {
  #####################
  ## runbays         ##
  #####################

  file { "/usr/bin/runbays":
    source => "/tmp/vagrant-puppet/manifests/files/runbays",
  }

  file { "/etc/init/runbays.conf":
    content => template("/tmp/vagrant-puppet/manifests/files/runbays.conf"),
    ensure  => "absent"
  }

  file { "/etc/init/runbays-all.conf":
    content => template("/tmp/vagrant-puppet/manifests/files/runbays-all.conf"),
    ensure  => "absent"
  }
  case $hostname 
  {
    "main": {
      supervisor_program { "rednucleus_runbays_super":
        command     => "/usr/bin/runbays --db 'password=lt4tad user=bhiveprod dbname=bayhiveprod hostaddr=127.0.0.1'",
        user        => $user,
        numprocs    => $runbay_main,
        environment => "HOME=/home/$user,NODE_PATH=/opt/node_modules,LANG=en_US.UTF-8",
        ensure      => "running",
        subscribe   => [
            File["/usr/bin/runbays"],
            File["/etc/init/runbays-all.conf"],
            File["/etc/init/runbays.conf"]
            ],
        require => [
            File["/etc/init/runbays-all.conf"],
            File["/etc/init/runbays.conf"],
            File["/usr/bin/runbays"],
#           File["/opt/keter/incoming/BayesHive.keter"],                 
            Postgresql::Db['bayhiveprod'],
            Exec["install matio"],
            Exec["install_stan"],
            User["$user"],
            Supervisor_program["rednucleus_app_super"]
            ]
       } 
    }
    /^worker-/: {
      supervisor_program { "rednucleus_runbays_super":
        command     => "/usr/bin/runbays --db 'password=lt4tad user=bhiveprod dbname=bayhiveprod hostaddr=127.0.0.1'",
        user        => $user,
        numprocs    => $runbay_workers,
        environment => "HOME=/home/$user,NODE_PATH=/opt/node_modules,LANG=en_US.UTF-8",
        ensure      => "stopped",
        subscribe   => [
            File["/usr/bin/runbays"],
            File["/etc/init/runbays-all.conf"],
            File["/etc/init/runbays.conf"]
            ],
        require => [
            File["/etc/init/runbays-all.conf"],
            File["/etc/init/runbays.conf"],
            File["/usr/bin/runbays"],               
            Exec["install matio"],
            Exec["install_stan"],
            User["$user"]
            ],
      }
    }
  } 

  /*service {"runbays-all":
    ensure => "running",
    require => [File["/etc/init/runbays-all.conf"],
                File["/etc/init/runbays.conf"],
                File["/usr/bin/runbays"],
                File["/opt/keter/incoming/BayesHive.keter"],
                Postgresql::Db['bayhiveprod'],
                Exec["install matio"],
                Exec["install_stan"],
                User["$user"]]
  } */

}
