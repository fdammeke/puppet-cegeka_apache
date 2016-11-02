define cegeka_apache::module ($ensure='present') {

  include cegeka_apache::params

  $a2enmod_deps = $::operatingsystem ? {
    /RedHat|CentOS/ => [
      Package['cegeka_apache'],
      File['/etc/httpd/mods-available'],
      File['/etc/httpd/mods-enabled'],
      File['/usr/local/sbin/a2enmod'],
      File['/usr/local/sbin/a2dismod']
    ],
    /Debian|Ubuntu/ => Package['cegeka_apache'],
  }

  if $::selinux == true and $ensure == true {
    cegeka_apache::redhat::selinux {$name: }
  }

  $enablecmd = $::operatingsystem ? {
    RedHat  => "/usr/local/sbin/a2enmod ${name}",
    CentOS  => "/usr/local/sbin/a2enmod ${name}",
    default => "/usr/sbin/a2enmod ${name}"
  }

  $disablecmd = $::operatingsystem ? {
    /RedHat|CentOS/ => "/usr/local/sbin/a2dismod ${name}",
    /Debian|Ubuntu/ => "/usr/sbin/a2dismod ${name}",
  }

  case $ensure {
    'present' : {
      exec { "a2enmod ${name}":
        command => $enablecmd,
        unless  => "/bin/sh -c '[ -L ${cegeka_apache::params::conf}/mods-enabled/${name}.load ] \\
          && [ ${cegeka_apache::params::conf}/mods-enabled/${name}.load -ef ${cegeka_apache::params::conf}/mods-available/${name}.load ]'",
        require => $a2enmod_deps,
        notify  => Service['cegeka_apache'],
      }
    }

    'absent': {
      exec { "a2dismod ${name}":
        command => $disablecmd,
        onlyif  => "/bin/sh -c '[ -L ${cegeka_apache::params::conf}/mods-enabled/${name}.load ] \\
          || [ -e ${cegeka_apache::params::conf}/mods-enabled/${name}.load ]'",
        require => $a2enmod_deps,
        notify  => Service['cegeka_apache'],
      }
    }

    default: {
      fail ( "Unknown ensure value: '${ensure}'" )
    }
  }
}
