# Installation based on RStudio's Vagrant setup.sh script.
# https://github.com/rstudio/shiny-server/blob/master/vagrant/centos7/setup.sh
#
class shinyserver::install (
  $ensure      = $shinyserver::ensure,
  $package_url = $shinyserver::package_url,
) {

  if ! ($ensure in [ 'present', 'absent' ]) {
    fail('ensure parameter must be present or absent')
  }

  package { 'shiny-server':
    ensure   => $ensure,
    provider => 'rpm',
    source   => $package_url,
  }

  # RStudio's RPM creates a home and sets shell to /bin/sh, inappropriate
  # for a daemon process.
  # https://github.com/rstudio/shiny-server/issues/103
  # Fix this.
  user { 'shiny':
    home       => '/srv/shiny-server',
    managehome => false,
    shell      => '/sbin/nologin',
    require    => Package['shiny-server'],
  }
  file { '/home/shiny':
    ensure  => absent,
    force   => true,
    require => Package['shiny-server'],
  }

# The user of this module is responsible for installing dependencies
# using whatever method desired (RPM or R install.packages()).
#   ensure_packages([
#     'R-bitops',
#     'R-caTools',
#     'R-core',
#     'R-digest',
#     'R-evaluate',
#     'R-formatR',
#     'R-highr',
#     'R-htmltools',
#     'R-httpuv',
#     'R-jsonlite',
#     'R-knitr',
#     'R-magrittr',
#     'R-markdown',
#     'R-mime',
#     'R-R6',
#     'R-Rcpp',
#     'R-rmarkdown',
#     'R-shiny',
#     'R-stringi',
#     'R-stringr',
#     'R-xtable',
#     'R-yaml',
#   ])

# It might be desirable to allow installation using
# the `forward3ddev/r` Puppet module. The following
# is some starter directives. 'shiny-server' does
# not install correctly. I have not investigate why.
#   include r
#   ensure_packages('R-devel')
#   ::r::package { 'shiny': dependencies => true, }
#   ::r::package { 'shiny-server': dependencies => true, }
#   Package['R-devel'] -> R::Package['shiny']
}