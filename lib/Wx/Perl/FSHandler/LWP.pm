package Wx::Perl::FSHandler::LWP;

=head1 NAME

C<Wx::Perl::FSHandler::LWP> - file system handler based upon LWP

=head1 SYNOPSIS

  my $ua = LWP::UserAgent->new;

  # customize the User Agent, set proxy, supported protocols, ...

  my $handler = Wx::Perl::FSHandler::LWP->new( $ua );

  Wx::FileSystem::AddHandler( $handler );

=head1 DESCRIPTION

The C<Wx::Perl::FSHandler::LWP> is a C<wxFileSystemHandler>
implementation based upon C<LWP::UserAgent>, and is meant as a
superior replacement for C<wxInternetFSHandler>.

=cut

use strict;
use Wx::FS;
use base 'Wx::PlFileSystemHandler';
use LWP::UserAgent;
use IO::Scalar;

$Wx::Perl::FSHandler::LWP::VERSION = '0.01';

=head2 new

  my $handler = Wx::Perl::FSHandler::LWP->new( $ua );

Creates a new instance. C<$ua> must be an object of class
C<LWP::UserAgent>, which will be used to handle requests.

=cut

sub new {
    my( $class, $ua ) = @_;
    my $self = $class->SUPER::new;

    $self->{user_agent} = $ua;

    return $self;
}

sub CanOpen {
    my( $self, $location ) = @_;
    my $proto = $self->get_protocol( $location );

    return $self->user_agent->is_protocol_supported( $proto );
}

sub OpenFile {
    my( $self, $fs, $location ) = @_;
    my $request = HTTP::Request->new( 'GET', $location );
    my $response = $self->user_agent->request( $request, undef );

    return undef unless $response->is_success;

    my $value = $response->content;
    my $fh = IO::Scalar->new( \$value );
    my $file = Wx::FSFile->new( $fh, $location, $response->content_type,
                                $self->get_anchor( $location ) );

    return $file;
}

=head2 user_agent

  my $ua = $handler->user_agent;

Returns the C<LWP::UserAgent> object used to handle requests.

=cut

sub user_agent   { $_[0]->{user_agent} }
sub get_protocol { $_[1] =~ m/^(\w+):/ ? $1 : '' }
sub get_anchor   { $_[1] =~ m/#([^#]*)$/ ? $1 : '' }

=head1 ENVIRONMENTAL VARIABLES

See L<LWP::UserAgent|LWP::UserAgent>.

=head1 AUTHOR

Mattia Barbon <MBARBON@cpan.org>

=head1 LICENSE

Copyright (c) 2003 Mattia Barbon.

This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<LWP::UserAgent|LWP::UserAgent>

wxFileSystem and wxFileSystemHandler in wxPerl documentation.

=cut

1;
