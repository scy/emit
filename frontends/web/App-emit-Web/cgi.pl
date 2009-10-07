#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use App::emit::dispatch;

App::emit::dispatch->dispatch();
