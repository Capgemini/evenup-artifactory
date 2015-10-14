# == Class: artifactory::params
#
class artifactory::params {
  # resources

  $ensure          = 'latest'
  $ajp_port        = '8019'
  $data_path       = '/var/opt/jfrog/artifactory/data'
  $home            = '/var/opt/jfrog/artifactory'
  $service_name    = 'artifactory'
  $service_ensure  = running
  $manage_java     = true
  $user            = 'artifactory'
  $group           = 'artifactory'
  $package_ensure  = 'latest'

  case $::osfamily {
    'RedHat': {
      $manage_yum_repo = true
      $package_source  = 'https://jfrog.bintray.com/artifactory-rpms/'
    }
    'Debian': {
      $manage_yum_repo = false
      $package_source  = undef
    }
    default: {
      fail("${::osfamily}")
    }
  }
}
