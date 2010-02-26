#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::Emit' ) || print "Bail out!
";
}

diag( "Testing App::Emit $App::Emit::VERSION, Perl $], $^X" );
