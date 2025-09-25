my sub checkrules(IO::Path:D $io, %opts) {
    with %opts<name> -> $opts {
        return False unless $io.basename ~~ $opts
    }
    with %opts<type>  {
        when 'dir' {
            return False unless $io.d;
        }
        when 'file' {
            return False unless $io.f;
        }
        when 'symlink' {
            return False unless $io.l;
        }
        default {
            die "type attribute has to be dir, file or symlink";
        }
    }
    True
}

#- find ------------------------------------------------------------------------
my sub find(
       :$dir!,
  Mu   :$name,
       :$type,
  Mu   :$exclude         = False,
  Bool :$recursive       = True,
  Bool :$keep-going      = False,
  Bool :$follow-symlinks = True
) is export {

    my @targets = dir($dir);
    gather while @targets {
        my $elem = @targets.shift;
        # exclude is special because it also stops traversing inside,
        # which checkrules does not
        next if $elem ~~ $exclude;

        take $elem if checkrules($elem, { :$name, :$type, :$exclude });

        if $recursive {
            my $io := $elem.IO;
            if $follow-symlinks || !$io.l {
                if $io.d {
                    @targets.append: dir($elem);
                    CATCH {
                        when X::IO::Dir {
                            .rethrow unless $keep-going;
                            next;
                        }
                    }
                }
            }
        }
    }
}

#- hack ------------------------------------------------------------------------
# To allow version fetching in test files
unit module File::Find:ver<0.2.3>:auth<zef:raku-community-modules>;

# vim: expandtab shiftwidth=4
