
class common {
  include 'stdlib'
  include 'apt'
  include 'ntp'
  class { 'vim': }
}

class webserver {
  include 'common'
  class{ 'apache':
    mpm_module => 'prefork',
  }
  
  class { '::php':
    ensure       => latest,
    manage_repos => true,
    dev          => true,
    composer     => true,
    pear         => true,
    phpunit      => false,
    extensions => {
      gd    => { },
    },
  }
  include apache::mod::php

  package { 'mysql-client-5.5':
    ensure => present,
  }
  package { 'php5-mysql':
    ensure => present,
  }
}

class mysql_server {
  # install mysql-server package
  class { '::mysql::server':
    root_password           => 'HwmysmvN63GuXEH4',
    remove_default_accounts => true,
    override_options => {
      mysqld => { bind_address => '0.0.0.0'} #Allow remote connections
    },
  }

}

node db1 {
  include 'mysql_server'
}

node web1 {
  include 'webserver'
  apache::vhost { 'loc.linkhub.dev':
    port    => '80',
    docroot => '/srv/www',
  }
}

node web2 {
  include 'webserver'
}

node proxy {
  include 'common'
  class { 'varnish':
    secret => '6565bd1c-b6d1-4ba3-99bc-3c7a42ffd94f',
  }
  varnish::vcl { '/etc/varnish/default.vcl':
    content => template('varnish/default.vcl.erb'),
  }
}

node default {
  include 'common'
}
