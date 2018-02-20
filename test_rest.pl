#!/usr/bin/env perl

use strict;
use warnings;

my $base_url      = $ENV{BASE_URL} || 'http://localhost:8080/rest';
my $bookmark_url  = "${base_url}/bookmark";
my $bookmarks_url = "${base_url}/bookmarks";
my %params        = (
  add_form    => q{name=form_name&url=form_url},
  add_json    => q{{ "name": "json add", "url": "http://json/add" }},
  delete_form => q{id=1},
  update_form => q{id=1&name=update_name&url=update_url},
  update_json => q{{ "id": 1, "name": "json update", "url": "http://json/update" }},
);
my %curl_args = (
    'bad_path'             => [ "${base_url}/bogus" ],
    'bookmarks'            => [ $bookmarks_url ],
    'bookmarks_bad_method' => [ qw( -X POST ), $bookmarks_url ],
    'bookmark_bad_method'  => [ qw( -X GET ),  $bookmark_url  ],
    'bookmark_add_form'    => [ qw( -X POST -d ), $params{add_form}, $bookmark_url ],
    'bookmark_add_json'    => [ qw( -X POST -d ), $params{add_json}, qw( -H ), q{Content-Type: application/json}, $bookmark_url ],
    'bookmark_update_form' => [ qw( -X PUT -d ), $params{update_form}, $bookmark_url ],
    'bookmark_update_json' => [ qw( -X PUT -d ), $params{update_json}, qw( -H ), q{Content-Type: application/json}, $bookmark_url ],
    'bookmark_get'         => [ $bookmark_url . q{/1} ],
    'bookmark_delete_form' => [ qw( -X DELETE -d ), $params{delete_form}, $bookmark_url ],
    'bookmark_delete_path' => [ qw( -X DELETE ), $bookmark_url . q{/1} ],
);

my @curl_cmd   = qw( curl );
my @clean_args = ();

foreach my $name ( @ARGV ) {
    next if ! $name;

    $name =~ s/ ^[-]+ //msx;

    if ( $name eq 'list' ) {
        my @cmds = sort keys %curl_args;
        print join "\n\t", 'Available test names:', @cmds;
        print "\n";
        exit;
    }

    if ( $name eq 'help' ) {
        exec qw( perldoc ), __FILE__;
    }

    if ( $name eq 'v' || $name eq 'verbose' ) {
      push @curl_cmd, qw( -v );
      next;
    }

    if ( $name eq 'preview' ) {
      unshift @curl_cmd, qw( echo );
      next;
    }

    if ( ! defined $curl_args{ $name } ) {
        warn "Couldn't find command arguments for test: $name\n\n";
        next;
    }

    push @clean_args, $name;
}

foreach my $name ( @clean_args ) {
    my @cmd = ( @curl_cmd, @{ $curl_args{ $name } } );
    print "CMD[$name]: @cmd\n";

    system @cmd;
    print "\n\n";
}

__END__
=head1 NAME

test_rest.pl - A script to perform simple test requests of the Bookmark API endpoints

=head1 SYNOPSIS

  test_rest.pl --help
  test_rest.pl --list
  test_rest.pl [--verbose] [--preview] <tests...>

=head1 DESCRIPTION

This script can be used to send a variety of test requests to the Bookmark API application,
and view the resulting response.

=head1 OPTIONS

=head2 help or --help

Displays this help documentation and then exits.

=head2 list or --list

Lists the names of all of the available tests and then exits.

=head2 preview or --preview

For each of the requested tests, only print the command that would executed, but do not actually run them.

=head2 verbose or -v or --verbose

Passes a C<-v> argument along to the curl commands to request verbose output,
which should include the request and response headers.

=head1 TESTS

Note: all tests should return a JSON formatted response.

=head2 bad_path

Makes a GET request to an endpoint that doesn't exist.

=head2 bookmark_add_form

Makes a POST request to the /bookmark endpoint, with name and url specified as URL encoded form parameters.

=head2 bookmark_add_json

Makes a POST request to the /bookmark endpoint, with name and url parameters formatted as JSON.

=head2 bookmark_bad_method

Makes a GET request to the /bookmark endpoint, but without any name or url parameters provided.

=head2 bookmark_delete_form

Makes a DELETE request to the /bookmark endpoint, with id specified as a URL encoded form parameter.

=head2 bookmark_delete_path

Makes a DELETE request to the /bookmark endpoint, with id specified as part of the URI path.

=head2 bookmark_update_form

Makes a PUT request to the /bookmark endpoint, with id, name and url specified as URL encoded form parameters.

=head2 bookmark_update_json

Makes a PUT request to the /bookmark endpoint, with id, name and url parameters formatted as JSON.

=head2 bookmarks

Makes a GET request to the /bookmarks endpoint.

=head2 bookmarks_bad_method

Makes a POST request to the /bookmarks endpoint.

=cut
