class composer::behat {

  include composer

  file { '/opt/behat':
    ensure => directory,
  }

  file { '/opt/behat/composer.json':
    source  => 'puppet:///modules/composer/behat.json',
    require => File['/opt/behat'],
  }

  exec { 'composer_behat_install':
    command     => '/usr/local/bin/composer install',
    environment => [ "COMPOSER_HOME=/opt/behat" ],
    cwd         => '/opt/behat',
    creates     => '/opt/behat/bin/behat',
    require     => Class['composer'],
  }

  file { 'symlink_behat':
    ensure  => link,
    path    => '/usr/local/bin/behat',
    target  => '/opt/behat/bin/behat',
    require => Exec['composer_behat_install'],
  }

}
