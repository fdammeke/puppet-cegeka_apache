class cegeka_apache::webdav::ssl::debian {
  include cegeka_apache::webdav::base

  case $::lsbdistcodename {
    etch: {
      # cf: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=420101
      file {'/var/lock/apache2':
        ensure  => directory,
        owner   => www-data,
        group   => root,
        mode    => '0755',
      }
    }
    default: {}
  }
}
