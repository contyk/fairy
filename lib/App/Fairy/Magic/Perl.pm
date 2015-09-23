package App::Fairy::Magic::Perl;
use strict;
use warnings;
use File::HomeDir;
use File::Path ();
use File::Spec;
use HTTP::Request;
use LWP::UserAgent;

sub _update_cpan_index {
    my $index = '02packages.details.txt.gz';
    my $indexpath = File::Spec->catfile(
        File::HomeDir->my_home, qw/.cpan sources modules/, $index);
    my $indexurl =
        ($ENV{CPAN} || "http://www.cpan.org/") . "/modules/${index}";
    File::Path->make_path((File::Spec->splitpath($indexpath))[1]);
    my $ua = LWP::UserAgent->new(env_proxy => 1);
    my $req = HTTP::Request->new(GET => $indexurl);
    $req->if_modified_since((stat($indexpath))[9]);
    my $res = $ua->request($req);
    if ($res->is_success) {
        open my $fh, '>', $indexpath;
        print $fh $res->content;
        close $fh;
        utime(time, $res->last_modified, $indexpath);
    } else {
        return unless $res->code eq '304';
    }
    return 1;
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
