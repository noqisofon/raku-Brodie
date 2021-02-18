unit module Brodie::Compiler;

sub plain-copy($src, $dest) is export {
    $src.IO.copy( $dest );
}
