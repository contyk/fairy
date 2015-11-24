package App::Fairy::Utils;
use strict;
use warnings;
use Archive::Extract;
use Exporter qw/import/;
use File::Path;
use File::Spec;
use File::Temp qw/tempdir/;
use HTTP::Request;
use LWP::UserAgent;

our @EXPORT_OK = qw/explode fetch/;

sub explode {
    my $file = shift;
    my $dir = tempdir('fairy-XXXXXX', DIR => File::Spec->tmpdir(), CLEANUP => 1);
    my $ae = Archive::Extract->new(archive => $file);
    eval {
        $ae->extract(to => $dir);
    } or die "Failed to extract ${file}.\n";
    return $dir;
}

sub fetch {
    my ($src, $dst, $flags) = @_;
    File::Path::make_path((File::Spec->splitpath($dst))[1]);
    my $ua = LWP::UserAgent->new(env_proxy => 1); 
    my $req = HTTP::Request->new(GET => $src);
    $req->if_modified_since((stat($dst))[9])
        if (-f $dst && !$flags->{force});
    my $res = $ua->request($req)
        or die "LWP::UserAgent request (${src}) failsd: $!\n";
    if ($res->is_success) {
        open my $fh, '>:raw', $dst
            or die "Cannot open `${dst}': $!\n";
        print $fh $res->content;
        close $fh
            or die "Cannot close `${dst}': $!\n";
        utime(time, $res->last_modified, $dst)
            if $res->last_modified;
    } else {
        return unless $res->code == 304;
    }   
    return 1;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::Fairy::Utils - Various Fairy utility subroutines

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 Petr Šabata

See LICENSE for licensing details.

=cut
