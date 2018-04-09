# The URL for the shiny-server RPM is constructed in the `shinyserver::params` class or 
# it can be passed as $package_url (`shinyserver::package_url` in hiera).

class shinyserver (
  $ensure              = $shinyserver::params::ensure,
  $manage_config       = $shinyserver::params::manage_config,
  $package_url         = $shinyserver::params::package_url,
  $srv_run_as          = $shinyserver::params::srv_run_as,
  $srv_listen_port     = $shinyserver::params::srv_listen_port,
  $srv_site_dir        = $shinyserver::params::srv_site_dir,
  $srv_log_dir         = $shinyserver::params::srv_log_dir,
  $srv_directory_index = $shinyserver::params::srv_directory_index,
) inherits shinyserver::params {

  include '::stdlib'
  contain '::shinyserver::install'
  contain '::shinyserver::service'
  contain '::shinyserver::config'

  Class['shinyserver::install'] ->
  Class['shinyserver::config'] ~>
  Class['shinyserver::service']
}