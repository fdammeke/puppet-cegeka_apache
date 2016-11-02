/*

== Definition: cegeka_apache::conf

Convenient wrapper around File[] resources to add random configuration
snippets to apache. Shouldn't be called directly - please see cegeka_apache::confd and cegeka_apache::directive

Parameters:
- *ensure*:        present/absent.
- *configuration*: apache configuration(s) to be applied
- *filename*:      basename of the file in which the configuration(s) will be put.
                    Useful in the case configuration order matters: apache reads the files in conf.d/
                    in alphabetical order.
- *prefix*:        filename prefix
- *path*:          directory for the file

Requires:
- Class["apache"]

Example usage:

  cegeka_apache::conf { "example 1":
    ensure        => present,
    path          => /var/www/foo/conf
    configuration => "WSGIPythonEggs /var/cache/python-eggs",
  }

*/
define cegeka_apache::conf($configuration, $path, $ensure=present, $filename='', $prefix='configuration') {
  $fname = regsubst($name, '\s', '_', 'G')

  if ($path == '') {
    fail('empty "path" parameter')
  }

  if ($configuration == '' and $ensure == 'present') {
    fail('empty "configuration" parameter')
  }

  $confseltype = $::operatingsystem ? {
    'RedHat' => 'httpd_config_t',
    'CentOS' => 'httpd_config_t',
    default  => undef,
  }

  $real_conf_path = $filename ? {
    ''      => "${path}/${prefix}-${fname}.conf",
    default => "${path}/${filename}",
  }
  file{ "${name} configuration in ${path}":
    ensure  => $ensure,
    content => "# file managed by puppet\n${configuration}\n",
    seltype => $confseltype,
    path    => $real_conf_path,
    notify  => Exec['apache-graceful'],
  }

}
