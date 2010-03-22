use strict;
use Test::More;

local $ENV{ANY_MOOSE} = 'Moose';

my @files = <t/*.t>;
plan tests => scalar @files;

while (my $file = shift @files) {
    subtest $file => sub { do $file };
}