use inc::Module::Install;

name     'App-Emit';
all_from 'lib/App/Emit.pm';
author   'Tim Weber, Michael Stapelberg';

requires 'Moose';
requires 'JSON::XS';
requires 'Try::Tiny';
requires 'HTTP::Request';
requires 'HTTP::Response';
requires 'AnyEvent';
requires 'AnyEvent::FCGI';
requires 'AnyEvent::CouchDB';

WriteAll;
