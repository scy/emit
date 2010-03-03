package App::emit::List;
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
    $self->run_modes([ 'list' ]);
    $self->mode_param('rm');
    $self->start_mode('list');
}

sub list {
    my $self = shift;
    my $emit = emit->new;
    my $tmpl = $self->load_tmpl('list.tmpl');
    my ($ok, $bugs) = $emit->list_bugs;

    if (!$ok) {
        return 'error: ' . $bugs;
    }

    my @bugs = @{$bugs};

    for my $bug (@bugs) {
        for my $key (keys %{$bug->{value}}) {
            $bug->{$key} = $bug->{value}->{$key};
        }
    }

    apply { $_->{shortid} = substr($_->{_id}, 0, 5) } @bugs;

    $tmpl->param(BUGS => \@bugs);

    return $tmpl->output;
}

1
