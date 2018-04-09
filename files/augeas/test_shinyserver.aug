module Test_shinyserver =

let conf ="run_as shiny;
server {
  listen 3838;

  # Define a location at the base URL
  location / {
    site_dir /srv/shiny-server;
    log_dir /var/log/shiny-server;

    # When a user visits the base URL rather than a particular application,
    # an index of the applications available in this directory will be shown.
    directory_index on;
  }
}
server {
  listen 3838;
  location / {
    server_name sa.vm.org;
    run_as vagrant;
    site_dir /srv/shiny-server;
    log_dir /var/log/shiny-server;
    directory_index on;
  }
}
"

test ShinyServer.lns get conf = 
  { "run_as" = "shiny" }
  { "server"
    { "listen" = "3838" }
    {}
    { "#comment" = "Define a location at the base URL" }
    { "location" { "#uri" = "/" } 
        { "site_dir" = "/srv/shiny-server" }
        { "log_dir" = "/var/log/shiny-server" }
        {}
        { "#comment" = "When a user visits the base URL rather than a particular application," }
        { "#comment" = "an index of the applications available in this directory will be shown." }
        { "directory_index" = "on" }
    }
  }
  { "server"
    { "listen" = "3838" }
    { "location" { "#uri" = "/" } 
        { "server_name" = "sa.vm.org" }
        { "run_as" = "vagrant" }
        { "site_dir" = "/srv/shiny-server" }
        { "log_dir" = "/var/log/shiny-server" }
        { "directory_index" = "on" }
    }
  }
