#!/bin/env raku

use Markdown::Grammar;
use Proc::Easier;

my $imd = "../docs/README.md";
my $out = "t.pod6.2";

my $args = "from-markdown $imd --to=pod6 --output=$out";
my $res  = cmd $args;



