class passenger {

  package {
    "apache2-prefork-dev":
      ensure => present
  }

  exec {
    "/usr/local/bin/gem install passenger -v=3.0.9":
      user    => root,
      group   => root,
      alias   => "install_passenger",
      before  => [File["passenger_conf"],Exec["passenger_apache_module"]],
      unless  => "ls /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.9/"
  }

  exec {
  "/usr/local/bin/passenger-install-apache2-module --auto":
    user    => root,
    group   => root,
    path    => "/bin:/usr/bin:/usr/local/apache2/bin/",
    alias   => "passenger_apache_module",
    before  => File["passenger_conf"],
    require => Package["apache2-prefork-dev"],
    unless  => "ls /usr/local/lib/ruby/gems/1.9.1/gems/\
passenger-3.0.9/ext/apache2/mod_passenger.so"
}

  file {
    "/etc/apache2/conf.d/passenger.conf":
      mode    => 644,
      owner   => root,
      group   => root,
      alias   => "passenger_conf",
      notify  => Service["apache2"],
      source  => "puppet:///modules/passenger/passenger.conf"
  }
}
