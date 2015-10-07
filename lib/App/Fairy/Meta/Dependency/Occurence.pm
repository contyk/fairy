package App::Fairy::Meta::Dependency::Occurence;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    bless {
        type => $args{type},
        file => $args{file},
    }, $class;
}

sub type {
    my $self = shift;
    $self->{type} = shift if @_;
    return $self->{type};
}

sub file {
    my $self = shift;
    $self->{file} = shift if @_;
    return $self->{file};
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::Fairy::Meta::Dependency::Occurence - Fairy dependency occurence metadata
structure

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 Petr Šabata

See LICENSE for licensing details.

=cut
