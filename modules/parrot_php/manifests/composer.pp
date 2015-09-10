class parrot_php::composer {

  if ! defined(Package['curl']) {
    package { 'curl':
      ensure => present,
      before => Exec['composer_install'],
    }
  }

  exec { 'composer_install':
    command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
    creates => '/usr/local/bin/composer',
    path => "/bin:/usr/bin",
    cwd => "/tmp",
    require => Class['parrot_php'],
  }

}
