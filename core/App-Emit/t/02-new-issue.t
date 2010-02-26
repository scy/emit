#!perl -T

use Test::More tests => 10;
use Test::Deep;
use App::Emit;
use HTTP::Request;
use JSON::XS;
use Data::Dumper;

my $emit = App::Emit->new;

my %issue = (
	foo => 'bar',
	bar => 'baz'
);

#############################################
# Build up an HTTP request for storing %issue
#############################################

my $request = HTTP::Request->new(POST => '/write');
$request->content(encode_json(\%issue));

my $reply = $emit->handle_request($request);
isa_ok($reply, 'HTTP::Response');
my $answer = decode_json($reply->content);

ok(defined($answer->{_id}), 'answer contains an ID');
ok(length($answer->{_id}) > 0, 'ID is not empty');

############################
# Now read back the document
############################

$request = HTTP::Request->new(POST => '/read');
$request->content(encode_json({ _id => $answer->{_id} }));

$reply = $emit->handle_request($request);
isa_ok($reply, 'HTTP::Response');
$answer = decode_json($reply->content);

cmp_deeply($answer, superhashof(\%issue), 'read correct issue');

###################################
# Modify the document and update it
###################################

%issue = %{$answer};
$issue{new_key} = 'new value';

$request = HTTP::Request->new(POST => '/write');
$request->content(encode_json(\%issue));

$reply = $emit->handle_request($request);
isa_ok($reply, 'HTTP::Response');
my $answer = decode_json($reply->content);

ok(defined($answer->{_id}), 'answer contains an ID');
is($answer->{_id}, $issue{_id}, 'ID unchanged');

$request = HTTP::Request->new(POST => '/read');
$request->content(encode_json({ _id => $answer->{_id} }));

$reply = $emit->handle_request($request);
isa_ok($reply, 'HTTP::Response');
$answer = decode_json($reply->content);

$issue{_rev} = ignore();
cmp_deeply($answer, \%issue, 'issue was updated in db');

diag( "Testing App::Emit $App::Emit::VERSION, Perl $], $^X" );
