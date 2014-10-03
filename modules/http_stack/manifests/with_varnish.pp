class http_stack::with_varnish(
  $apache_http_port  = $parrot_https_port,
  $apache_https_port  = $parrot_https_port,
  $varnish_port      = $parrot_varnish_port
) {

  class { http_stack:
    varnish_port => $varnish_port,
    apache_http_port => $apache_http_port,
    apache_https_port => $apache_https_port,
  }

}
