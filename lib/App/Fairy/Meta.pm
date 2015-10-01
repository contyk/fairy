package App::Fairy::Meta;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    bless {
        magic => $args{magic},
        data => {},
    }, $class;
}

sub magic {
    my ($self, $magic) = @_;
    $self->{magic} = $magic if defined($magic);
    return $self->{magic};
}

sub data {
    my ($self, $prop, $val) = @_;
    $self->{data}->{$prop} = $val if defined($val);
    return $self->{data}->{$prop};
}

sub delete {
    my ($self, $prop) = @_;
    my $val = $self->{data}->{$prop};
    delete $self->{data}->{$prop};
    return $val;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::Fairy::Meta - Fairy metadata structure

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 Petr Šabata

See LICENSE for licensing details.

=cut
