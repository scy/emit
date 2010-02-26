package App::Emit;
# vim:ts=4:sw=4:expandtab

use Moose;
use HTTP::Response;
use JSON::XS;
use App::Emit::Backend::CouchDB;

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

    # TODO: sanity checking:
    # 1) does the request contain any internal fields (starting with !), which
    #    are not implemented?
    # 2) is the api version compatible?
    my $req = decode_json($request->content);

    my $be = App::Emit::Backend::CouchDB->new;
    my $answer;
    if ($request->uri eq '/write') {
        $answer = $be->write($req);
    } elsif ($request->uri eq '/read') {
        $answer = $be->read($req);
    }

    my $response = HTTP::Response->new(200);
    $response->content(encode_json($answer));

    return $response
}

1
