use v6;

unit class Brodie;

=begin pod

=head1 NAME

Brodie - simple static website generator

=head1 SYNOPISIS

=head1 AUTHOR

Ned Rihine

=end pod

has %.rules is rw;

method build($src = 'src', $dest = 'dest') {
    say "Building site to <$dest>, source is <$src> ...";

    mkdir $dest unless $dest.IO.d;

    %!rules<_begin>() if %!rules<_begin>:exists;

    my @files = my-find( $src );
    note @files;
    for @files -> $file {
	self.process( $file, $src, $dest );
    }

    %!rules<_end>( $dest ) if %!rules<_end>:exists;
}

method process($file, $src, $dest) {
    say "Processing: $file";
    for %!rules.keys -> $key {
	next if $key ~~ m/^_/;
	if match( $file, $key ) {
	    my $target = $dest ~ %!rules{$key}<router>( $file.subst( /^$src/, '' ) );

	    note $target;

	    ensure-direname( $target );

	    %!rules{$key}<compiler>( $file, $target );
	}
    }
}

sub my-find($dir) {
    my @files;

    my @todo = $dir.IO;
    while @todo {
	for @todo.pop.dir -> $path {
	    @files.push: $path.Str unless $path.d;
	    @todo.push: $path      if     $path.d;
	}
    }

    @files
}

sub match($file, $expr) {
    my $basename     = $file.IO.basename;

    my ($left, $right) = $expr.split( '*' );

    so $file ~~ /$left .*? $right/
}

sub ensure-direname($target) {
    my $dir-name = $target.IO.dirname;

    mkdir $dir-name unless $dir-name.d;
}
