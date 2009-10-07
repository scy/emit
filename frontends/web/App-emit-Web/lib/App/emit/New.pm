package App::emit::New;

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
    apply { $_->{type} = 'field_' . $_->{type} . '.tmpl' } @fields;

    # TODO: user’s $LANG. set name to display, strip other name-<LANG> fields
    apply { if (defined($_->{'name-en'})) { $_->{displayname} = $_->{'name-en'} } else { $_->{displayname} = $_->{name}; } } @fields;

    $tmpl->param(FIELDS => \@fields);

    return $tmpl->output;
}

1
# vim:ts=4:sw=4:expandtab
