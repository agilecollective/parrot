class drush (
  $git_branch = 'master',
  $git_repo = 'https://github.com/drush-ops/drush.git'
) {


  if ! defined(Package['curl']) {
    package { 'curl':
      ensure => present,
      before => Exec['composer_install'],
    }
  }

  exec { 'composer_install':
    command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
    creates => '/usr/local/bin/composer',
    require => Class['parrot_php'],
  }

  if ! defined(Package['git']) {
    package { 'git':
      ensure => present,
      before => Vcsrepo['/usr/share/drush'],
    }
  }

  # Install Drush from GitHub
  vcsrepo { '/usr/share/drush':
    ensure => present,
    provider => git,
    source => $git_repo,
    revision => $git_branch,
    user => 'root',
    require => Exec['composer_install'],
    notify => Exec['composer_drush_install'],
  }

  # Symlink Drush
  file { 'symlink_drush':
    ensure => link,
    path => '/usr/bin/drush',
    target => '/usr/share/drush/drush',
    require => Vcsrepo['/usr/share/drush'],
  }

  # Complete Drush install
  exec { 'composer_drush_install':
    command => '/usr/local/bin/composer install',
    environment => [ "COMPOSER_HOME=/usr/share/drush" ],
    cwd => '/usr/share/drush',
    refreshonly => true,
  }

}
