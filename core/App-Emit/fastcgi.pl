#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab

use strict;
use warnings;
use FindBin;
use lib "$FindBin::RealBin/lib/";
use AnyEvent;
use AnyEvent::FCGI;
use App::Emit;
use HTTP::Request;
use Data::Dumper;

=head1 fastcgi.pl

fastcgi.pl - provides a FastCGI interface to App::Emit

=cut

my $emit = App::Emit->new;

# TODO: make port configurable
my $fcgi = AnyEvent::FCGI->new(
    port => 4441,
    on_request => sub {
        my ($req) = @_;

        # Fake a new HTTP::Request from the FastCGI request
        my $request = HTTP::Request->new(
            $req->params->{REQUEST_METHOD},
            $req->params->{REQUEST_URI}
        );
        $request->content($req->read_stdin);

        # Pass it to emit
        my $reply = $emit->handle_request($request);

        # Generate a FastCGI reply from the HTTP:Response
        $req->respond(
            $reply->decoded_content,
            'Content-Type' => 'text/html',
            'Status' => $reply->code
        );
    });

AnyEvent->loop;
