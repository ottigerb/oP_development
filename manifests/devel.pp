# The user most of our stuff will run as
$user = "vagrant"

$sshd_port = 22

$ghcv="7.6.3"

$cabalinstallv="1.16.0.2"


user { $user:
   ensure     => present,
   groups     => ["sudo", "adm", "cdrom", "dip", "plugdev", "lpadmin", "sambashare"],
   managehome => true,
   shell  => "/bin/bash",
}

import "/tmp/vagrant-puppet/manifests/defines.pp"
import "/tmp/vagrant-puppet/manifests/common/*.pp"
import "/tmp/vagrant-puppet/manifests/db/*.pp"

include op_devel

