/*

== Class: cegeka_apache::service

*/
class cegeka_apache::service {

  service { 'cegeka_apache':
    ensure     => $cegeka_apache::params::service_status,
    name       => $cegeka_apache::params::pkg,
    enable     => true,
    hasrestart => true,
    require    => Package[$cegeka_apache::params::pkg],
  }
}
