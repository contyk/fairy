package App::Fairy::Magic::Perl;
use strict;
use warnings;
use App::Fairy::Utils qw/fetch/;
use File::HomeDir;
use File::Spec;

sub _update_cpan_index {
    my $index = '02packages.details.txt.gz';
    my $indexpath = File::Spec->catfile(
        File::HomeDir->my_home, qw/.cpan sources modules/, $index);
    my $indexurl =
        ($ENV{CPAN} || "http://www.cpan.org/") . "/modules/${index}";
    fetch($indexurl, $indexpath);
}

_update_cpan_index();

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::Fairy::Magic::Perl - Fairy's Perl magic

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 Petr Šabata

See LICENSE for licensing details.

=cut
