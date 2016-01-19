node default {

  class {apt: }
  class { parrot_repos: }
  class { solr_server:  }
  class { parrot_mysql: }
  class { parrot_php:  }
  class { 'ohmyzsh': }
  ohmyzsh::install { ['root', 'vagrant']: }
  ohmyzsh::theme { ['root', 'vagrant']: theme => 'steeef' } # specific theme
  class { sudoers: }
  case $parrot_varnish_enabled {
    'true', true: {
      class { 'http_stack::with_varnish': }
    }
    default: {
      class { 'http_stack::without_varnish': }
    }
  }
  class { parrot_drush: }
  class { mailcollect: }

  package { 'vim': }
  package { 'vim-puppet': }
  package { 'curl': }

  # Ensure ntp is installed.
  class { '::ntp': }

  # Install nodejs and associated node packages for gulp
  case $parrot_gulp_enabled {
    'true', true: {
      class { 'nodejs':
        #repo_url_suffix => '0.12',
      }
      package { 'bower':
        ensure   => present,
        provider => 'npm',
        require  => Class['nodejs'],
      }
      package { 'gulp':
        ensure   => present,
        provider => 'npm',
        require  => Class['nodejs'],
      }
      package { 'grunt-cli':
        ensure   => present,
        provider => 'npm',
        require  => Class['nodejs'],
      }
    }
  }
}
