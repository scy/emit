package App::emit::New;
# vim:ts=4:sw=4:expandtab

use base ('CGI::Application::Plugin::HTCompiled', 'CGI::Application');
use CGI::Carp qw(fatalsToBrowser);
use v5.10;
use Data::Dumper;
use HTML::Template::Compiled;
use emit;
use List::MoreUtils qw(apply);

sub setup {
    my $self = shift;

    $self->tmpl_path('/home/michael/emit/frontends/web/App-emit-Web/templates/');
    $self->run_modes([ 'new_issue' ]);
    $self->mode_param('rm');
    $self->start_mode('new_issue');
}

sub new_issue {
    my $self = shift;
    my $emit = emit->new;
    my $tmpl = $self->load_tmpl('new.tmpl');
    my @fields = @{$emit->fields};

    if ($self->query->param('submit')) {
        # Collect the data which the user sent
        my $query = $self->query;

        # Only keep the name of each field
        @fields = map { $_->{name} } @fields;

        # Strip out the fields which were not submitted
        @fields = grep { $query->param($_) } @fields;

        # Generate a hash out of the submitted fields
        my %submitted = map { ($_, $query->param($_)) } @fields;

        my ($status, $msg) = $emit->create_bug(\%submitted);
        # TODO: templates for the status / redirect to the bug detail page
        if ($status) {
            return 'Bug successfully created: ' . $msg;
        } else {
            return 'Error: ' . $msg;
        }
    } else {
        apply { $_->{type} = 'field_' . $_->{type} . '.tmpl' } @fields;

        # TODO: user’s $LANG. set name to display, strip other name-<LANG> fields
        apply { if (defined($_->{'name-en'})) { $_->{displayname} = $_->{'name-en'} } else { $_->{displayname} = $_->{name}; } } @fields;

        $tmpl->param(FIELDS => \@fields);

        return $tmpl->output;
    }
}

1
