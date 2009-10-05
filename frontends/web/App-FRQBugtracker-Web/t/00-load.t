#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'App::FRQBugtracker::Web' );
}

diag( "Testing App::FRQBugtracker::Web $App::FRQBugtracker::Web::VERSION, Perl $], $^X" );
