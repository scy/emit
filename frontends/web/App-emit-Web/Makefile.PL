use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::emit::Web',
    AUTHOR              => 'Michael Stapelberg <michael+emit@stapelberg.de>',
    VERSION_FROM        => 'lib/App/emit/Web.pm',
    ABSTRACT_FROM       => 'lib/App/emit/Web.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'App-emit-Web-*' },
);
