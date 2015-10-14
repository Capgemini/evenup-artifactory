# == Class: artifactory::install
#
# This class installs artifactory.  It should not be called directly
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class artifactory::install(
  $manage_yum_repo = $artifactory::manage_yum_repo,
  $package_ensure  = $artifactory::package_ensure,
  $home            = $artifactory::home,
  $backup_path     = $artifactory::backup_path,
  $data_path       = $artifactory::data_path,
  $manage_java     = $artifactory::manage_java,
  ) {

    $user  = $artifactory::user
    $group = $artifactory::group

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  File { require => Package['artifactory'] }

  case $::osfamily {
    'RedHat': {
      if $manage_yum_repo == true {
        yumrepo { 'bintray-artifactory':
          baseurl  => 'https://jfrog.bintray.com/artifactory-rpms/',
          descr    => 'bintray artifactory repo',
          enabled  => '1',
          gpgcheck => '0',
          priority => '1',
          before   => Package['artifactory'],
        }
      }
      ensure_resource('package', 'artifactory', {'ensure' => $package_ensure, notify => Class['artifactory::service'] } )

    }
    default: {
      err("The osfamily: ${::osfamily} is currently supported")
    }
  }
  ensure_resource('group', $group, {'ensure' => 'present', 'system' => true})
  ensure_resource('user', $user, {'ensure' => 'present', 'home' => $home, 'shell' => '/bin/bash', 'system' => true})


  if $backup_path {
    file { $backup_path:
      ensure => directory,
      mode   => '0775',
      owner  => $user,
      group  => $group,
    }
  }

  if $data_path != '/var/opt/jfrog/artifactory/data' {
    file { $data_path:
      ensure => directory,
      mode   => '0775',
      owner  => $user,
      group  => $group,
    }

    file { '/var/opt/jfrog/artifactory/data':
      ensure => link,
      target => $::artifactory::data_path,
    }
  }

  if $manage_java {
    deploy::file { 'jdk-8u60-linux-x64.tar.gz':
      target          => '/opt/jdk1.8.0_60',
      fetch_options   => '-q -c --header "Cookie: oraclelicense=accept-securebackup-cookie"',
      url             => 'http://download.oracle.com/otn-pub/java/jdk/8u60-b27/',
      download_timout => 1800,
      strip           => true,
      }->

    exec { 'create-java-alternatives':
      command => 'alternatives --install /usr/bin/java java /opt/jdk1.8.0_60/jre/bin/java 20000',
      unless  => 'alternatives --display  java | grep -q /opt/jdk1.8.0_60/jre/bin/java',
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      before  => Exec['update-java-alternatives'],
    }->

    exec { 'update-java-alternatives':
      command => 'alternatives --set java /opt/jdk1.8.0_60/jre/bin/java',
      unless  => 'test /etc/alternatives/java -ef /opt/jdk1.8.0_60/jre/bin/java',
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      before  => Class['::artifactory'],
    }

  }

}
