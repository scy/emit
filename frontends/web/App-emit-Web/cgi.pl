#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use App::emit::dispatch;

App::emit::dispatch->dispatch();
