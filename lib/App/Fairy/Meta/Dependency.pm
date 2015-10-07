package App::Fairy::Meta::Dependency;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    bless {
        name => $args{name},
        occurences => ref $args{occurences} eq 'ARRAY' // [],
    }, $class;
}

sub name {
    my $self = shift;
    $self->{name} = shift if @_;
    return $self->{name};
}

sub occurences {
    my $self = shift;
    $self->{occurences} = shift if @_ && ref $_[0] eq 'ARRAY';
    return $self->{occurences};
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
