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

sub write {
    my ($self, $req) = @_;

    # If this is an update
    if (defined($req->{id})) {
        # TODO: update
    } else {
        # Create a new document
        $self->_db->save_doc($req)->recv;
        return { _id => $req->{_id} };
    }
}

sub read {
    my ($self, $req) = @_;

    my $cv = $self->_db->open_doc($req->{_id});
    my $doc = $cv->recv;
    
    $doc

#    $req->{
#
#    $self->_db->
}

1
