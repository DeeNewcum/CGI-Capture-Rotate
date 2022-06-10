# NAME

CGI::Capture::Rotate — Provides "log rotation"-like functionality for
CGI::Capture files

# SYNOPSIS

If you want to use the [single-step debugger](https://metacpan.org/pod/perldebug) on a CGI script,
[CGI::Capture](https://metacpan.org/pod/CGI%3A%3ACapture) is an extremely useful tool. It records almost all aspects of a
script's environment, allowing you to replay that environment from the command
line, so the script thinks it's still running underneath the webserver, even
though it's running at the terminal under an interactive debugger.

CGI::Capture::Rotate makes that tool even easier to use.  Put this at the top of
your CGI script:

    use CGI::Capture::Rotate '/var/tmp/capture_files/';

A random filename will be chosen in that directory, and a capture file recorded.

Then, at the command line:

    $ cd /var/tmp/capture_files/
    $ ls_captures

# DESCRIPTION

Provides two features: This module automatically chooses a unique filename for
the [CGI::Capture](https://metacpan.org/pod/CGI%3A%3ACapture) file, and it also removes CGI::Capture files that have
expired — by default, ones older than three days.

Additionally, a command-line tool (`ls_captures`) helps to locate the specific
capture file that you might be interested in applying.

Another way to locate the desired capture file is to simply record fewer capture
files, by only triggering a capture in certain specific instances, using [if](https://metacpan.org/pod/if):

    use if $ENV{HTTP_USER_AGENT} =~ /special trigger/, 'CGI::Capture::Rotate'
               => '/var/tmp/capture_files/';

A [user-agent switcher](https://chrome.google.com/webstore/detail/user-agent-switcher-for-c/djflhoibgkdhkhhcedjiklpkjnoahfmg?hl=en-US) 
is very handy in this case, as it allows you to insert `"special trigger"` into 
your User-Agent string, selectively.

# PARAMETERS

    use CGI::Capture::Rotate DIR => '/var/tmp/capture_files/', EXPIRE => '12h',
                             TEMPLATE => 'appnameXXXXXX', SUFFIX => '.storable';

`TEMPLATE` is a filename that ends with several `X`s, which will be replaced
by random characters. `SUFFIX` will be appended to the filename. (both are
passed directly to [File::Temp](https://metacpan.org/pod/File%3A%3ATemp))

`EXPIRE` can be '3min', '3h', '3d', '3m', or '3y'.

# AUTHOR

Dee Newcum <deenewcum@cpan.org>

# CONTRIBUTING

Please use Github's issue tracker to file both bugs and feature requests.
Contributions to the project in form of Github's pull requests are welcome. 

# LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.
