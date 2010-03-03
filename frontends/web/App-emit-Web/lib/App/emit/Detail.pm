package App::emit::Detail;
# vim:ts=4:sw=4:expandtab

use base ('CGI::Application::Plugin::HTCompiled', 'CGI::Application');
use CGI::Carp qw(fatalsToBrowser);
use v5.10;
use FindBin;
use Data::Dumper;
use HTML::Template::Compiled;
use emit;
use List::MoreUtils qw(apply);

sub setup {
    my $self = shift;

    $self->tmpl_path("$FindBin::RealBin/templates/");
    $self->run_modes([ qw(detail delete) ]);
    $self->mode_param('rm');
    $self->start_mode('detail');
}

sub detail {
    my $self = shift;
    my $emit = emit->new;
    my $tmpl = $self->load_tmpl('detail.tmpl');
    my @fields = @{$emit->fields};
    my $id = $self->query->param('id');

    my ($ok, $bug) = $emit->get_bug($id);
    if (!$ok) {
        return 'error: ' . $bug;
    }

    # Integrate key/value pairs into @fields
    for my $field (@fields) {
        my $name = $field->{name};
        # We set 'value' for each field so that the value is available when
        # it is needed inside the template, even if it is empty.
        $field->{value} = '' . $bug->{$name};
    }

    apply { $_->{type} = 'detail_' . $_->{type} . '.tmpl' } @fields;

    # TODO: user’s $LANG. set name to display, strip other name-<LANG> fields
    apply { if (defined($_->{'name-en'})) { $_->{displayname} = $_->{'name-en'} } else { $_->{displayname} = $_->{name}; } } @fields;

    $tmpl->param(FIELDS => \@fields, ID => $id);

    return $tmpl->output;
}

sub delete {
    my $self = shift;
    my $emit = emit->new;
    my $tmpl = $self->load_tmpl('detail.tmpl');
    my @fields = @{$emit->fields};
    my $id = $self->query->param('id');

    # TODO: check privileges
    my ($ok, $err) = $emit->delete_bug($id);

    if (!$ok) {
        return 'error deleting: ' . $err;
    }
    $self->header_type('redirect');
    $self->header_props('-url' => '/list?msg=deleted');
    return 'Bug deleted, redirecting to /list';
}

1
