package emit;
# vim:ts=4:sw=4:expandtab

use Moose;
use JSON::XS;
use AnyEvent::HTTP;
use Try::Tiny;

use Data::Dumper;

has 'version' => (is => 'ro', isa => 'Str', default => 'foo');

sub fields {
    my ($self) = @_;
    # TODO: correctly format the fields if given
    # TODO: correctly receive the fields via HTTP and decode the JSON

    return [
        { name => 'description', type => 'line', default => '' },
        { name => 'comment', type => 'text', default => '' },
        { name => 'type', type => 'list', allowed => [ qw(bug feature-request task) ] },
        { name => 'priority', type => 'list', allowed => [ qw(important normal minor) ] },
        { name => 'version', type => 'list', allowed => [ qw(3.a 3.b 3.c) ] },
        { name => 'os', type => 'list', 'name-en' => 'Operating System', allowed => [ 'Affects all', 'Linux', 'BSD', 'Other' ] },
        { name => 'distro', type => 'line', 'name-en' => 'Distribution / flavor' },
        { name => 'notfinal', type => 'checkbox', 'name-en' => 'I recognize this software is not final' },
    ];
}

=head2 _emit_request($url, $request)

Returns a tuple of either:
(0, $internal_error_message)
(0, $emit_error_message)
(1, $document_id)

=cut
sub _emit_request {
    my ($self, $url, $request) = @_;

    my $json = encode_json $request;
    my $cv = AnyEvent->condvar;
    http_post $url, $json, sub { $cv->send(@_) };
    my ($body, $headers) = $cv->recv;

    if ($headers->{Status} =~ /^59/) {
        # Internal error (could not resolve host, …)
        return (0, $headers->{Reason});
    }

    unless ($headers->{Status} =~ /^2/) {
        # EMIT error, just pass on the message
        return (0, $body);
    }

    # everything went well, try to decode the body’s JSON and return _id
    my $res;
    try { $res = decode_json $body };

    (1, $res)
}

=head2 create_bug($fields)

Submits this create bug request to EMIT.
See _emit_request for return codes.

=cut
sub create_bug {
    my ($self, $bug) = @_;
    my ($ok, $res) = $self->_emit_request('http://localhost:81/write', $bug);
    return ($ok, $res) unless $ok;

    return (0, 'Invalid response from EMIT core') unless defined($res->{_id});

    (1, $res->{_id})
}

=head2 get_bug($id)

Gets the bug identified by $id from EMIT.
See _emit_request for return codes.

=cut
sub get_bug {
    my ($self, $id) = @_;
    my ($ok, $res) = $self->_emit_request('http://localhost:81/read', { _id => $id});
    return ($ok, $res) unless $ok;
    # TODO: check for errors?
    #return (0, 'Invalid response from EMIT core') unless defined($res->{_id});

    (1, $res)
}

=head2 list_bugs

Lists all bugs (TODO: filters).
See _emit_request for return codes.

=cut
sub list_bugs {
    my ($self, $filter) = @_;
    my ($ok, $res) = $self->_emit_request('http://localhost:81/read', {});
    return ($ok, $res) unless $ok;
    # TODO: check for errors?
    #return (0, 'Invalid response from EMIT core') unless defined($res->{_id});

    (1, $res)
}

=head2 delete_bug($id)

Deletes the bug identified by $id
See _emit_request for return codes.

=cut

sub delete_bug {
    my ($self, $id) = @_;
    my ($ok, $res) = $self->_emit_request('http://localhost:81/delete', { _id => $id });
    return ($ok, $res) unless $ok;

    return (0, 'Invalid response from EMIT core') unless defined($res->{ok});

    return (1);
}

1
