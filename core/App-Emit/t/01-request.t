#!perl -T

use Test::More tests => 1;
use Test::Exception;
use App::Emit;

my $emit = App::Emit->new;

dies_ok { $emit->handle_request } 'invalid request dies';

# TODO: test invalid json

diag( "Testing App::Emit $App::Emit::VERSION, Perl $], $^X" );
