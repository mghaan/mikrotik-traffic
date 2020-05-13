#!/usr/bin/perl
package main;

use strict;
use utf8;
use CGI;
use DBD::SQLite;

print "HTTP/1.0 200 OK\n";
print "Content-Type: text/plain; charset=utf-8\n";
print "\n";

my $cgi = CGI->new;

my $start = $cgi->param("start");
my $end = $cgi->param("end");
my $id = $cgi->param("id");

print "date,tx,rx\n";

if (! $start eq "" && ! $id eq "") {
    $start = sprintf("%d", $start);
    $id = sprintf("%d", $id);

    my $sql = "select timestamp as date, dtx as 'tx', drx as 'rx' from traffic where device = " . $id . " and timestamp >= " . $start;

    if (! $end eq "") {
        $end = sprintf("%d", $end);
        $sql = "select timestamp as date, sum(dtx) as 'tx', sum(drx) as 'rx' from traffic where device = " . $id . " and timestamp >= " . $start;
    }

    my $db = DBI->connect("dbi:SQLite:dbname=mikrotik.sqlite", "", "");

    my $cmd = $db->prepare($sql);
    $cmd->execute();
    while(my @row = $cmd->fetchrow_array()) {
        print $row[0] . "," . $row[1] . "," . $row[2] . "\n";
    }
    $db->disconnect();
}