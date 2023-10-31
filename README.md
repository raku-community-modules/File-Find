[![Actions Status](https://github.com/raku-community-modules/File-Find/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/File-Find/actions) [![Actions Status](https://github.com/raku-community-modules/File-Find/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/File-Find/actions) [![Actions Status](https://github.com/raku-community-modules/File-Find/actions/workflows/windows-spec.yml/badge.svg)](https://github.com/raku-community-modules/File-Find/actions)

NAME
====

File::Find - Get a lazy sequence of a directory tree

SYNOPSIS
========

    use File::Find;

    my @list = lazy find(dir => 'foo');  # Keep laziness
    say @list[0..3];

    my $list = find(dir => 'foo');       # Keep laziness
    say $list[0..3];

    my @list = find(dir => 'foo');       # Drop laziness
    say @list[0..3];

DESCRIPTION
===========

`File::Find` allows you to get the contents of the given directory, recursively, depth first. The only exported function, `find()`, generates a `Seq` of files in given directory. Every element of the `Seq` is an `IO::Path` object, described below. `find()` takes one (or more) named arguments. The `dir` argument is mandatory, and sets the directory `find()` will traverse. There are also few optional arguments. If more than one is passed, all of them must match for a file to be returned.

name
----

Specify a name of the file `File::Find` is ought to look for. If you pass a string here, `find()` will return only the files with the given name. When passing a regex, only the files with path matching the pattern will be returned. Any other type of argument passed here will just be smartmatched against the path (which is exactly what happens to regexes passed, by the way).

type
----

Given a type, `find()` will only return files being the given type. The available types are `file`, `dir` or `symlink`.

exclude
-------

Exclude is meant to be used for skipping certain big and uninteresting directories, like '.git'. Neither them nor any of their contents will be returned, saving a significant amount of time.

The value of `exclude` will be smartmatched against each IO object found by File::Find. It's recommended that it's passed as an IO object (or a Junction of those) so we avoid silly things like slashes vs backslashes on different platforms.

keep-going
----------

Parameter `keep-going` tells `find()` to not stop finding files on errors such as 'Access is denied', but rather ignore the errors and keep going.

recursive
---------

By default, `find` will recursively traverse a directory tree, descending into any subdirectories it finds. This behaviour can be changed by setting `recursive` to a false value. In this case, only the first level entries will be processed.

Perl's File::Find
=================

Please note, that this module is not trying to be the verbatim port of Perl's File::Find module. Its interface is closer to Perl's File::Find::Rule, and its features are planned to be similar one day.

CAVEATS
=======

List assignment is eager by default in Raku, so if you assign a `find()` result to an array, the laziness will be dropped by default. To keep the laziness either insert `lazy` or assign to a scalar value (see SYNOPSIS).

