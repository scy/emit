package App::emit::Start;
# vim:ts=4:sw=4:expandtab

use base 'CGI::Application';
use v5.10;
use FindBin;
use Data::Dumper;
use HTML::Template;
use emit;

sub setup {
    my $self = shift;

    $self->tmpl_path("$FindBin::RealBin/templates/");
    $self->run_modes([ 'start', 'new_issue' ]);
    $self->mode_param('rm');
    $self->start_mode('start');
}

sub start {
    my $self = shift;
    my $emit = emit->new;

    my $tmpl = $self->load_tmpl('index.tmpl');
    #HTML::Template->new(filename => 'index.tmpl');

    return $tmpl->output;
}

1
