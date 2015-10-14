# == Class: artifactory::config
#
# This class configures artifactory.  It should not be called directly
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class artifactory::config (
  $ajp_port      = $artifactory::ajp_port,
  $service_name  = $artifactory::service_name,
){

  $user  = $artifactory::user
  $group = $artifactory::group

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/opt/jfrog/artifactory/tomcat/conf/server.xml':
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0444',
    content => template('artifactory/server.xml.erb'),
    notify  => Class['artifactory::service'],
  }

}
