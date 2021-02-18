unit module Brodie::Routers;

sub router-id($route) is export { $route }

sub ext2html($route)  is export { $route.IO.extention: 'html' }
