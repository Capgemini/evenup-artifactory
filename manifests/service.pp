# == Class: artifactory::service
#
# This class manages the artifactory service.  It should not be called directly
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class artifactory::service(
  $service_ensure = $artifactory::service_ensure,
  $service_name   = $artifactory::service_name,
  $service_manage = $artifactory::service_manage,
  ) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

    service { $service_name:
      ensure     => $service_ensure,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
    }

}
