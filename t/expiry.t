#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use File::Path              ();     # Perl core since v5.001
use File::Spec              ();     # Perl core since v5.004_05
use File::Temp              ();     # Perl core since v5.6.1
use CGI::Capture::Rotate    ();


is(setup_cleanup('1min', time() -           60, 10, 5), 5, "1min expiry");
is(setup_cleanup('1h',   time() -      60 * 60, 10, 6), 6, "1h expiry");
is(setup_cleanup('1d',   time() - 24 * 60 * 60, 10, 7), 7, "1d expiry");


# Create a temporary directory that's filled with the desired number of files
# before the cutoff and after the cutoff.
#
# Returns the path of the temp directory.
sub generate_expiry_directory {
    my ($cutoff, $num_before_cutoff, $num_after_cutoff) = @_;

    my $dir = File::Temp->newdir(CLEANUP => 0);

    my $now = time();

    for (1..$num_before_cutoff) {
        my ($fh, $filename) = File::Temp::tempfile(DIR => $dir, CLEANUP => 0);
        close $fh;
        my $time = $cutoff - rand(3600) - 1;
        utime($time, $time, $filename);
    }

    for (1..$num_after_cutoff) {
        my ($fh, $filename) = File::Temp::tempfile(DIR => $dir, CLEANUP => 0);
        close $fh;
        my $time = $cutoff + rand($now - $cutoff - 1) + 1;
        utime($time, $time, $filename);
    }

    return $dir;
}


# count the number of files inside the specified directory
sub count_files {
    my ($dir) = @_;
    my $count = 0;
    foreach my $file (glob(File::Spec->catfile($dir, '*'))) {
        if (-f $file) {
            $count++;
        }
    }
    return $count;
}


# Calls generate_expiry_directory(), CGI::Capture::Rotate::expire(),
# count_files(), and then File::Path::remove_tree().
#
# Returns the number of files as calculated by count_files().
sub setup_cleanup {
    my ($cutoff_text, $cutoff_seconds, $num_before_cutoff, $num_after_cutoff) = @_;

    my $tempdir = generate_expiry_directory($cutoff_seconds, $num_before_cutoff,
                        $num_after_cutoff);
    CGI::Capture::Rotate::expire(DIR => $tempdir, EXPIRE => $cutoff_text);
    my $count = count_files($tempdir);
    File::Path::remove_tree($tempdir);

    return $count;
}
