# NAME

CGI::Capture::Rotate - Provide "log rotation"-like functionality for CGI::Capture files

# SYNOPSIS

    use CGI::Capture::Rotate '/var/tmp/capture_files/';

    use CGI::Capture::Rotate DIR => '/var/tmp/capture_files/', EXPIRE => '12h',
                                                           TEMPLATE => 'appnameXXXXXX', SUFFIX => '.storable';

`TEMPLATE` and `SUFFIX` are actually passed directly on to [File::Temp](https://metacpan.org/pod/File::Temp).
`EXPIRE` can be '3m', '3h', '3d', '3mo', or '3y'.

# DESCRIPTION

Provides two features: This module automatically chooses a unique filename for
the [CGI::Capture](https://metacpan.org/pod/CGI::Capture) file (instead of always recording to the same file), and it
also removes CGI::Capture files that have expired (by default, after three
days).

Additionally, a command-line tool is provided which helps to locate the specific
capture file that you might be interested in applying. Alternately, you can
employ 'use [if](https://metacpan.org/pod/if)' to only enable captures based on a specific User-Agent
string, for example.

# AUTHOR

Dee Newcum <deenewcum@cpan.org>

# CONTRIBUTING

Please use Github's issue tracker to file both bugs and feature requests.
Contributions to the project in form of Github's pull requests are welcome. 

# LICENSE

This library is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.
