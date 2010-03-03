package App::Emit::Backend::CouchDB;
# vim:ts=4:sw=4:expandtab

use Moose;
use Data::Dumper;
use AnyEvent::CouchDB;

has '_db' => (is => 'rw', isa => 'AnyEvent::CouchDB::Database', init_arg => undef);

sub BUILD {
    my ($self) = @_;

    my $couch = couch('http://localhost:5984/');
    my $db = $couch->db('emit');

    $self->_db($db);
}

=head2 write($req)

Writes the given document to the database (updates if necessary).

=cut
sub write {
    my ($self, $req) = @_;

    # If this is an update, check if _rev is given
    if (defined($req->{_id}) && !defined($req->{_rev})) {
        die "Update without _rev\n";
    }

    $self->_db->save_doc($req)->recv;
    return { _id => $req->{_id} };
}

=head2 read($req)

Returns all issues matching the specified request.

=cut
sub read {
    my ($self, $req) = @_;

    if (defined($req->{_id})) {
        my $cv = $self->_db->open_doc($req->{_id});
        return $cv->recv;
    }

    # Get all documents
    # TODO: filter out keys which are not requested
    my $cv = $self->_db->view('bugs/all');
    my $doc = $cv->recv->{rows};
    
    $doc
}

1
