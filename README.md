## shinyserver

Installs RStudio Shiny Server


### Usage

    include shinyserver
    

This will install the software and start the service.

The URL for the shiny-server RPM is constructed in the `shinyserver::params` class or 
it can be passed as `$rpm_url` (or as `shinyserver::rpm_url` in hiera).

To remove the Shiny software and service, set `ensure => absent`. In hiera,

    shinyserver::ensure: absent

If Shiny package is `ensure => present` (the default) then the service
is started and enabled. Otherwise, the servic is stopped and not
enabled. There is no option to install the Shiny package without running
the service.


### Requirements

The latest RPM for `shiny-server` will be downloaded from RStudio's
website and installed. The latest supported version is determined from a
`VERSION` file on RStudio's website. This determination depends on an
up-to-date value for `$os_build_platform` in this module's
`shinyserver::params` class. The logic for getting the latest RPM is
derived from
https://github.com/rstudio/shiny-server/blob/master/vagrant/centos7/setup.sh

The module also requires several R libraries that must be installed
before calling this module. The following YUM packages are examples
(there may be additional packages not listed).

    R-bitops
    R-caTools
    R-core
    R-digest
    R-evaluate
    R-formatR
    R-highr
    R-htmltools
    R-httpuv
    R-jsonlite
    R-knitr
    R-magrittr
    R-markdown
    R-mime
    R-R6
    R-Rcpp
    R-rmarkdown
    R-shiny
    R-stringi
    R-stringr
    R-xtable
    R-yaml

Most of these packages are not in a public YUM repository (AFAIK) so you
may need to package and host them yourself. You will also need to
configure the YUM repository on the node before calling this module.

Alternatively you can install these libraries via R's `install.packages()`.
