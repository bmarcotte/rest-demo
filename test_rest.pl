#!/usr/bin/env perl

use strict;
use warnings;

my $host      = $ENV{SERVER_HOST} || 'localhost';
my $port      = $ENV{SERVER_PORT} || $ENV{PORT} || '8080';
my $base_url  = $ENV{BASE_URL} || "http://${host}:${port}/rest";
my $id        = $ENV{ROW_ID} || 1;
my %curl_args = (
    'bad_path'             => { path => 'bogus' },
    'bookmarks'            => {},
    'bookmarks_bad_method' => { method => 'POST' },
    'bookmark_bad_method'  => { method => 'GET' },
    'bookmark_add_form'    => { data => q{name=form_name&url=form_url} },
    'bookmark_add_json'    => { data => q{{ "name": "json add", "url": "http://json/add" }} },
    'bookmark_update_form' => { data => qq{id=$id&name=update_name&url=update_url} },
    'bookmark_update_json' => { data => qq{{ "id": $id, "name": "json update", "url": "http://json/update" }} },
    'bookmark_get_path'    => {},
    'bookmark_delete_form' => { data => qq{id=$id} },
    'bookmark_delete_json' => { data => qq{{ "id": $id }} },
    'bookmark_delete_path' => {},
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
    my @cmd = ( @curl_cmd, get_curl_args( $name ) );
    print "CMD[$name]: @cmd\n";

    system @cmd;
    print "\n\n";
}

sub get_curl_args {
  my ( $name ) = @_;

  return if ! defined $curl_args{ $name };

  my ( $endpoint, $action, $data_type ) = split m/ _ /msx, $name, 3;

  my @args = ();

  if ( $action ) {
    my %methods = (
      add    => 'POST',
      delete => 'DELETE',
      get    => 'GET',
      update => 'PUT',
    );
    $curl_args{ $name }->{method} ||= $methods{ $action };
  }
  if ( my $method = $curl_args{ $name }->{method} ) {
    push @args, ( q{-X} => $method );
  }

  if ( my $data = $curl_args{ $name }->{data} ) {
    push @args, ( q{-d} => $data );
  }

  if ( $data_type && $data_type eq 'json' ) {
    $curl_args{ $name }->{type} ||= $data_type;
  }
  if ( my $type = $curl_args{ $name }->{type} ) {
    if ( $type eq 'json' ) {
      $type = q{Content-Type: application/json};
    }
    push @args, ( q{-H} => $type );
  }

  if ( $endpoint ) {
    $curl_args{ $name }->{path} ||= ( $data_type && $data_type eq 'path' )
      ? "$endpoint/$id"
      : "$endpoint";
  }
  my $path = $curl_args{ $name }->{path} || q{};
  push @args, "${base_url}/$path";

  return @args;
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
