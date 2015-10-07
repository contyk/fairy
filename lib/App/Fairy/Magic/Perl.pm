package App::Fairy::Magic::Perl;
use strict;
use warnings;
use App::Fairy::Meta;
use App::Fairy::Utils qw/explode fetch/;
use File::Find::Rule;
use File::Find::Rule::Perl;
use File::HomeDir;
use File::Spec;
use Tangerine;

my $index = '02packages.details.txt.gz';
my $indexpath = File::Spec->catfile(
    File::HomeDir->my_home, qw/.cpan sources modules/, $index);
my $cpan = ($ENV{CPAN} || 'http://www.cpan.org/');
{
    local $/ = '/';
    chomp $cpan;
}
my $indexurl = "${cpan}/modules/${index}";

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
    $token =~ s/-/::/g;
    my $p = $packages->package($token)
        or die "Cannot find `${token}' in the CPAN index.\n";
    my $d = $p->distribution
        or die "Cannot map `${token}' to any CPAN distribution.\n";
    return $d;
}

sub _get_deps {
    my @files = @_;
    # TODO: Iterate over @files, run Tangerine and construct metadata
    # TODO: Extra -- utilize MCE
    my %modules;
    for my $file (@files) {
        my $scanner = Tangerine->new(file => $file);
        $scanner->run;
        for ((keys %{$scanner->package},
                keys %{$scanner->compile},
                keys %{$scanner->runtime})) {
            $modules{$_} = 1;
        }
        # TODO: Construct/add to fairy metadata here
    }
    return;
}

sub new {
    return bless {}, shift;
}

sub do {
    my ($self, $spell) = @_;
    _update_cpan_index();
    my $dist = _get_distribution($spell);
    my $meta = App::Fairy::Meta->new(magic => 'perl');

    $meta->data(name => $dist->dist);
    $meta->data(version => $dist->version);
    $meta->data(sources => "${cpan}/authors/id/" . $dist->pathname);
    $meta->data(url => "${cpan}/dist/" . $dist->dist);

    my $archive = File::Spec->catfile(File::Spec->curdir(), $dist->filename);
    fetch($meta->data('sources'), $archive)
        or die "Sources fetch failed.\n";
    my $dir = explode($archive);

    opendir my $dh, $dir
        or die "Cannot open `${dir}'!\n";
    my @f = grep { $_ !~ /^\.\.?$/o } readdir $dh;
    closedir $dh
        or die "Cannot close `${dir}'!\n";
    $dir = File::Spec->catdir($dir, $f[0])
        if scalar(@f) == 1 && -d File::Spec->catdir($dir, $f[0]);

    my $olddir = File::Spec->rel2abs(File::Spec->curdir);
    chdir $dir
        or die "Cannot change directory to `${dir}': $!";
    my $deps = _get_deps(
        # XXX: This probably only works on UNIX-like systems
        grep {
            !/^(contrib|maint|misc)\//o &&
            !/^xt\//o &&
            !/^t\/.*(author|release)/o
        } File::Find::Rule->perl_file->in(File::Spec->curdir)
    );
    chdir $olddir
        or die "Cannot change directory back to `${olddir}': $!";

    # TODO: Check $deps and construct builddep, runtime deps and test deps
    #       These should be separate so the templates can put them together
    #       as they please.

    # $meta->data(archd => );
    # #meta->data(license => );

    return $meta;
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
