# Class: dhcpd6
#
# Installs and enables a dhcpd6 server. You must specify either `$configsource`
# or `$configcontent`.
#
# Parameters:
#  $configsource:
#    Puppet location of the configuration file to use. Default: none
#  $configcontent:
#    Content of the configuration file to use. Default: none
#  $dhcpd6args:
#    Command-line arguments to be added to dhcpd6. Default: empty
#  $ensure:
#    Ensure parameter for the service. Default: undefined
#  $enable:
#    Enable parameter for the service. Default: true
#
# Sample Usage :
#  class { 'dhcpd6':
#    configsource => 'puppet:///files/dhcpd6.conf-foo',
#    # Restrict listening to a single interface
#    dhcpd6args    => 'eth1',
#    # Default is to enable but allow to be stopped (for active/passive)
#    ensure       => 'running',
#  }
#
class dhcpd6 (
  $configsource  = undef,
  $configcontent = undef,
  $dhcpd6args    = '',
  $ensure        = undef,
  $enable        = true,
  $installpkg    = true, # set to false if using dhcpd module too
) {

  if $installpkg {
    package { 'dhcp': ensure => installed }
  }

  service { 'dhcpd6':
    ensure    => $ensure,
    enable    => $enable,
    hasstatus => true,
    require   => Package['dhcp'],
  }

  $dhcpd6_conf = '/etc/dhcp/dhcpd6.conf'

  file { $dhcpd6_conf :
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $configsource,
    content => $configcontent,
    require => Package['dhcp'],
    notify  => Service['dhcpd6'],
  }

}
