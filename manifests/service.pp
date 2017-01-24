/*

== Class: cegeka_apache::service

*/
class cegeka_apache::service {

  include cegeka_apache::params

  service { 'apache':
    ensure     => $apache::params::service_status,
    name       => $apache::params::pkg,
    enable     => true,
    hasrestart => true,
    require    => Package['apache'],
  }
}
