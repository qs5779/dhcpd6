# puppet-dhcpd6

## Overview

This module installs and enables a dhcpd6 server using a pre-existing
configuration file or template generated outside of the module's scope.
This is because all possible dhcpd6 configuration files would be hard
to base on a single template without introducing lots of complexity,
either in the amount of parameters or the structure (hashes) to pass them.

Included are a static `dhcpd6.conf-example` file to get started, as well as
a simple `dhcpd6.conf-simple.erb` template for very simple dhcpd6 servers.

Parameters to the main `::dhcpd6` class :

* `$configsource` : Puppet location of the conf file to use. Default: none
* `$configcontent` : Content of the config file to use. Default: none
* `$dhcpd6args` : Command-line arguments to be added to dhcpd6. Default: empty
* `$ensure` : Ensure parameter for the service. Default: undef
* `$enable` : Enable parameter for the service. Default: true

## Examples

Pre-existing custom static `dhcpd6.conf` file :
```puppet
class { '::dhcpd6':
  configsource => 'puppet:///modules/mymodule/dhcpd6.conf-foo',
  # Restrict listening to a single interface
  dhcpd6args    => 'eth1',
  # Default is to enable but allow to be stopped (for active/passive)
  ensure       => 'running',
}
```

Trivial configuration using the included example template :
```puppet
class { '::dhcpd6':
  configcontent => template('dhcpd6/dhcpd6.conf-simple.erb'),
}
```

Slightly more complex configuration using the included example template :
```puppet
# Variables used from inside the template {will update soon}
$dhcpd6_netmask             = '255.255.255.0'
$dhcpd6_subnet              = '192.168.100.0'
$dhcpd6_routers             = '192.168.100.1'
$dhcpd6_domain_name_servers = '192.168.100.1,192.168.100.2'
$dhcpd6_range_start         = '100'
$dhcpd6_range_end           = '254'
$dhcpd6_default_lease_time  = '3600'
$dhcpd6_max_lease_time      = '21600'
class { '::dhcpd6':
  configcontent => template('dhcpd6/dhcpd6.conf-simple.erb'),
  ensure        => 'running',
}
```
