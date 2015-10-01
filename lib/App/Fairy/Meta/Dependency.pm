package App::Fairy::Meta::Dependency;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    bless {
        magic => $args{magic},
        data => {},
    }, $class;
}

sub data {
    my ($self, $prop, $val) = @_;
    $self->{$prop} = $val if defined($val);
    return $self->{$prop};
}

sub delete {
    my ($self, $prop) = @_;
    my $val = $self->{$prop};
    delete $self->{$prop};
    return $val;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::Fairy::Meta::Dependency - Fairy dependency metadata structure

=head1 AUTHOR

Petr Šabata <contyk@redhat.com>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2015 Petr Šabata

See LICENSE for licensing details.

=cut
