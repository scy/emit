use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::FRQBugtracker::Web',
    AUTHOR              => 'Michael Stapelberg <michael+frqbt@stapelberg.de>',
    VERSION_FROM        => 'lib/App/FRQBugtracker/Web.pm',
    ABSTRACT_FROM       => 'lib/App/FRQBugtracker/Web.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'App-FRQBugtracker-Web-*' },
);
