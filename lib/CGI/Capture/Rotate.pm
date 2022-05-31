package CGI::Capture::Rotate;

our $VERSION = 0.01;

=pod

=head1 NAME

CGI::Capture::Rotate - Provide "log rotation"-like functionality for CGI::Capture files

=head1 SYNOPSIS

 use CGI::Capture::Rotate '/var/tmp/capture_files/';

 use CGI::Capture::Rotate DIR => '/var/tmp/capture_files/', EXPIRE => '12h',
                          TEMPLATE => 'appnameXXXXXX', SUFFIX => '.storable';

C<TEMPLATE> and C<SUFFIX> are actually passed directly on to L<File::Temp>.
C<EXPIRE> can be '3m', '3h', '3d', '3mo', or '3y'.

=head1 DESCRIPTION

Provides two features: This module automatically chooses a unique filename for
the L<CGI::Capture> file (instead of always recording to the same file), and it
also removes CGI::Capture files that have expired (by default, ones older than
three days).

Additionally, a command-line tool is provided which helps to locate the specific
capture file that you might be interested in applying. Alternately, you can
employ 'use L<if>' to only enable captures based on a specific User-Agent
string, for example.

=head1 AUTHOR

Dee Newcum <deenewcum@cpan.org>

=head1 CONTRIBUTING

Please use Github's issue tracker to file both bugs and feature requests.
Contributions to the project in form of Github's pull requests are welcome. 

=head1 LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=cut

use strict;
use warnings;

use Carp;
use CGI::Capture        ();
use File::Temp          ();     # Perl core since v5.6.1
use Storable            ();     # Perl core since v5.7.3

sub import {
    my $class = shift;
    my %options;
    if (@_ == 1) {
        %options = _parse_args(DIR => shift);
    } else {
        %options = _parse_args(@_);
    }
    $options{DIR} or croak "A directory *must* be specified.\n";
    my ($fh, $filename) = unique_filename(%options);
    # TODO: add more error-checking here
    my $capture = CGI::Capture->new()->capture();
    Storable::nstore_fd($capture, $fh);
    expire(%options);
}


# Generates a unique filename. Pass in the same options that you'd pass in to
# import().
#
# Returns ($fh, $filename)
sub unique_filename {
    my %options = _parse_args(@_);
    $options{DIR} or croak "A directory *must* be specified.\n";
    # UNLINK=>0 because we're not actually using File::Temp because of its
    # temp-file capabilities, but rather its ability to use TEMPLATE and SUFFIX.
    my ($fh, $filename) = File::Temp::tempfile(UNLINK => 0, %options);
    return ($fh, $filename);
}


sub expire {
    # TODO: implement this
}


# returns a fully-formed hash, with defaults filled out and such
sub _parse_args {
    my %args = @_;
    # taken from File::Temp::_parse_args() -- make sure all keys are uppercase
    %args = map +(uc($_) => $args{$_}), keys %args;
    # default values
    exists $args{TEMPLATE} or $args{TEMPLATE} = 'XXXXXXXX';
    exists $args{EXPIRE}   or $args{EXPIRE} = '3h';
    # Note that we do NOT provide a default value for DIR. We want to error out
    # if that isn't included.
    return %args;
}

1;
