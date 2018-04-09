# optionally manage Shiny Server configuration
class shinyserver::config {

  $srv_run_as          = $shinyserver::srv_run_as
  $srv_listen_port     = $shinyserver::srv_listen_port
  $srv_site_dir        = $shinyserver::srv_site_dir
  $srv_log_dir         = $shinyserver::srv_log_dir
  $srv_directory_index = $shinyserver::srv_directory_index

  if $shinyserver::manage_config {
    file { '/etc/shiny-server/shiny-server.conf':
      ensure  => 'present',
      content => template('shinyserver/shiny-server.conf.erb'),
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
    }
  }
}
