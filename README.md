[![Actions Status](https://github.com/tbrowder/File-Find/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/File-Find/actions) [![Actions Status](https://github.com/tbrowder/File-Find/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/File-Find/actions) [![Actions Status](https://github.com/tbrowder/File-Find/actions/workflows/windows-spec.yml/badge.svg)](https://github.com/tbrowder/File-Find/actions)

NAME
====

File::Find - Get a lazy list of a directory tree

SYNOPSIS
========

    use File::Find;

    # recursively (and eagerly) find all files from the 'foo' directory
    my @list = find(dir => 'foo');
    say @list[0..3];

    # the same as above, but lazily return the results
    my $list = find(dir => 'foo');
    say $list[0..3];

    # eagerly find all Perl-related files from the current directory
    my @perl-files = find(dir => '.', name => / "." p [l||m] $ /);

    # lazily find all directories within the 'rakudo' directory
    my $rakudo-dirs = find(dir => 'rakudo', type => 'dir');

    # lazily find all symlinks a normal user can access under `/etc`
    my $etc-symlinks = find(dir => '/etc/', type => 'symlink', keep-going => True);

DESCRIPTION
===========

`File::Find` allows you to get the contents of the given directory, recursively, depth first.

The only exported function, `find()` , generates a lazy list of files in given directory. Every element of the list is an `IO::Path` object, described below.

`find()` takes one (or more) named arguments. The `dir` argument is mandatory, and sets the directory `find()` will traverse.

There are also a few named arguments. If more than one is passed, all of them must match for a file to be returned.

name
----

Specify a name of the file `File::Find` is ought to look for. If you pass a string here, `find()` will return only the files with the given name. When passing a regex, only the files with path matching the pattern will be returned. Any other type of argument passed here will just be smartmatched against the path (which is exactly what happens to regexes passed, by the way).

type
----

Given a type, `find()` will only return files being the given type. The available types are `file`, `dir`, or `symlink`.

exclude
-------

Specify a regex (or any other smartmatchable type) to exclude files / directories from the search.

recursive
---------

By default, `find` will recursively traverse a directory tree, descending into any subdirectories it finds. This behavior can be changed by setting `recursive` to a false value. In this case, only the first-level entries will be processed.

keep-going
----------

Parameter `keep-going` tells `find()` to not stop finding files on errors such as 'Access is denied', but rather ignore the errors and keep going.

**Note: This parameter is currently broken and does not affect the search in any way.**

Perl's File::Find
=================

Please note that this module is not trying to be the verbatim port of Perl's File::Find module. Its interface is closer to Perl's File::Find::Rule, and its features are planned to be similar one day.

CAVEATS
=======

List assignment is eager in Raku, so if you assign `find()` result to an array, the elements will be copied and the laziness will be spoiled. For a proper lazy list, use either binding (`:=`) or assign a result to a scalar value (see SYNOPSIS).

