package App::Fairy::Magic::Perl;
use strict;
use warnings;
use App::Fairy::Meta;
use App::Fairy::Utils qw/fetch/;
use File::HomeDir;
use File::Spec;

my $index = '02packages.details.txt.gz';
my $indexpath = File::Spec->catfile(
    File::HomeDir->my_home, qw/.cpan sources modules/, $index);
my $indexurl =
    ($ENV{CPAN} || "http://www.cpan.org/") . "/modules/${index}";

sub _update_cpan_index {
    fetch($indexurl, $indexpath);
}

sub _get_distribution {
    my $token = shift;
    my $packages;
    eval {
        require Parse::CPAN::Packages::Fast;
        $packages = Parse::CPAN::Packages::Fast->new($indexpath);
        1;
    } or do {
        require Parse::CPAN::Packages;
        $packages = Parse::CPAN::Packages->new($indexpath);
    };
    $packages
        or die "CPAN index parsing failure.\n";
    my $p = $packages->package($token)
        or die "Cannot find `$token' in the CPAN index.\n";
    my $d = $p->distribution
        or die "Cannot map `$token' to any CPAN distribution.\n";
    return $d;
}

sub new {
    return bless {}, shift;
}

sub do {
    my ($self, $spell) = @_;
    _update_cpan_index();
    my $dist = _get_distribution($spell);
    print $dist->dist."\n".$dist->version."\n";
}

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
