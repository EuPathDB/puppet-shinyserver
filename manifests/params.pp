# Parameters for installing RStudio Shiny Server.
# See https://github.com/rstudio/shiny-server/blob/master/vagrant/centos7/setup.sh
# for current values.
class shinyserver::params {

  $ensure = 'present'

  # $os_build_platform is the OS name under which RStudio distributes the
  # latest version Shiny Server. It is independent of the OS on which
  # this module is deployed.
  $os_build_platform  = 'centos6.3'
  $os_build_arch      = 'x86_64'
  $download_url_base  = 'https://s3.amazonaws.com/rstudio-shiny-server-os-build'
  $current_ss_version = inline_template("<%= 
    %x{
      /usr/bin/curl -s ${download_url_base}/${os_build_platform}/x86_64/VERSION
    }.chomp 
  %>")
  $rpm_name    = "shiny-server-${current_ss_version}-rh6-x86_64.rpm"
  $package_url = "${download_url_base}/${os_build_platform}/x86_64/${rpm_name}"

  $service_name = 'shiny-server'

  $srv_run_as = 'shiny'
  $srv_listen_port = '3838'
  $srv_site_dir = '/srv/shiny-server'
  $srv_log_dir = '/var/log/shiny-server'
  $srv_directory_index = 'on'
  $manage_config = true
}