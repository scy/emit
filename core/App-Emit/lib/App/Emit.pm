package App::Emit;
# vim:ts=4:sw=4:expandtab

use Moose;
use HTTP::Response;
use JSON::XS;
use App::Emit::Backend::CouchDB;
use Try::Tiny;

=head1 NAME

App::Emit - The great new App::Emit!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';



=head1 SUBROUTINES/METHODS

=head2 parse_request

Takes an HTTP::Request, runs it through all configured hooks, passes it
to the backend and returns an HTTP::Response.

=cut
sub handle_request {
    my ($self, $request) = @_;

    die "No request passed" unless $request;

    print "request to " . $request->uri . "\n";

    # Provide a friendly message if anyone stumbles upon this server
    if ($request->uri eq '/') {
        my $response = HTTP::Response->new(200);
        $response->content("This is the core HTTP interface of EMIT.\n");
        return $response;
    }

    # TODO: sanity checking:
    # 1) does the request contain any internal fields (starting with !), which
    #    are not implemented?
    # 2) is the api version compatible?

    my $req = undef;
    my $response;
    try {
        $req = decode_json($request->content);
    } catch {
        $response = HTTP::Response->new(500);
        $response->content('Could not decode JSON: ' . $_);
    };
    # We cannot directly return from the catch block, so we check here if
    # the request could be decoded
    return $response unless defined($req);

    my $be = App::Emit::Backend::CouchDB->new;
    my $answer;
    try {
        if ($request->uri eq '/write') {
            $answer = $be->write($req);
        } elsif ($request->uri eq '/read') {
            $answer = $be->read($req);
        } elsif ($request->uri eq '/delete') {
            $answer = $be->delete($req);
        } else {
            return HTTP::Response->new(404);
        }

        $response = HTTP::Response->new(200);
        $response->content(encode_json($answer));
    } catch {
        $response = HTTP::Response->new(500);
        $response->content('Backend died with error: ' . $_);
    };

    return $response
}

1
