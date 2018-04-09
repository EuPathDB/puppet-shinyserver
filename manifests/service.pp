# manage Shiny Server service.
# If Shiny package is `ensure => present` then the
# service is started and enabled. Otherwise, the service
# is stopped and not enabled. There is no option to
# install the Shiny package without running the service.
class shinyserver::service {

  if $shinyserver::ensure == 'present' {
    $service_ensure = true
    $service_enable = true
  } else {
    $service_ensure = false
    $service_enable = false
  }

  service { $shinyserver::params::service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }

}
