package App::emit::Start;

use base 'CGI::Application';
use v5.10;
use Data::Dumper;

sub setup {
    my $self = shift;

    $self->run_modes([ 'start' ]);
    $self->mode_param('rm');
    $self->start_mode('start');
}

sub start {
    my $self = shift;

	return 'foo';
}

1
# vim:ts=4:sw=4:expandtab
