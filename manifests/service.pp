/*

== Class: cegeka_apache::base

Common building blocks between cegeka_apache::debian and cegeka_apache::redhat.

It shouldn't be necessary to directly include this class.

*/
class cegeka_apache::base {

  include cegeka_apache::params

  service { 'apache':
    ensure     => $apache::params::service_status,
    name       => $apache::params::pkg,
    enable     => true,
    hasrestart => true,
    require    => Package['apache'],
  }
}
