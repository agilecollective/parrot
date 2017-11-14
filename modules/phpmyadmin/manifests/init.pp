# -*- mode: puppet -*-
# vi: set ft=puppet :

class phpmyadmin {
  # PHPMyAdmin provides a web UI to browse and manage MySQL databases.

  package { 'phpmyadmin':
    ensure   => present,
  }

  # The package provides a config file for Apache, which exposes
  # /phpmyadmin as a URL alias.
  # The file is /etc/phpmyadmin/apache.conf: this needs to be symlinked so that
  # it's loaded by Apache.
  file { '/etc/apache2/conf-enabled/phpmyadmin.conf':
    ensure => file,
    source => 'puppet:///modules/phpmyadmin/phpmyadmin.apache.conf',
    require => Package['phpmyadmin', 'apache2'],
    notify => Service['apache2'],
  }

  file { '/etc/phpmyadmin/config.inc.php':
    ensure => file,
    source => 'puppet:///modules/phpmyadmin/config.inc.php',
    require => Package['phpmyadmin'],
    notify => Service['apache2'],
    owner => 'root',
    group => 'root',
  }
}
