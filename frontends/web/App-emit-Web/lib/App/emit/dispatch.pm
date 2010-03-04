package App::emit::dispatch;
# vim:ts=4:sw=4:expandtab

use strict;
use warnings;

use base 'CGI::Application::Dispatch';

sub dispatch_args {
    return {
        prefix => 'App::emit',
        table => [
            '' => { app => 'Start', rm => 'start' },
            'new' => { app => 'New', rm => 'new_issue' },
            'details' => { app => 'Detail', rm => 'detail' },
            'list' => { app => 'List', rm => 'list' },
            'delete' => { app => 'Detail', rm => 'delete' },
            'comment' => { app => 'Detail', rm => 'comment' },
            #'add[post]' => { app => 'Start', rm => 'add_post' },
            #':rm' => { app => 'Start' },
        ],
    };
}

1
