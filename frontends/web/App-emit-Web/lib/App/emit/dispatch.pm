package App::emit::dispatch;

use strict;
use warnings;

use base 'CGI::Application::Dispatch';

sub dispatch_args {
    return {
        prefix => 'App::emit',
        table => [
            '' => { app => 'Start', rm => 'start' },
            #'vote[post]' => { app => 'Start', rm => 'vote_post' },
            #'add[post]' => { app => 'Start', rm => 'add_post' },
            #':rm' => { app => 'Start' },
        ],
    };
}

1
# vim:ts=4:sw=4:expandtab

