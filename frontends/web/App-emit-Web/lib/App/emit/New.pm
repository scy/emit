package App::emit::New;

use base 'CGI::Application';
use v5.10;
use Data::Dumper;
use HTML::Template;
use emit;

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

    $tmpl->param(FIELDS => $emit->fields);

    return $tmpl->output;
}

1
# vim:ts=4:sw=4:expandtab
