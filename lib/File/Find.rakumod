unit module File::Find;

sub checkrules (IO::Path $elem, %opts) {
    with %opts<name> -> $opts {
        return False unless $elem.basename ~~ $opts
    }
    with %opts<type>  {
        when 'dir' {
            return False unless $elem ~~ :d
        }
        when 'file' {
            return False unless $elem ~~ :f
        }
        when 'symlink' {
            return False unless $elem ~~ :l
        }
        default {
            die "type attribute has to be dir, file or symlink";
        }
    }
    return True
}

sub find (:$dir!, :$name, :$type, :$exclude = False, Bool :$recursive = True,
    Bool :$keep-going = False) is export {

    my @targets = dir($dir);
    gather while @targets {
        my $elem = @targets.shift;
        # exclude is special because it also stops traversing inside,
        # which checkrules does not
        next if $elem ~~ $exclude;
        take $elem if checkrules($elem, { :$name, :$type, :$exclude });
        if $recursive {
            if $elem.IO ~~ :d {
                @targets.append: dir($elem);
                CATCH { when X::IO::Dir {
                    $_.throw unless $keep-going;
                    next;
                }}
            }
        }
    }
}
