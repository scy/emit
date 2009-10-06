#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok('emit');
}

# TODO: Start a manager instance with a custom configuration, so that we can
# predict the field values and so on.

my $emit = emit->new();

my $expected = [ { name => 'version', type => 'line', default => '3.c' } ];

is_deeply($emit->fields(), $expected, 'Fields are correctly returned');

diag( "Testing emit, Perl $], $^X" );
