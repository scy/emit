#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'App::emit::Web' );
}

diag( "Testing App::emit::Web $App::emit::Web::VERSION, Perl $], $^X" );
