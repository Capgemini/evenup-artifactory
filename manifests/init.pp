# == Class: artifactory
#
# This class installs and configures artifactory, apache vhost, and backups.
#
#
# === Parameters
#
# [*ensure*]
#   String.  Version of artifactory to be installed or latest/present
#   Default: latest
#
# [*serverAlias*]
#   String of comman seperated hostnames or array of hostnames.
#   Default: artifactory
#
#
# === Examples
#
# * Installation:
#     include artifactory
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
# * Jamie Lennox
#
class artifactory(
  $ajp_port         = $artifactory::params::ajp_port,
  $backup_path      = undef,
  $data_path        = $artifactory::params::data_path,
  $ensure           = $artifactory::params::ensure,
  $home             = $artifactory::params::home,
  $manage_java      = $artifactory::params::manage_java,
  $manage_yum_repo  = $artifactory::params::manage_yum_repo,
  $package_ensure   = $artifactory::params::package_ensure,
  $package_source   = $artifactory::params::package_source,
  $service_ensure   = $artifactory::params::service_ensure,
  $service_name     = $artifactory::params::service_name,
) inherits artifactory::params{

  validate_absolute_path($data_path)
  validate_string($service_name)
  validate_absolute_path($home)
  validate_bool($manage_yum_repo)
  validate_bool($manage_java)

  if $backup_path != undef {
    validate_absolute_path($backup_path)
  }

  class { '::artifactory::install': } ->
  class { '::artifactory::config': } ->
  class { '::artifactory::service': }

}
